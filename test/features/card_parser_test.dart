import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loadbook/features/scan_import/card_parser.dart';

/// Rows stacked top to bottom, one OCR line each.
List<OcrLine> page(List<String> rows) => [
      for (final (i, row) in rows.indexed)
        OcrLine(row, left: 0, top: i * 40, height: 24),
    ];

void main() {
  test('a labeled index card fills every field', () {
    final draft = parseCard(page([
      '.308 Win',
      'Bullet: Testmaker Match 168 gr',
      'Powder: Fakeco TP-1 42.5 gr',
      'Primer: Testmaker LR',
      'Brass: Testmaker Once-Fired',
      'COAL 2.800"',
      '3/14/2024',
      'Shot great at the club match',
    ]));

    expect(draft, isNotNull);
    expect(draft!.cartridge, '.308 Win');
    expect(draft.bullet, 'Testmaker Match');
    expect(draft.bulletWeightGr, 168);
    expect(draft.powder, 'Fakeco TP-1');
    expect(draft.chargeGr, 42.5);
    expect(draft.primer, 'Testmaker LR');
    expect(draft.brass, 'Testmaker Once-Fired');
    expect(draft.coalIn, 2.8);
    expect(draft.date, DateTime(2024, 3, 14));
    expect(draft.notes, 'Shot great at the club match');
    expect(draft.isComplete, isTrue);
  });

  test('the charge is transcribed verbatim — never judged', () {
    // Rails: the parser reads structure. What the card says is what
    // the draft holds, plausible or not.
    final draft = parseCard(page(['Powder: TP 999.9 gr']));
    expect(draft!.chargeGr, 999.9);
    expect(draft.powder, 'TP');
  });

  test('a separate charge label works too', () {
    final draft = parseCard(page(['Charge: 24.2', 'Powder: Fakeco TP-1']));
    expect(draft!.chargeGr, 24.2);
    expect(draft.powder, 'Fakeco TP-1');
  });

  test('missing fields stay missing — nothing is invented', () {
    final draft = parseCard(page(['6.5 Test', 'Powder: TP-1 41 gr']));
    expect(draft!.cartridge, '6.5 Test');
    expect(draft.chargeGr, 41);
    expect(draft.bullet, isNull);
    expect(draft.primer, isNull);
    expect(draft.date, isNull);
    expect(draft.isComplete, isFalse);
  });

  test('unlabeled leftovers land in notes verbatim', () {
    final draft = parseCard(page([
      '.308 Test',
      'windy day, ladder test',
      'seated long',
    ]));
    expect(draft!.notes, 'windy day, ladder test\nseated long');
  });

  test('an empty page is null, a blank-text page too', () {
    expect(parseCard(const []), isNull);
    expect(parseCard(page(['', '  '])), isNull);
  });
}
