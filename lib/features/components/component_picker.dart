import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/component_repository.dart';

/// Bottom sheet listing the user's own components of [kind], with an
/// inline "new" flow. The list is only ever what the user created —
/// the app ships no component catalog (rails).
Future<Component?> pickComponent(BuildContext context, WidgetRef ref,
    {required ComponentKind kind}) async {
  final components = await ref
      .read(databaseProvider)
      .select(ref.read(databaseProvider).components)
      .get();
  final ofKind = [for (final c in components) if (c.kind == kind) c]
    ..sort((a, b) {
      final maker = a.maker.compareTo(b.maker);
      return maker != 0 ? maker : a.name.compareTo(b.name);
    });
  if (!context.mounted) return null;

  final choice = await showModalBottomSheet<Object>(
    context: context,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(
            leading: const Icon(Icons.add),
            title: Text('New ${_kindLabel(kind)}'),
            onTap: () => Navigator.of(context).pop('new'),
          ),
          for (final c in ofKind)
            ListTile(
              title: Text([
                c.maker,
                c.name,
                if (c.weightGr != null)
                  '${formatDecimal(c.weightGr!)}gr',
              ].join(' ')),
              subtitle: c.lot == null ? null : Text('Lot ${c.lot}'),
              onTap: () => Navigator.of(context).pop(c),
            ),
        ],
      ),
    ),
  );
  if (choice is Component) return choice;
  if (choice != 'new' || !context.mounted) return null;

  final draft = await showDialog<ComponentDraft>(
    context: context,
    builder: (_) => _ComponentDialog(kind: kind),
  );
  if (draft == null) return null;
  final id = await ref.read(componentRepositoryProvider).create(draft);
  return ref.read(componentRepositoryProvider).getById(id);
}

String _kindLabel(ComponentKind kind) => switch (kind) {
      ComponentKind.powder => 'powder',
      ComponentKind.primer => 'primer',
      ComponentKind.bullet => 'bullet',
      ComponentKind.brass => 'brass',
    };

/// Creates one component from the user's own words. Stateful so the
/// dialog owns its controllers past the exit animation.
class _ComponentDialog extends StatefulWidget {
  const _ComponentDialog({required this.kind});

  final ComponentKind kind;

  @override
  State<_ComponentDialog> createState() => _ComponentDialogState();
}

class _ComponentDialogState extends State<_ComponentDialog> {
  final _maker = TextEditingController();
  final _name = TextEditingController();
  final _lot = TextEditingController();
  final _weight = TextEditingController();
  final _type = TextEditingController();

  @override
  void dispose() {
    _maker.dispose();
    _name.dispose();
    _lot.dispose();
    _weight.dispose();
    _type.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isBullet = widget.kind == ComponentKind.bullet;
    return AlertDialog(
      title: Text('New ${_kindLabel(widget.kind)}'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _maker,
              autofocus: true,
              decoration: const InputDecoration(labelText: 'Maker'),
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
              textCapitalization: TextCapitalization.words,
            ),
            if (isBullet) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weight,
                      decoration: const InputDecoration(
                          labelText: 'Weight', suffixText: 'gr'),
                      keyboardType: const TextInputType.numberWithOptions(
                          decimal: true),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _type,
                      decoration:
                          const InputDecoration(labelText: 'Type'),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            TextField(
              controller: _lot,
              decoration: const InputDecoration(labelText: 'Lot'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel')),
        FilledButton(
          onPressed: () {
            final maker = _maker.text.trim();
            final name = _name.text.trim();
            if (maker.isEmpty || name.isEmpty) return;
            Navigator.of(context).pop(ComponentDraft(
              kind: widget.kind,
              maker: maker,
              name: name,
              lot: _lot.text.trim().isEmpty ? null : _lot.text.trim(),
              weightGr: double.tryParse(_weight.text.trim()),
              bulletType:
                  _type.text.trim().isEmpty ? null : _type.text.trim(),
            ));
          },
          child: const Text('Add'),
        ),
      ],
    );
  }
}
