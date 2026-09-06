import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/features/scan_import/notebook_flow.dart';
import 'package:loadbook/features/scan_import/scan_import_providers.dart';

import '../helpers.dart';

List<OcrLine> page(List<String> rows) => [
      for (final (i, row) in rows.indexed)
        OcrLine(row, left: 0, top: i * 40, height: 24),
    ];

class _Launcher extends ConsumerWidget {
  const _Launcher();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => runNotebookImport(context, ref),
          child: const Text('Import'),
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
      'the converter: capture -> review (transcription only) -> file',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      entitled: true,
      home: const _Launcher(),
      overrides: [
        documentScanServiceProvider.overrideWithValue(
            FakeDocumentScanService(['card1.jpg', 'card2.jpg'])),
        textRecognitionServiceProvider
            .overrideWithValue(FakeTextRecognitionService(linesByPath: {
          'card1.jpg': page([
            '.308 Win',
            'Bullet: Testmaker Match 168 gr',
            'Powder: Fakeco TP-1 42.5 gr',
            'Primer: Testmaker LR',
          ]),
          'card2.jpg': page(['just a grocery list']),
        })),
      ],
    ));

    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();

    // Review screen: card 1 reads complete; card 2 shows its gaps in
    // words, no value ever flagged or suggested.
    expect(find.text('Scanned cards'), findsOneWidget);
    expect(find.text('.308 Win'), findsOneWidget);
    expect(find.textContaining('42.5 gr · Fakeco TP-1'), findsOneWidget);
    expect(find.text('just a grocery list'), findsOneWidget);
    expect(find.textContaining('No charge · No powder'), findsOneWidget);

    // Uncheck the grocery list; file the real card.
    await tester.tap(find.byType(Checkbox).last);
    await tester.pump();
    await tester.tap(find.text('Add 1 load'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Added 1 load, 1 new cartridge'),
        findsOneWidget);
    final load = await db.select(db.loads).getSingle();
    expect(load.chargeGr, 42.5);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('the converter is Pro — free users get the paywall',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(
      db: db,
      home: const _Launcher(),
      overrides: [
        documentScanServiceProvider
            .overrideWithValue(FakeDocumentScanService(['card1.jpg'])),
        textRecognitionServiceProvider
            .overrideWithValue(FakeTextRecognitionService()),
      ],
    ));

    await tester.tap(find.text('Import'));
    await tester.pumpAndSettle();
    expect(find.text('Loadbook Pro'), findsOneWidget);
    expect(find.text('Scanned cards'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });
}
