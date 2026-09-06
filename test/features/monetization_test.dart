import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/providers.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/features/home/home_screen.dart';
import 'package:loadbook/features/sessions/session_composer_screen.dart';

import '../helpers.dart';

Future<int> seedLoad(AppDatabase db) async {
  final cartridgeId =
      await CartridgeRepository(db).create(name: '.308 Test');
  final components = ComponentRepository(db);
  final bullet = await components.create(const ComponentDraft(
      kind: ComponentKind.bullet, maker: 'Testmaker', name: 'Match'));
  final powder = await components.create(const ComponentDraft(
      kind: ComponentKind.powder, maker: 'Testmaker', name: 'TP-1'));
  final primer = await components.create(const ComponentDraft(
      kind: ComponentKind.primer, maker: 'Testmaker', name: 'LR'));
  return LoadRepository(db).create(LoadDraft(
    cartridgeId: cartridgeId,
    bulletId: bullet,
    powderId: powder,
    chargeGr: 42.5,
    primerId: primer,
    dateDeveloped: DateTime(2026, 3, 1),
  ));
}

void main() {
  testWidgets(
      'the free tier is lifetime: deleting a cartridge does not refund '
      'the slot', (tester) async {
    final db = makeTestDb();
    final kv = InMemoryKeyValueStore();
    // The same tally key the app's providers use — this repo instance
    // and the pumped screen share one lifetime figure.
    final repo = CartridgeRepository(db,
        tally: LifetimeTally(kv, key: kCartridgeTallyKey));
    await repo.create(name: '.308 Test');
    await repo.create(name: '6.5 Test');

    await tester.pumpWidget(
        testApp(db: db, kvStore: kv, home: const HomeScreen()));
    await tester.pumpAndSettle();
    expect(find.text('2 of 2 free cartridges used'), findsOneWidget);

    // Tidying the notebook doesn't mint a new slot.
    final second = (await db.select(db.cartridges).get()).last;
    await repo.delete(second.id);
    await tester.pumpAndSettle();
    expect(find.text('2 of 2 free cartridges used'), findsOneWidget);

    await tester.tap(find.text('Add cartridge'));
    await tester.pumpAndSettle();
    expect(find.text('Loadbook Pro'), findsOneWidget);
    // Equal citizens: monthly and lifetime side by side, restore too.
    expect(find.textContaining('Monthly ·'), findsOneWidget);
    expect(find.textContaining('Lifetime ·'), findsOneWidget);
    expect(find.text('Restore purchase'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro owners see no counter and no gate', (tester) async {
    final db = makeTestDb();
    final kv = InMemoryKeyValueStore();
    final repo = CartridgeRepository(db,
        tally: LifetimeTally(kv, key: kCartridgeTallyKey));
    await repo.create(name: '.308 Test');
    await repo.create(name: '6.5 Test');

    await tester.pumpWidget(testApp(
        db: db, kvStore: kv, entitled: true, home: const HomeScreen()));
    await tester.pumpAndSettle();
    expect(find.textContaining('free cartridges used'), findsNothing);

    // Past the free two, the composer dialog opens directly.
    await tester.tap(find.text('Add cartridge'));
    await tester.pumpAndSettle();
    expect(find.text('New cartridge'), findsOneWidget);
    expect(find.text('Loadbook Pro'), findsNothing);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets(
      'chrono fields are visible but paid: free tap opens the sheet',
      (tester) async {
    final db = makeTestDb();
    final loadId = await seedLoad(db);

    await tester.pumpWidget(
        testApp(db: db, home: SessionComposerScreen(loadId: loadId)));
    await tester.pumpAndSettle();

    // The fields sit where they belong, marked Pro.
    await tester.ensureVisible(find.text('Chronograph'));
    expect(find.widgetWithText(TextField, 'Avg'), findsOneWidget);
    expect(find.text('Pro'), findsOneWidget);

    await tester.tap(find.widgetWithText(TextField, 'Avg'));
    await tester.pumpAndSettle();
    expect(find.text('Loadbook Pro'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('Pro types chrono numbers straight in and they save',
      (tester) async {
    final db = makeTestDb();
    final loadId = await seedLoad(db);

    await tester.pumpWidget(testApp(
        db: db, entitled: true, home: SessionComposerScreen(loadId: loadId)));
    await tester.pumpAndSettle();

    expect(find.text('Pro'), findsNothing);
    await tester.enterText(
        find.widgetWithText(TextField, 'Distance'), '100');
    await tester.enterText(find.widgetWithText(TextField, 'Shots'), '5');
    await tester.ensureVisible(find.widgetWithText(TextField, 'Avg'));
    await tester.enterText(find.widgetWithText(TextField, 'Avg'), '2650.4');
    await tester.enterText(find.widgetWithText(TextField, 'SD'), '8.2');
    await tester.enterText(find.widgetWithText(TextField, 'ES'), '24');
    await tester.pumpAndSettle();
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();

    final session = await db.select(db.rangeSessions).getSingle();
    expect(session.chronoAvgFps, 2650.4);
    expect(session.chronoSdFps, 8.2);
    expect(session.chronoEsFps, 24);

    await disposeApp(tester);
    await db.close();
  });

  testWidgets('unlocking mid-flow continues into the composer dialog',
      (tester) async {
    final db = makeTestDb();
    final kv = InMemoryKeyValueStore();
    final fake = FakeEntitlementService();
    final repo = CartridgeRepository(db,
        tally: LifetimeTally(kv, key: kCartridgeTallyKey));
    await repo.create(name: '.308 Test');
    await repo.create(name: '6.5 Test');

    await tester.pumpWidget(testApp(
      db: db,
      kvStore: kv,
      home: const HomeScreen(),
      entitlements: fake,
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Add cartridge'));
    await tester.pumpAndSettle();
    expect(find.text('Loadbook Pro'), findsOneWidget);

    // The fake store grants Pro; the sheet closes itself with success
    // and the add continues to the dialog.
    await fake.buyUnlimited();
    await tester.pumpAndSettle();
    expect(find.text('New cartridge'), findsOneWidget);

    await disposeApp(tester);
    await db.close();
  });
}
