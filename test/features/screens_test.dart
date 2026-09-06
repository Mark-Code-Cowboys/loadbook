import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/inventory_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/data/repositories/range_session_repository.dart';
import 'package:loadbook/features/cartridges/cartridge_detail_screen.dart';
import 'package:loadbook/features/inventory/inventory_screen.dart';
import 'package:loadbook/features/loads/load_composer_screen.dart';
import 'package:loadbook/features/loads/load_detail_screen.dart';
import 'package:loadbook/features/sessions/session_composer_screen.dart';

import '../helpers.dart';

Future<({int bullet, int powder, int primer})> seedComponents(
    AppDatabase db) async {
  final components = ComponentRepository(db);
  return (
    bullet: await components.create(const ComponentDraft(
        kind: ComponentKind.bullet,
        maker: 'Testmaker',
        name: 'Match',
        weightGr: 168)),
    powder: await components.create(const ComponentDraft(
        kind: ComponentKind.powder, maker: 'Testmaker', name: 'TP-1')),
    primer: await components.create(const ComponentDraft(
        kind: ComponentKind.primer, maker: 'Testmaker', name: 'LR')),
  );
}

void main() {
  testWidgets('cartridge detail groups loads by status', (tester) async {
    final db = makeTestDb();
    final cartridgeId =
        await CartridgeRepository(db).create(name: '.308 Test');
    final c = await seedComponents(db);
    final loads = LoadRepository(db);
    for (final (charge, status) in [
      (42.0, LoadStatus.working),
      (42.5, LoadStatus.keeper),
      (41.0, LoadStatus.retired),
    ]) {
      final id = await loads.create(LoadDraft(
        cartridgeId: cartridgeId,
        bulletId: c.bullet,
        powderId: c.powder,
        chargeGr: charge,
        primerId: c.primer,
        dateDeveloped: DateTime(2026, 3, 1),
      ));
      await loads.setStatus(id, status);
    }

    await tester.pumpWidget(testApp(
        db: db, home: CartridgeDetailScreen(cartridgeId: cartridgeId)));
    await tester.pumpAndSettle();

    expect(find.text('Working'), findsOneWidget);
    expect(find.text('Keepers'), findsOneWidget);
    expect(find.text('Retired'), findsOneWidget);
    expect(find.textContaining('42.5 gr TP-1'), findsOneWidget);
    expect(find.text('Testmaker Match 168gr'), findsNWidgets(3));

    await disposeApp(tester);
    await db.close();
  });

  testWidgets(
      'load composer: pickers offer only the user\'s components, '
      'inline-create works, any charge saves', (tester) async {
    final db = makeTestDb();
    final cartridgeId =
        await CartridgeRepository(db).create(name: '.308 Test');
    await seedComponents(db);

    await tester.pumpWidget(testApp(
        db: db, home: LoadComposerScreen(cartridgeId: cartridgeId)));
    await tester.pumpAndSettle();

    // Save is disabled until the card is complete.
    expect(
        tester
            .widget<TextButton>(find.widgetWithText(TextButton, 'Save'))
            .onPressed,
        isNull);

    // Bullet and primer from the shelf.
    await tester.tap(find.text('Bullet'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Testmaker Match 168gr'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Primer'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Testmaker LR'));
    await tester.pumpAndSettle();

    // Powder created inline — the sheet's only offer besides the
    // user's own shelf is "new".
    await tester.tap(find.text('Powder'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('New powder'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'Maker'), 'Fakeco');
    await tester.enterText(
        find.widgetWithText(TextField, 'Name'), 'FP-9');
    await tester.tap(find.text('Add'));
    await tester.pumpAndSettle();

    // An implausible charge saves untouched — the only check is "is a
    // number" (rails).
    await tester.enterText(
        find.widgetWithText(TextField, 'Charge'), '999.9');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final rows = await db.select(db.loads).get();
    expect(rows.single.chargeGr, 999.9);
    final powders = await db.select(db.components).get();
    expect(powders.where((c) => c.name == 'FP-9'), hasLength(1));

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('load detail renders the card and walks status',
      (tester) async {
    final db = makeTestDb();
    final cartridgeId =
        await CartridgeRepository(db).create(name: '.308 Test');
    final c = await seedComponents(db);
    final loads = LoadRepository(db);
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 42.5,
      primerId: c.primer,
      coalIn: 2.8,
      crimp: 'light',
      dateDeveloped: DateTime(2026, 3, 1),
      notes: 'shoots straight',
    ));
    await RangeSessionRepository(db).create(SessionDraft(
      loadId: loadId,
      date: DateTime(2026, 3, 14),
      distanceYd: 100,
      shots: 5,
      groupSizeIn: 0.75,
      chronoAvgFps: 2650,
    ));

    await tester
        .pumpWidget(testApp(db: db, home: LoadDetailScreen(loadId: loadId)));
    await tester.pumpAndSettle();

    expect(find.text('Testmaker Match 168gr'), findsOneWidget);
    expect(find.text('42.5 gr Testmaker TP-1'), findsOneWidget);
    expect(find.text('2.8"'), findsOneWidget);
    expect(find.text('light'), findsOneWidget);
    expect(find.text('shoots straight'), findsOneWidget);
    // Session card with computed MOA (0.75 / 1.047).
    expect(find.textContaining('0.72 MOA'), findsOneWidget);
    expect(find.textContaining('avg 2650 fps'), findsOneWidget);

    await tester.ensureVisible(find.text('Keeper'));
    await tester.tap(find.text('Keeper'));
    await tester.pumpAndSettle();
    final row = await db.select(db.loads).getSingle();
    expect(row.status, LoadStatus.keeper);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('session composer shows live MOA and saves the trip',
      (tester) async {
    final db = makeTestDb();
    final cartridgeId =
        await CartridgeRepository(db).create(name: '.308 Test');
    final c = await seedComponents(db);
    final loadId = await LoadRepository(db).create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 42.5,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 3, 1),
    ));

    await tester.pumpWidget(
        testApp(db: db, home: SessionComposerScreen(loadId: loadId)));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Distance'), '100');
    await tester.enterText(find.widgetWithText(TextField, 'Shots'), '5');
    await tester.enterText(
        find.widgetWithText(TextField, 'Group size'), '1.047');
    await tester.pumpAndSettle();
    // The recorded math, live: 1.047" at 100 yd is exactly 1 MOA.
    expect(find.text('1.00 MOA at 100 yd'), findsOneWidget);

    await tester.enterText(
        find.widgetWithText(TextField, 'Notes'), 'windy afternoon');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final session = await db.select(db.rangeSessions).getSingle();
    expect(session.distanceYd, 100);
    expect(session.groupSizeIn, 1.047);
    final entry = await db.select(db.appJournalEntries).getSingle();
    expect(entry.notes, 'windy afternoon');

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('inventory edits a line in place', (tester) async {
    final db = makeTestDb();
    final c = await seedComponents(db);
    await InventoryRepository(db).set(
        componentId: c.powder,
        qtyOnHand: 1,
        unit: 'lb',
        costPaidCents: 4599,
        now: DateTime(2026, 1, 1));

    await tester.pumpWidget(testApp(db: db, home: const InventoryScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Powder'), findsOneWidget);
    expect(find.textContaining('1 lb'), findsOneWidget);
    expect(find.textContaining(r'$45.99 paid'), findsOneWidget);

    await tester.tap(find.textContaining('1 lb'));
    await tester.pumpAndSettle();
    await tester.enterText(
        find.widgetWithText(TextField, 'On hand'), '0.4');
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
    expect(find.textContaining('0.4 lb'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('inventory empty state invites the shelf', (tester) async {
    final db = makeTestDb();
    await tester.pumpWidget(testApp(db: db, home: const InventoryScreen()));
    await tester.pumpAndSettle();
    expect(find.text('Nothing on the shelf yet.'), findsOneWidget);
    await disposeApp(tester);
    await db.close();
  });
}
