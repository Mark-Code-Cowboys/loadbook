import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/app.dart';

import 'helpers.dart';

void main() {
  testWidgets(
      'boots onboarding -> shell, adds a cartridge, and gates at two',
      (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const AppRoot()));
    await tester.pumpAndSettle();

    // First run lands on onboarding (placeholder copy until Phase F).
    await tester.tap(find.text('Just look around'));
    await tester.pumpAndSettle();

    // The notebook's empty front page.
    expect(find.text('Your reloading notebook.'), findsOneWidget);

    for (final name in ['.308 Test', '6.5 Test']) {
      await tester.tap(find.text('Add cartridge'));
      await tester.pumpAndSettle();
      await tester.enterText(
          find.widgetWithText(TextField, 'Cartridge'), name);
      await tester.tap(find.text('Add'));
      await tester.pumpAndSettle();
      expect(find.text(name), findsOneWidget);
    }
    expect(find.text('2 of 2 free cartridges used'), findsOneWidget);

    // The third add hits the gate and opens the paywall stub.
    await tester.tap(find.text('Add cartridge'));
    await tester.pumpAndSettle();
    expect(find.text('Loadbook Pro'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
