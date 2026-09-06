import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/database/app_database.dart';
import '../../data/providers.dart';
import '../../data/repositories/load_repository.dart';
import '../components/component_picker.dart';

/// Writes one index card. Every field is the user's own entry: the
/// charge and COAL accept any number ("is a number" is the only check
/// — rails), and component pickers only ever offer what the user has
/// created.
class LoadComposerScreen extends ConsumerStatefulWidget {
  const LoadComposerScreen({super.key, required this.cartridgeId});

  final int cartridgeId;

  @override
  ConsumerState<LoadComposerScreen> createState() =>
      _LoadComposerScreenState();
}

class _LoadComposerScreenState extends ConsumerState<LoadComposerScreen> {
  Component? _bullet;
  Component? _powder;
  Component? _primer;
  Component? _brass;
  final _charge = TextEditingController();
  final _coal = TextEditingController();
  final _crimp = TextEditingController();
  final _notes = TextEditingController();
  DateTime _dateDeveloped = DateTime.now();
  var _status = LoadStatus.working;

  @override
  void dispose() {
    _charge.dispose();
    _coal.dispose();
    _crimp.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _complete =>
      _bullet != null &&
      _powder != null &&
      _primer != null &&
      double.tryParse(_charge.text.trim()) != null;

  Future<void> _pick(ComponentKind kind,
      ValueChanged<Component> assign) async {
    final picked = await pickComponent(context, ref, kind: kind);
    if (picked != null) setState(() => assign(picked));
  }

  Future<void> _save() async {
    final charge = double.tryParse(_charge.text.trim());
    if (charge == null) return;
    final notes = _notes.text.trim();
    await ref.read(loadRepositoryProvider).create(LoadDraft(
          cartridgeId: widget.cartridgeId,
          bulletId: _bullet!.id,
          powderId: _powder!.id,
          chargeGr: charge,
          primerId: _primer!.id,
          brassId: _brass?.id,
          coalIn: double.tryParse(_coal.text.trim()),
          crimp: _crimp.text.trim().isEmpty ? null : _crimp.text.trim(),
          dateDeveloped: _dateDeveloped,
          status: _status,
          notes: notes.isEmpty ? null : notes,
        ));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    String componentLabel(Component? c) => c == null
        ? 'Choose'
        : [
            c.maker,
            c.name,
            if (c.weightGr != null) '${formatDecimal(c.weightGr!)}gr',
          ].join(' ');
    return Scaffold(
      appBar: AppBar(
        title: const Text('New load'),
        actions: [
          TextButton(
            onPressed: _complete ? _save : null,
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          for (final (label, kind, value, assign)
              in <(String, ComponentKind, Component?,
                  ValueChanged<Component>)>[
            ('Bullet', ComponentKind.bullet, _bullet,
                (c) => _bullet = c),
            ('Powder', ComponentKind.powder, _powder,
                (c) => _powder = c),
            ('Primer', ComponentKind.primer, _primer,
                (c) => _primer = c),
            ('Brass (optional)', ComponentKind.brass, _brass,
                (c) => _brass = c),
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(label, style: theme.textTheme.labelLarge),
              subtitle: Text(componentLabel(value),
                  style: theme.textTheme.bodyLarge),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _pick(kind, assign),
            ),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _charge,
                  decoration: const InputDecoration(
                      labelText: 'Charge', suffixText: 'gr'),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _coal,
                  decoration: const InputDecoration(
                      labelText: 'COAL', suffixText: 'in'),
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _crimp,
            decoration: const InputDecoration(
                labelText: 'Crimp', hintText: 'In your own words'),
          ),
          const SizedBox(height: 12),
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Developed', style: theme.textTheme.labelLarge),
            subtitle: Text(formatDate(_dateDeveloped),
                style: theme.textTheme.bodyLarge),
            trailing: const Icon(Icons.event),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dateDeveloped,
                firstDate: DateTime(1970),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _dateDeveloped = picked);
            },
          ),
          const SizedBox(height: 4),
          SegmentedButton<LoadStatus>(
            segments: const [
              ButtonSegment(
                  value: LoadStatus.working, label: Text('Working')),
              ButtonSegment(
                  value: LoadStatus.keeper, label: Text('Keeper')),
              ButtonSegment(
                  value: LoadStatus.retired, label: Text('Retired')),
            ],
            selected: {_status},
            onSelectionChanged: (s) => setState(() => _status = s.single),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              labelText: 'Notes',
              hintText: 'Whatever the card says.',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
        ],
      ),
    );
  }
}
