import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/export/export_service.dart';
import '../../core/backup/backup_service.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';

final _cartridgesProvider = StreamProvider.autoDispose((ref) => ref
    .watch(databaseProvider)
    .select(ref.watch(databaseProvider).cartridges)
    .watch());
final _loadsProvider = StreamProvider.autoDispose((ref) => ref
    .watch(databaseProvider)
    .select(ref.watch(databaseProvider).loads)
    .watch());
final _sessionsProvider = StreamProvider.autoDispose((ref) => ref
    .watch(databaseProvider)
    .select(ref.watch(databaseProvider).rangeSessions)
    .watch());

/// The long view of the notebook — Pro, like every CC trends screen.
/// Restoring a backup is never gated.
class TrendsScreen extends ConsumerWidget {
  const TrendsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pro = ref.watch(isProProvider).value ?? false;
    return Scaffold(
      appBar: AppBar(title: const Text('Trends')),
      body: pro
          ? const _TrendsContent()
          : ProTeaser(
              icon: Icons.insights_outlined,
              headline: 'The long arc of your load development.',
              body: 'Loads developed over time for every cartridge, '
                  'plus CSV export and full backup — part of '
                  'Loadbook Pro.',
              ctaLabel: 'See Loadbook Pro',
              onSeePro: () => showPaywallSheet(context),
              ungatedLabel: 'Restore a backup',
              onUngated: () => restoreBackupFlow(context, ref),
            ),
    );
  }
}

class _TrendsContent extends ConsumerWidget {
  const _TrendsContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cartridges = ref.watch(_cartridgesProvider).value;
    final loads = ref.watch(_loadsProvider).value;
    final sessions = ref.watch(_sessionsProvider).value;
    if (cartridges == null || loads == null || sessions == null) {
      return const Center(child: CircularProgressIndicator());
    }

    Widget section(String title, Widget child) => Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.textTheme.titleSmall),
              const SizedBox(height: 8),
              child,
            ],
          ),
        );

    return ListView(
      padding: const EdgeInsets.only(bottom: 32),
      children: [
        section(
          'The notebook so far',
          Text(
            countHeadline([
              CountedSubject(cartridges.length, 'cartridge'),
              CountedSubject(loads.length, 'load'),
              CountedSubject(sessions.length, 'range session'),
            ]),
            style: theme.textTheme.titleMedium,
          ),
        ),
        for (final cartridge in cartridges)
          if (loads.any((l) => l.cartridgeId == cartridge.id))
            section(
              cartridge.name,
              _YearBars(loads: [
                for (final l in loads)
                  if (l.cartridgeId == cartridge.id) l,
              ]),
            ),
        section(
          'Your notebook, portable',
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              OutlinedButton.icon(
                icon: const Icon(Icons.table_chart_outlined),
                label: const Text('Share loads as CSV'),
                onPressed: () => _shareCsv(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.archive_outlined),
                label: const Text('Back up the whole notebook'),
                onPressed: () => _shareBackup(context, ref),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                icon: const Icon(Icons.settings_backup_restore),
                label: const Text('Restore a backup'),
                onPressed: () => restoreBackupFlow(context, ref),
              ),
            ],
          ),
        ),
      ],
    );
  }

  ExportService _exporter(WidgetRef ref) => ExportService(
        ref.read(databaseProvider),
        ref.read(shareLauncherProvider),
        ref.read(tempDirProvider),
        photos: ref.read(photoServiceProvider),
      );

  Future<void> _shareCsv(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _exporter(ref).shareLoadsCsv();
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Export failed: $e')));
    }
  }

  Future<void> _shareBackup(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final lifetime =
          await ref.read(cartridgeRepositoryProvider).lifetimeCreated();
      await _exporter(ref).shareBackup(lifetimeCartridges: lifetime);
    } on Exception catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Backup failed: $e')));
    }
  }
}

/// Loads developed per year, oldest to newest — the user's own pace,
/// drawn to scale against the busiest year.
class _YearBars extends StatelessWidget {
  const _YearBars({required this.loads});

  final List<Load> loads;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final perYear = <int, int>{};
    for (final l in loads) {
      perYear[l.dateDeveloped.year] =
          (perYear[l.dateDeveloped.year] ?? 0) + 1;
    }
    final years = perYear.keys.toList()..sort();
    final busiest = perYear.values.reduce((a, b) => a > b ? a : b);
    return Column(
      children: [
        for (final year in years)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Row(
              children: [
                SizedBox(
                    width: 44,
                    child:
                        Text('$year', style: theme.textTheme.bodySmall)),
                Expanded(
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: perYear[year]! / busiest,
                    child: Container(
                      height: 14,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text('${perYear[year]}',
                    style: theme.textTheme.bodySmall),
              ],
            ),
          ),
      ],
    );
  }
}

/// The shared cc_core restore flow with Loadbook's words and tally
/// raise. Available to free users — restoring your own notebook is
/// never gated.
Future<void> restoreBackupFlow(BuildContext context, WidgetRef ref) async {
  await runRestoreFlow(
    context,
    confirmBody: 'The notebook on this phone is replaced with the backup '
        '— cartridges, loads, range sessions, and inventory. This cannot '
        'be undone.',
    photoStore: ref.read(photoServiceProvider),
    restore: (contents) async {
      final lifetime = await restoreFromExportData(
          ref.read(databaseProvider), contents.exportData);
      await ref.read(cartridgeTallyProvider).raiseTo(lifetime);
    },
  );
}
