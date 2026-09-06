import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/load_repository.dart';
import '../loads/load_composer_screen.dart';
import '../loads/load_detail_screen.dart';

final _cartridgeProvider =
    StreamProvider.autoDispose.family<Cartridge?, int>((ref, id) => ref
        .watch(databaseProvider)
        .select(ref.watch(databaseProvider).cartridges)
        .watch()
        .map((rows) => rows.where((c) => c.id == id).firstOrNull));

final _loadsProvider = StreamProvider.autoDispose
    .family<List<LoadWithStory>, int>((ref, cartridgeId) =>
        ref.watch(loadRepositoryProvider).watchByCartridge(cartridgeId));

/// One chapter: the cartridge's loads grouped by where the user says
/// they stand — working, keepers, retired.
class CartridgeDetailScreen extends ConsumerWidget {
  const CartridgeDetailScreen({super.key, required this.cartridgeId});

  final int cartridgeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartridge = ref.watch(_cartridgeProvider(cartridgeId)).value;
    final loads = ref.watch(_loadsProvider(cartridgeId)).value ?? const [];
    final theme = Theme.of(context);
    if (cartridge == null) {
      return const Scaffold(body: SizedBox.shrink());
    }
    final sections = [
      (LoadStatus.working, 'Working'),
      (LoadStatus.keeper, 'Keepers'),
      (LoadStatus.retired, 'Retired'),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(cartridge.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (choice) => switch (choice) {
              'delete' => _confirmDelete(context, ref, cartridge),
              _ => Future<void>.value(),
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'delete', child: Text('Delete cartridge')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => LoadComposerScreen(cartridgeId: cartridgeId))),
        icon: const Icon(Icons.add),
        label: const Text('Add load'),
      ),
      body: loads.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.style_outlined,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('No loads on this page yet.',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Add a load to digitize its index card — components, '
                      'charge, and your notes, exactly as you wrote them.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          : ListView(
              padding: const EdgeInsets.only(bottom: 88),
              children: [
                if (cartridge.notes != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                    child: Text(cartridge.notes!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant)),
                  ),
                for (final (status, label) in sections) ...[
                  if (loads.any((l) => l.load.status == status)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      child:
                          Text(label, style: theme.textTheme.titleSmall),
                    ),
                    for (final l in loads)
                      if (l.load.status == status) _LoadTile(item: l),
                  ],
                ],
              ],
            ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, WidgetRef ref, Cartridge cartridge) async {
    final repo = ref.read(cartridgeRepositoryProvider);
    final loadCount = await repo.loadCount(cartridge.id);
    if (!context.mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Delete ${cartridge.name}?'),
        content: Text(loadCount == 0
            ? 'This page has no loads.'
            : 'Its $loadCount ${loadCount == 1 ? 'load goes' : 'loads go'} '
                'with it, along with their range sessions and notes. This '
                'cannot be undone.'),
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
    await repo.delete(cartridge.id);
    if (context.mounted) Navigator.of(context).pop();
  }
}

class _LoadTile extends StatelessWidget {
  const _LoadTile({required this.item});

  final LoadWithStory item;

  @override
  Widget build(BuildContext context) {
    final l = item;
    final bulletBits = [
      l.bullet.maker,
      l.bullet.name,
      if (l.bullet.weightGr != null) '${formatDecimal(l.bullet.weightGr!)}gr',
    ].join(' ');
    return ListTile(
      title: Text(bulletBits),
      subtitle: Text(
          '${formatDecimal(l.load.chargeGr)} gr ${l.powder.name} · '
          '${formatDate(l.load.dateDeveloped)}'),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => LoadDetailScreen(loadId: l.load.id))),
    );
  }
}
