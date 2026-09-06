import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/core/utils/format.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/features/sessions/session_composer_screen.dart';
import 'package:loadbook/features/sessions/target_measure_screen.dart';

import '../helpers.dart';

/// Not a real image — the screen's errorBuilder paints a flat box, and
/// the measurement math never touches pixels anyway.
final _noImage = MemoryImage(Uint8List.fromList([0]));

class _Launcher extends StatefulWidget {
  const _Launcher();

  @override
  State<_Launcher> createState() => _LauncherState();
}

class _LauncherState extends State<_Launcher> {
  double? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (result != null) Text('got ${formatDecimal(result!)}'),
            ElevatedButton(
              onPressed: () async {
                final measured = await measureTargetPhoto(context,
                    image: _noImage, distanceYd: 100);
                setState(() => result = measured);
              },
              child: const Text('Measure'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  testWidgets(
      'calibrate -> measure: the ratio math is plain recorded arithmetic',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const _Launcher()));
    await tester.tap(find.text('Measure'));
    await tester.pumpAndSettle();

    // Next waits for the reference length — the user's own number.
    expect(
        tester
            .widget<FilledButton>(find.widgetWithText(FilledButton, 'Next'))
            .onPressed,
        isNull);
    await tester.enterText(
        find.widgetWithText(TextField, 'Its length'), '1');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Seeded geometry: the reference line spans 0.4 of the width, the
    // group line 0.3 — so a 1" reference reads a 0.75" group, which is
    // 0.72 MOA at the session's 100 yd.
    expect(find.textContaining('0.75"'), findsWidgets);
    expect(find.textContaining('0.72 MOA at 100 yd'), findsOneWidget);

    // Dragging a handle changes the measurement — the endpoints are
    // the user's judgment, live.
    await tester.drag(find.byKey(const Key('group-a')),
        const Offset(-60, 0));
    await tester.pumpAndSettle();
    expect(find.textContaining('0.75"'), findsNothing);

    // Re-calibrate goes back; returning keeps the group line.
    await tester.tap(find.text('Re-calibrate'));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('cal-a')), findsOneWidget);
    await tester.tap(find.text('Next'));
    await tester.pumpAndSettle();

    // Confirming hands the inches back to the caller.
    await tester.tap(find.textContaining('Use '));
    await tester.pumpAndSettle();
    expect(find.textContaining('got '), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets(
      'the composer explains what the measurer needs, in order',
      (tester) async {
    final db = makeTestDb();
    final cartridgeId =
        await CartridgeRepository(db).create(name: '.308 Test');
    // A load isn't needed for the composer UI itself.
    await tester.pumpWidget(testApp(
        db: db,
        entitled: true,
        home: SessionComposerScreen(loadId: cartridgeId)));
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Measure from target photo'));
    await tester.pumpAndSettle();
    expect(find.text('Enter the distance first — MOA needs it.'),
        findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Distance'), '100');
    await tester.tap(find.byTooltip('Measure from target photo'));
    await tester.pumpAndSettle();
    expect(find.text('Add a target photo first.'), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();

    await disposeApp(tester);
    await db.close();
  });
}
