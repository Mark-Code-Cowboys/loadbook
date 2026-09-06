import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/inventory_repository.dart';
import '../components/component_picker.dart';

final _inventoryProvider = StreamProvider.autoDispose(
    (ref) => ref.watch(inventoryRepositoryProvider).watchAll());

/// The shelf: what's on hand per component, in the user's own units,
/// updated by hand (v1 keeps no automatic decrement). Costs are the
/// user's paid prices only (rails).
class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lines = ref.watch(_inventoryProvider).value ?? const [];
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _addLine(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add to shelf'),
      ),
      body: lines.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.inventory_2_outlined,
                        size: 64, color: theme.colorScheme.primary),
                    const SizedBox(height: 16),
                    Text('Nothing on the shelf yet.',
                        style: theme.textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text(
                      'Track what you have on hand — powder, primers, '
                      'bullets, brass — in whatever units you count in.',
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
                for (final kind in ComponentKind.values)
                  if (lines.any((l) => l.component.kind == kind)) ...[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
                      child: Text(_kindHeader(kind),
                          style: theme.textTheme.titleSmall),
                    ),
                    for (final line in lines)
                      if (line.component.kind == kind)
                        _InventoryTile(line: line),
                  ],
              ],
            ),
    );
  }

  Future<void> _addLine(BuildContext context, WidgetRef ref) async {
    final kind = await showModalBottomSheet<ComponentKind>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final kind in ComponentKind.values)
              ListTile(
                title: Text(_kindHeader(kind)),
                onTap: () => Navigator.of(context).pop(kind),
              ),
          ],
        ),
      ),
    );
    if (kind == null || !context.mounted) return;
    final component = await pickComponent(context, ref, kind: kind);
    if (component == null || !context.mounted) return;
    final existing = await ref
        .read(inventoryRepositoryProvider)
        .getForComponent(component.id);
    if (!context.mounted) return;
    await _editLine(context, ref, component, existing);
  }
}

String _kindHeader(ComponentKind kind) => switch (kind) {
      ComponentKind.powder => 'Powder',
      ComponentKind.primer => 'Primers',
      ComponentKind.bullet => 'Bullets',
      ComponentKind.brass => 'Brass',
    };

Future<void> _editLine(BuildContext context, WidgetRef ref,
    Component component, InventoryData? existing) async {
  final result = await showDialog<
      ({double qty, String unit, int? costCents, bool delete})>(
    context: context,
    builder: (_) => _LineDialog(component: component, existing: existing),
  );
  if (result == null) return;
  final repo = ref.read(inventoryRepositoryProvider);
  if (result.delete) {
    if (existing != null) await repo.delete(existing.id);
    return;
  }
  await repo.set(
    componentId: component.id,
    qtyOnHand: result.qty,
    unit: result.unit,
    costPaidCents: result.costCents,
  );
}

class _InventoryTile extends ConsumerWidget {
  const _InventoryTile({required this.line});

  final InventoryLine line;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = line.component;
    final row = line.row;
    final cost = row.costPaidCents == null
        ? null
        : '\$${(row.costPaidCents! / 100).toStringAsFixed(2)} paid';
    return ListTile(
      title: Text([
        c.maker,
        c.name,
        if (c.weightGr != null) '${formatDecimal(c.weightGr!)}gr',
      ].join(' ')),
      subtitle: Text([
        '${formatDecimal(row.qtyOnHand)} ${row.unit}',
        ?cost,
        'updated ${formatDate(row.dateUpdated)}',
      ].join(' · ')),
      trailing: const Icon(Icons.edit_outlined),
      onTap: () => _editLine(context, ref, c, row),
    );
  }
}

/// Edits one shelf line. Stateful so the dialog owns its controllers
/// past the exit animation.
class _LineDialog extends StatefulWidget {
  const _LineDialog({required this.component, this.existing});

  final Component component;
  final InventoryData? existing;

  @override
  State<_LineDialog> createState() => _LineDialogState();
}

class _LineDialogState extends State<_LineDialog> {
  late final _qty = TextEditingController(
      text: widget.existing == null
          ? null
          : formatDecimal(widget.existing!.qtyOnHand));
  late final _unit = TextEditingController(text: widget.existing?.unit);
  late final _cost = TextEditingController(
      text: widget.existing?.costPaidCents == null
          ? null
          : (widget.existing!.costPaidCents! / 100).toStringAsFixed(2));

  @override
  void dispose() {
    _qty.dispose();
    _unit.dispose();
    _cost.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.component;
    return AlertDialog(
      title: Text('${c.maker} ${c.name}'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _qty,
                  autofocus: true,
                  decoration:
                      const InputDecoration(labelText: 'On hand'),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _unit,
                  decoration: const InputDecoration(
                      labelText: 'Unit', hintText: 'lb, ct, pcs'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _cost,
            decoration: const InputDecoration(
                labelText: 'What you paid', prefixText: r'$'),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
          ),
        ],
      ),
      actions: [
        if (widget.existing != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(
                (qty: 0.0, unit: '', costCents: null, delete: true)),
            child: const Text('Remove'),
          ),
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final qty = double.tryParse(_qty.text.trim());
            final unit = _unit.text.trim();
            if (qty == null || unit.isEmpty) return;
            final cost = double.tryParse(
                _cost.text.trim().replaceFirst(r'$', ''));
            Navigator.of(context).pop((
              qty: qty,
              unit: unit,
              costCents: cost == null ? null : (cost * 100).round(),
              delete: false,
            ));
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
