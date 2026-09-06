import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import '../../data/repositories/cartridge_repository.dart';
import '../cartridges/cartridge_detail_screen.dart';
import '../monetization/free_limit.dart';

/// The front page's live list: chapters with their load counts.
final cartridgeListProvider =
    StreamProvider<List<CartridgeListItem>>((ref) =>
        ref.watch(cartridgeRepositoryProvider).watchAllWithLoadCounts());

/// The notebook's front page: every cartridge with its load count.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartridgeListProvider).value ?? const [];
    final count = ref.watch(cartridgeCountProvider).value ?? 0;
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Loadbook')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addCartridge(context, ref, count),
        icon: const Icon(Icons.add),
        label: const Text('Add cartridge'),
      ),
      body: items.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.menu_book_outlined,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Your reloading notebook.',
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center),
                    const SizedBox(height: 8),
                    Text(
                      'Start a page for a cartridge you load, then put '
                      'your recipes and range trips under it.',
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
                // Phase C hides this for Pro owners (usage null there).
                FreeTierCounter(
                  usage: cartridgesLimit.usage(count),
                  margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                  onGoPro: () => showPaywallSheet(context),
                ),
                for (final item in items)
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          theme.colorScheme.surfaceContainerHighest,
                      foregroundColor: theme.colorScheme.primary,
                      child: const Icon(Icons.bookmark_outline),
                    ),
                    title: Text(item.cartridge.name),
                    subtitle: Text(switch (item.loadCount) {
                      0 => 'No loads yet',
                      1 => '1 load',
                      final n => '$n loads',
                    }),
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => CartridgeDetailScreen(
                            cartridgeId: item.cartridge.id),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }

  Future<void> _addCartridge(
      BuildContext context, WidgetRef ref, int count) async {
    try {
      cartridgesLimit.guard(used: count, entitled: false);
    } on FreeLimitReachedException {
      await showPaywallSheet(context);
      return;
    }
    if (!context.mounted) return;
    final draft = await showDialog<({String name, String? notes})>(
      context: context,
      builder: (_) => const _CartridgeDialog(),
    );
    if (draft == null) return;
    await ref
        .read(cartridgeRepositoryProvider)
        .create(name: draft.name, notes: draft.notes);
  }
}

/// Names a chapter. Stateful so the dialog owns its controllers and
/// disposal survives the exit animation.
class _CartridgeDialog extends StatefulWidget {
  const _CartridgeDialog();

  @override
  State<_CartridgeDialog> createState() => _CartridgeDialogState();
}

class _CartridgeDialogState extends State<_CartridgeDialog> {
  final _name = TextEditingController();
  final _notes = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('New cartridge'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _name,
            autofocus: true,
            decoration: const InputDecoration(
                labelText: 'Cartridge', hintText: 'However you write it'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(labelText: 'Notes'),
            maxLines: 2,
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final name = _name.text.trim();
            if (name.isEmpty) return;
            final notes = _notes.text.trim();
            Navigator.of(context)
                .pop((name: name, notes: notes.isEmpty ? null : notes));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
