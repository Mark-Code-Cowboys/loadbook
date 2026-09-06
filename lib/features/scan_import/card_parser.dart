import 'package:cc_core/cc_core.dart';

/// What one index card or notebook page transcribed to — the converter
/// schema. Every field is exactly what the camera saw; the user
/// confirms and edits on the review screen before anything is saved.
///
/// Rails: transcription only. The parser reads structure (labels, a
/// number written next to "gr") and never judges values — a charge is
/// whatever the card says, and anything ambiguous stays in [notes] for
/// the user to place.
class CardDraft {
  CardDraft({
    this.cartridge,
    this.bullet,
    this.bulletWeightGr,
    this.powder,
    this.chargeGr,
    this.primer,
    this.brass,
    this.coalIn,
    this.date,
    this.notes,
  });

  String? cartridge;
  String? bullet;
  double? bulletWeightGr;
  String? powder;
  double? chargeGr;
  String? primer;
  String? brass;
  double? coalIn;
  DateTime? date;
  String? notes;

  /// Everything a load row needs. Cards missing one of these are
  /// skipped by the importer (the review dialog is where the user
  /// fills them in first).
  bool get isComplete =>
      cartridge != null &&
      bullet != null &&
      powder != null &&
      chargeGr != null &&
      primer != null;
}

final _labelRow = RegExp(
    r'^\s*(cartridge|caliber|cal|bullet|powder|charge|primer|brass|case|'
    r'coal|oal|col|crimp|date)\s*[:\-]?\s*(.+)$',
    caseSensitive: false);
final _grains =
    RegExp(r'(\d+(?:[.,]\d+)?)\s*(?:grs?|grains?)\b', caseSensitive: false);
final _inches = RegExp(r'(\d+[.,]\d+)\s*"?');

double? _num(String s) => double.tryParse(s.replaceAll(',', '.'));

/// Transcribes one card's OCR into a [CardDraft].
///
/// Labeled rows ("Powder: H4895 42.5gr", "COAL 2.800") fill their
/// fields; a number next to "gr" on the powder row is the charge and
/// on the bullet row the bullet weight — structure, not judgment. The
/// first unlabeled, undated row is the card's title, read as the
/// cartridge. Whatever isn't consumed lands in notes verbatim. Null
/// when the photo had no text at all; no field is ever invented.
CardDraft? parseCard(List<OcrLine> lines) {
  if (lines.isEmpty) return null;
  final rows = mergeOcrRows(lines);
  final draft = CardDraft();
  final leftover = <String>[];

  for (final row in rows) {
    final trimmed = row.trim();
    if (trimmed.isEmpty) continue;

    final labeled = _labelRow.firstMatch(trimmed);
    if (labeled != null) {
      final label = labeled.group(1)!.toLowerCase();
      var value = labeled.group(2)!.trim();
      switch (label) {
        case 'cartridge' || 'caliber' || 'cal':
          draft.cartridge ??= value;
        case 'bullet':
          final gr = _grains.firstMatch(value);
          if (gr != null) {
            draft.bulletWeightGr ??= _num(gr.group(1)!);
            value = value.replaceFirst(gr.group(0)!, '').trim();
          }
          draft.bullet ??= value.isEmpty ? null : value;
        case 'powder':
          final gr = _grains.firstMatch(value);
          if (gr != null) {
            draft.chargeGr ??= _num(gr.group(1)!);
            value = value.replaceFirst(gr.group(0)!, '').trim();
          }
          draft.powder ??= value.isEmpty ? null : value;
        case 'charge':
          final gr = _grains.firstMatch(value);
          draft.chargeGr ??=
              gr != null ? _num(gr.group(1)!) : _num(value);
        case 'primer':
          draft.primer ??= value;
        case 'brass' || 'case':
          draft.brass ??= value;
        case 'coal' || 'oal' || 'col':
          final inches = _inches.firstMatch(value);
          if (inches != null) draft.coalIn ??= _num(inches.group(1)!);
        case 'crimp':
          leftover.add(trimmed); // kept verbatim in notes
        case 'date':
          draft.date ??= parseLooseDate(value);
      }
      continue;
    }

    if (draft.date == null) {
      final date = parseLooseDate(trimmed);
      if (date != null) {
        draft.date = date;
        continue;
      }
    }

    // The card's title row — read as the cartridge, however written.
    if (draft.cartridge == null &&
        RegExp('[a-zA-Z0-9]{2}').hasMatch(trimmed)) {
      draft.cartridge = trimmed;
      continue;
    }

    leftover.add(trimmed);
  }

  if (leftover.isNotEmpty) draft.notes = leftover.join('\n');

  final empty = draft.cartridge == null &&
      draft.bullet == null &&
      draft.powder == null &&
      draft.chargeGr == null &&
      draft.primer == null &&
      draft.notes == null;
  return empty ? null : draft;
}
