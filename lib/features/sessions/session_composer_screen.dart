import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../core/utils/moa.dart';
import '../../data/providers.dart';
import '../../data/repositories/range_session_repository.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';

/// Logs one range trip. Every measurement is the user's own; the only
/// computation is MOA from their distance and group, shown live as
/// they type — recorded math, never judgment (rails).
class SessionComposerScreen extends ConsumerStatefulWidget {
  const SessionComposerScreen({super.key, required this.loadId});

  final int loadId;

  @override
  ConsumerState<SessionComposerScreen> createState() =>
      _SessionComposerScreenState();
}

class _SessionComposerScreenState
    extends ConsumerState<SessionComposerScreen> {
  DateTime _date = DateTime.now();
  final _firearm = TextEditingController();
  final _distance = TextEditingController();
  final _shots = TextEditingController();
  final _group = TextEditingController();
  final _chronoAvg = TextEditingController();
  final _chronoSd = TextEditingController();
  final _chronoEs = TextEditingController();
  final _weather = TextEditingController();
  final _notes = TextEditingController();
  final _photos = <String>[];

  @override
  void dispose() {
    _firearm.dispose();
    _distance.dispose();
    _shots.dispose();
    _group.dispose();
    _chronoAvg.dispose();
    _chronoSd.dispose();
    _chronoEs.dispose();
    _weather.dispose();
    _notes.dispose();
    super.dispose();
  }

  bool get _complete =>
      int.tryParse(_distance.text.trim()) != null &&
      int.tryParse(_shots.text.trim()) != null;

  double? get _liveMoa => moaFor(
        groupSizeIn: double.tryParse(_group.text.trim()),
        distanceYd: int.tryParse(_distance.text.trim()),
      );

  Future<void> _addPhoto() async {
    final source = await showModalBottomSheet<PhotoSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined),
              title: const Text('Take a photo'),
              onTap: () => Navigator.of(context).pop(PhotoSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Pick from gallery'),
              onTap: () => Navigator.of(context).pop(PhotoSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final path = await ref.read(photoServiceProvider).acquire(source);
    if (path != null) setState(() => _photos.add(path));
  }

  Future<void> _save() async {
    final notes = _notes.text.trim();
    String? textOrNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    await ref.read(rangeSessionRepositoryProvider).create(SessionDraft(
          loadId: widget.loadId,
          date: _date,
          firearm: textOrNull(_firearm),
          distanceYd: int.parse(_distance.text.trim()),
          shots: int.parse(_shots.text.trim()),
          groupSizeIn: double.tryParse(_group.text.trim()),
          chronoAvgFps: double.tryParse(_chronoAvg.text.trim()),
          chronoSdFps: double.tryParse(_chronoSd.text.trim()),
          chronoEsFps: double.tryParse(_chronoEs.text.trim()),
          weather: textOrNull(_weather),
          notes: notes.isEmpty ? null : notes,
          photos: [for (final p in _photos) JournalPhotoDraft(path: p)],
        ));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final photoService = ref.watch(photoServiceProvider);
    final pro = ref.watch(isProProvider).value ?? false;
    InputDecoration deco(String label, [String? suffix]) =>
        InputDecoration(labelText: label, suffixText: suffix);
    // Visible but paid (prompt on tap): the fields sit where they
    // belong so free users see what Pro records here.
    Widget chronoField(TextEditingController controller, String label,
            [String? suffix]) =>
        TextField(
          controller: controller,
          decoration: deco(label, suffix),
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          readOnly: !pro,
          onTap: pro ? null : () => showPaywallSheet(context),
        );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log session'),
        actions: [
          TextButton(
              onPressed: _complete ? _save : null,
              child: const Text('Save')),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Date', style: theme.textTheme.labelLarge),
            subtitle:
                Text(formatDate(_date), style: theme.textTheme.bodyLarge),
            trailing: const Icon(Icons.event),
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(1970),
                lastDate: DateTime.now(),
              );
              if (picked != null) setState(() => _date = picked);
            },
          ),
          TextField(
            controller: _firearm,
            decoration: deco('Firearm (your own words)'),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _distance,
                  decoration: deco('Distance', 'yd'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _shots,
                  decoration: deco('Shots'),
                  keyboardType: TextInputType.number,
                  onChanged: (_) => setState(() {}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _group,
            decoration: InputDecoration(
              labelText: 'Group size',
              suffixText: 'in',
              helperText: _liveMoa == null
                  ? null
                  : '${_liveMoa!.toStringAsFixed(2)} MOA at '
                      '${_distance.text.trim()} yd',
            ),
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('Chronograph', style: theme.textTheme.titleSmall),
              if (!pro) ...[
                const SizedBox(width: 8),
                Icon(Icons.workspace_premium_outlined,
                    size: 16, color: theme.colorScheme.primary),
                const SizedBox(width: 4),
                Text('Pro',
                    style: theme.textTheme.labelSmall
                        ?.copyWith(color: theme.colorScheme.primary)),
              ],
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: chronoField(_chronoAvg, 'Avg', 'fps')),
              const SizedBox(width: 12),
              Expanded(child: chronoField(_chronoSd, 'SD')),
              const SizedBox(width: 12),
              Expanded(child: chronoField(_chronoEs, 'ES')),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
              controller: _weather, decoration: deco('Weather')),
          const SizedBox(height: 12),
          TextField(
            controller: _notes,
            decoration: const InputDecoration(
              labelText: 'Notes',
              alignLabelWithHint: true,
              border: OutlineInputBorder(),
            ),
            maxLines: 4,
            textCapitalization: TextCapitalization.sentences,
          ),
          const SizedBox(height: 16),
          Text('Target photos', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          PhotoAttachmentStrip(
            items: [
              for (final p in _photos)
                PhotoStripItem(
                  file: photoService.fileFor(p),
                  onRemove: () => setState(() => _photos.remove(p)),
                ),
            ],
            onAdd: _addPhoto,
            addLabel: 'Add target photo',
          ),
        ],
      ),
    );
  }
}
