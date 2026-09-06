import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/format.dart';
import '../../data/providers.dart';
import '../monetization/monetization_providers.dart';
import '../monetization/paywall_sheet.dart';
import 'card_parser.dart';
import 'notebook_importer.dart';
import 'scan_import_providers.dart';

/// The flagship converter: photograph the index cards or notebook
/// pages (up to 20 in one session), review what each card transcribed
/// to, fix anything the camera misread, and file them all at once.
///
/// Transcription only (rails): the review screen shows exactly what
/// was read — missing fields stay blank for the user, never guessed,
/// and no value is ever commented on.
Future<void> runNotebookImport(BuildContext context, WidgetRef ref) async {
  // The converter is a Pro feature, like scanning in every CC app.
  final pro = await ref.read(entitlementServiceProvider).isUnlimited();
  if (!context.mounted) return;
  if (!pro) {
    final unlocked = await showPaywallSheet(context);
    if (!unlocked || !context.mounted) return;
  }

  final messenger = ScaffoldMessenger.of(context);

  final paths = await captureDocumentPages(
      ref.read(documentScanServiceProvider),
      pageLimit: 20);
  if (paths.isEmpty || !context.mounted) return;

  final transcription = await batchTranscribe<CardDraft>(
    imagePaths: paths,
    recognizer: ref.read(textRecognitionServiceProvider),
    parse: parseCard,
  );
  if (!context.mounted) return;
  if (transcription.items.isEmpty) {
    messenger.showSnackBar(const SnackBar(
        content: Text("Couldn't read those cards — try closer, "
            'straighter shots.')));
    return;
  }
  if (transcription.failedCount > 0) {
    messenger.showSnackBar(SnackBar(
        content: Text('${transcription.failedCount} '
            '${transcription.failedCount == 1 ? 'card was' : 'cards were'} '
            'unreadable and skipped.')));
  }

  final kept = await showBatchReviewScreen<CardDraft>(
    context,
    items: transcription.items,
    title: 'Scanned cards',
    subtitle: 'Exactly what each card says — fix anything the camera '
        'misread, uncheck cards that don\'t belong. Cards without a date '
        'are filed under today.',
    confirmLabel: (n) => n == 1 ? 'Add 1 load' : 'Add $n loads',
    itemBuilder: (context, item, onChanged) =>
        _CardRow(item: item, onChanged: onChanged),
  );
  if (kept == null || kept.isEmpty || !context.mounted) return;

  final report = await insertCardDrafts(
    db: ref.read(databaseProvider),
    cartridges: ref.read(cartridgeRepositoryProvider),
    components: ref.read(componentRepositoryProvider),
    loads: ref.read(loadRepositoryProvider),
    drafts: [for (final item in kept) item.value],
  );
  messenger.showSnackBar(SnackBar(content: Text(report.summary)));
}

class _CardRow extends StatelessWidget {
  const _CardRow({required this.item, required this.onChanged});

  final BatchScanItem<CardDraft> item;
  final VoidCallback onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final draft = item.value;
    // Per-field confidence styling: what was read renders plain; what
    // wasn't renders as an italic gap the user can see at a glance.
    final missingStyle = theme.textTheme.bodyMedium?.copyWith(
        fontStyle: FontStyle.italic,
        color: theme.colorScheme.onSurfaceVariant);
    final details = [
      draft.chargeGr == null
          ? 'No charge'
          : '${formatDecimal(draft.chargeGr!)} gr',
      draft.powder ?? 'No powder',
      draft.bullet ?? 'No bullet',
      draft.primer ?? 'No primer',
      if (draft.date != null) formatDate(draft.date!),
    ].join(' · ');
    final incomplete = !draft.isComplete;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(draft.cartridge ?? 'No cartridge',
          style: draft.cartridge == null ? missingStyle : null),
      subtitle: Text(details,
          style: incomplete
              ? theme.textTheme.bodyMedium
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant)
              : null),
      trailing: IconButton(
        icon: const Icon(Icons.edit_outlined),
        tooltip: 'Edit card',
        onPressed: () async {
          await showDialog<void>(
            context: context,
            builder: (_) => _EditCardDialog(draft: draft),
          );
          onChanged();
        },
      ),
    );
  }
}

