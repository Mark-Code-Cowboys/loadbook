import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/load_repository.dart';
import '../../data/repositories/range_session_repository.dart';
import '../monetization/monetization_providers.dart';
import '../sessions/session_composer_screen.dart';

final _loadProvider = StreamProvider.autoDispose
    .family<LoadWithStory?, int>(
        (ref, id) => ref.watch(loadRepositoryProvider).watchOne(id));

final _sessionsProvider = StreamProvider.autoDispose
    .family<List<SessionWithStory>, int>((ref, loadId) =>
        ref.watch(rangeSessionRepositoryProvider).watchByLoad(loadId));

/// The index card, digitized: the recipe on top, every range trip with
/// it underneath.
class LoadDetailScreen extends ConsumerWidget {
  const LoadDetailScreen({super.key, required this.loadId});

  final int loadId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = ref.watch(_loadProvider(loadId)).value;
    final sessions = ref.watch(_sessionsProvider(loadId)).value ?? const [];
    final theme = Theme.of(context);
    if (item == null) return const Scaffold(body: SizedBox.shrink());
    return Scaffold(
      appBar: AppBar(
        title: Text('${formatDecimal(item.load.chargeGr)} gr '
            '${item.powder.name}'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) => switch (choice) {
              'delete' => _confirmDelete(context, ref),
              _ => Future<void>.value(),
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete load')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => SessionComposerScreen(loadId: loadId))),
        icon: const Icon(Icons.add),
        label: const Text('Log session'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 88),
        children: [
          _RecipeCard(item: item, onStatus: (s) =>
              ref.read(loadRepositoryProvider).setStatus(loadId, s)),
          if (item.notes != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(4, 12, 4, 0),
              child: Text(item.notes!, style: theme.textTheme.bodyMedium),
            ),
          if (ref.watch(isProProvider).value ?? false)
            _LoadTrends(sessions: sessions),
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 24, 4, 4),
            child: Text('Range sessions',
                style: theme.textTheme.titleSmall),
          ),
          if (sessions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'No trips logged with this load yet.',
                style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant),
              ),
            ),
          for (final s in sessions) _SessionCard(item: s),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this load?'),
        content: const Text('Its range sessions, notes, and target photos '
            'go with it. This cannot be undone.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              child: const Text('Delete')),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(loadRepositoryProvider).delete(loadId);
    if (context.mounted) Navigator.of(context).pop();
  }
}

/// The recipe exactly as the user wrote it. Rows render what was
/// entered and nothing else — no derived judgments (rails).
class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.item, required this.onStatus});

  final LoadWithStory item;
  final ValueChanged<LoadStatus> onStatus;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = item.load;
    String component(Component? c, {bool weight = false}) => c == null
        ? '—'
        : [
            c.maker,
            c.name,
            if (weight && c.weightGr != null)
              '${formatDecimal(c.weightGr!)}gr',
            if (c.bulletType != null && weight) c.bulletType!,
            if (c.lot != null) '(lot ${c.lot})',
          ].join(' ');
    final rows = <(String, String)>[
      ('Bullet', component(item.bullet, weight: true)),
      ('Powder', '${formatDecimal(l.chargeGr)} gr '
          '${component(item.powder)}'),
      ('Primer', component(item.primer)),
      ('Brass', component(item.brass)),
      if (l.coalIn != null) ('COAL', '${formatDecimal(l.coalIn!)}"'),
      if (l.crimp != null) ('Crimp', l.crimp!),
      ('Developed', formatDate(l.dateDeveloped)),
    ];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (label, value) in rows)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 88,
                      child: Text(label,
                          style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant)),
                    ),
                    Expanded(
                        child:
                            Text(value, style: theme.textTheme.bodyLarge)),
                  ],
                ),
              ),
            const SizedBox(height: 12),
            SegmentedButton<LoadStatus>(
              segments: const [
                ButtonSegment(
                    value: LoadStatus.working, label: Text('Working')),
                ButtonSegment(
                    value: LoadStatus.keeper, label: Text('Keeper')),
                ButtonSegment(
                    value: LoadStatus.retired, label: Text('Retired')),
              ],
              selected: {l.status},
              onSelectionChanged: (s) => onStatus(s.single),
            ),
          ],
        ),
      ),
    );
  }
}

/// Per-load trends (Pro): group size over sessions and the chrono SD
/// line — the user's own measurements over time, nothing judged.
class _LoadTrends extends StatelessWidget {
  const _LoadTrends({required this.sessions});

  final List<SessionWithStory> sessions;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Oldest first for the time axis (the list renders newest first).
    final ordered = sessions.reversed.toList();
    final groups = <(DateTime, num)>[
      for (final s in ordered)
        if (s.session.groupSizeIn != null)
          (s.session.date, s.session.groupSizeIn!),
    ];
    final sds = <(DateTime, num)>[
      for (final s in ordered)
        if (s.session.chronoSdFps != null)
          (s.session.date, s.session.chronoSdFps!),
    ];
    if (groups.length < 2 && sds.length < 2) {
      return const SizedBox.shrink();
    }
    Widget section(String title, List<(DateTime, num)> points) => Padding(
          padding: const EdgeInsets.fromLTRB(4, 16, 4, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              SimpleLineChart(points: points, height: 96),
            ],
          ),
        );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (groups.length >= 2)
          section('Group size over sessions (in)', groups),
        if (sds.length >= 2) section('Chrono SD over sessions', sds),
      ],
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.item});

  final SessionWithStory item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final s = item.session;
    final line2 = [
      '${s.distanceYd} yd',
      '${s.shots} shots',
      if (s.groupSizeIn != null)
        '${formatDecimal(s.groupSizeIn!)}"'
            '${item.moa == null ? '' : ' (${item.moa!.toStringAsFixed(2)} MOA)'}',
    ].join(' · ');
    final chrono = [
      if (s.chronoAvgFps != null)
        'avg ${formatDecimal(s.chronoAvgFps!)} fps',
      if (s.chronoSdFps != null) 'SD ${formatDecimal(s.chronoSdFps!)}',
      if (s.chronoEsFps != null) 'ES ${formatDecimal(s.chronoEsFps!)}',
    ].join(' · ');
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(formatDate(s.date), style: theme.textTheme.titleSmall),
                const Spacer(),
                if (item.photos.isNotEmpty) ...[
                  Icon(Icons.photo_outlined,
                      size: 16, color: theme.colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('${item.photos.length}',
                      style: theme.textTheme.labelMedium),
                ],
              ],
            ),
            if (s.firearm != null)
              Text(s.firearm!,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text(line2, style: theme.textTheme.bodyMedium),
            if (chrono.isNotEmpty)
              Text(chrono, style: theme.textTheme.bodyMedium),
            if (s.weather != null)
              Text(s.weather!,
                  style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant)),
            if (item.notes != null) ...[
              const SizedBox(height: 4),
              Text(item.notes!, style: theme.textTheme.bodyMedium),
            ],
          ],
        ),
      ),
    );
  }
}