/// Edits one transcribed card in place. Fields start as what the
/// camera saw; the dialog never suggests values.
class _EditCardDialog extends StatefulWidget {
  const _EditCardDialog({required this.draft});

  final CardDraft draft;

  @override
  State<_EditCardDialog> createState() => _EditCardDialogState();
}

class _EditCardDialogState extends State<_EditCardDialog> {
  late final _cartridge =
      TextEditingController(text: widget.draft.cartridge);
  late final _bullet = TextEditingController(text: widget.draft.bullet);
  late final _weight = TextEditingController(
      text: widget.draft.bulletWeightGr == null
          ? null
          : formatDecimal(widget.draft.bulletWeightGr!));
  late final _powder = TextEditingController(text: widget.draft.powder);
  late final _charge = TextEditingController(
      text: widget.draft.chargeGr == null
          ? null
          : formatDecimal(widget.draft.chargeGr!));
  late final _primer = TextEditingController(text: widget.draft.primer);
  late final _brass = TextEditingController(text: widget.draft.brass);
  late final _coal = TextEditingController(
      text: widget.draft.coalIn == null
          ? null
          : formatDecimal(widget.draft.coalIn!));
  late final _notes = TextEditingController(text: widget.draft.notes);
  late DateTime? _date = widget.draft.date;

  @override
  void dispose() {
    _cartridge.dispose();
    _bullet.dispose();
    _weight.dispose();
    _powder.dispose();
    _charge.dispose();
    _primer.dispose();
    _brass.dispose();
    _coal.dispose();
    _notes.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? emptyToNull(TextEditingController c) =>
        c.text.trim().isEmpty ? null : c.text.trim();
    Widget field(TextEditingController c, String label,
            {String? suffix, bool number = false}) =>
        TextField(
          controller: c,
          decoration: InputDecoration(labelText: label, suffixText: suffix),
          keyboardType: number
              ? const TextInputType.numberWithOptions(decimal: true)
              : null,
        );
    return AlertDialog(
      title: const Text('Edit card'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            field(_cartridge, 'Cartridge'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 2, child: field(_bullet, 'Bullet')),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      field(_weight, 'Weight', suffix: 'gr', number: true)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 2, child: field(_powder, 'Powder')),
              const SizedBox(width: 12),
              Expanded(
                  child:
                      field(_charge, 'Charge', suffix: 'gr', number: true)),
            ]),
            const SizedBox(height: 12),
            field(_primer, 'Primer'),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(flex: 2, child: field(_brass, 'Brass')),
              const SizedBox(width: 12),
              Expanded(
                  child: field(_coal, 'COAL', suffix: 'in', number: true)),
            ]),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: _date ?? DateTime.now(),
                  firstDate: DateTime(1970),
                  lastDate: DateTime.now(),
                );
                if (picked != null) setState(() => _date = picked);
              },
              child: Text(_date == null ? 'Date' : formatDate(_date!)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _notes,
              decoration: const InputDecoration(labelText: 'Notes'),
              maxLines: 3,
              textCapitalization: TextCapitalization.sentences,
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
            widget.draft
              ..cartridge = emptyToNull(_cartridge)
              ..bullet = emptyToNull(_bullet)
              ..bulletWeightGr = double.tryParse(_weight.text.trim())
              ..powder = emptyToNull(_powder)
              ..chargeGr = double.tryParse(_charge.text.trim())
              ..primer = emptyToNull(_primer)
              ..brass = emptyToNull(_brass)
              ..coalIn = double.tryParse(_coal.text.trim())
              ..date = _date
              ..notes = emptyToNull(_notes);
            Navigator.of(context).pop();
          },
          child: const Text('Done'),
        ),
      ],
    );
  }
}
