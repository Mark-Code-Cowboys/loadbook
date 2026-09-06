import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/inventory_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/data/repositories/range_session_repository.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CartridgeRepository cartridges;
  late ComponentRepository components;
  late LoadRepository loads;
  late RangeSessionRepository sessions;
  late InventoryRepository inventory;

  setUp(() {
    db = makeTestDb();
    cartridges = CartridgeRepository(db);
    components = ComponentRepository(db);
    loads = LoadRepository(db);
    sessions = RangeSessionRepository(db);
    inventory = InventoryRepository(db);
  });

  tearDown(() => db.close());

  /// One of each kind, obviously fictional makers.
  Future<({int bullet, int powder, int primer, int brass})>
      seedComponents() async => (
            bullet: await components.create(const ComponentDraft(
                kind: ComponentKind.bullet,
                maker: 'Testmaker',
                name: 'Match',
                weightGr: 168,
                bulletType: 'HPBT')),
            powder: await components.create(const ComponentDraft(
                kind: ComponentKind.powder,
                maker: 'Testmaker',
                name: 'TP-1',
                lot: 'L42')),
            primer: await components.create(const ComponentDraft(
                kind: ComponentKind.primer,
                maker: 'Testmaker',
                name: 'LR')),
            brass: await components.create(const ComponentDraft(
                kind: ComponentKind.brass,
                maker: 'Testmaker',
                name: 'Once-fired')),
          );

  test('a load stores the charge exactly as entered — no bounds, no flags',
      () async {
    final cartridgeId =
        await cartridges.create(name: '.308 Test', notes: 'bench 1');
    final c = await seedComponents();

    // Rails: any number the user wrote goes in verbatim. The repo has
    // no notion of plausible.
    for (final charge in [42.5, 0.1, 999.9]) {
      await loads.create(LoadDraft(
        cartridgeId: cartridgeId,
        bulletId: c.bullet,
        powderId: c.powder,
        chargeGr: charge,
        primerId: c.primer,
        brassId: c.brass,
        coalIn: 2.800,
        crimp: 'light',
        dateDeveloped: DateTime(2026, 3, 1),
        notes: 'card $charge',
      ));
    }

    final rows = await loads.watchByCartridge(cartridgeId).first;
    expect(rows, hasLength(3));
    expect({for (final r in rows) r.load.chargeGr}, {42.5, 0.1, 999.9});
    final first = rows.firstWhere((r) => r.load.chargeGr == 42.5);
    expect(first.bullet.name, 'Match');
    expect(first.bullet.weightGr, 168);
    expect(first.powder.lot, 'L42');
    expect(first.brass?.name, 'Once-fired');
    expect(first.notes, 'card 42.5');
    expect(first.load.status, LoadStatus.working);
  });

  test('status walks working -> keeper -> retired', () async {
    final cartridgeId = await cartridges.create(name: '6.5 Test');
    final c = await seedComponents();
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 41.0,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 1, 5),
    ));

    await loads.setStatus(loadId, LoadStatus.keeper);
    var row = await loads.watchOne(loadId).first;
    expect(row!.load.status, LoadStatus.keeper);
    expect(row.brass, isNull);
    expect(row.entry, isNull);

    await loads.setStatus(loadId, LoadStatus.retired);
    row = await loads.watchOne(loadId).first;
    expect(row!.load.status, LoadStatus.retired);
  });

  test('updating a load without notes grows an entry; with one, edits it',
      () async {
    final cartridgeId = await cartridges.create(name: '.223 Test');
    final c = await seedComponents();
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 24.0,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 2, 2),
    ));

    await loads.update(
        loadId,
        LoadDraft(
          cartridgeId: cartridgeId,
          bulletId: c.bullet,
          powderId: c.powder,
          chargeGr: 24.2,
          primerId: c.primer,
          dateDeveloped: DateTime(2026, 2, 2),
          notes: 'seated deeper',
        ));
    var row = await loads.watchOne(loadId).first;
    expect(row!.load.chargeGr, 24.2);
    expect(row.notes, 'seated deeper');

    await loads.update(
        loadId,
        LoadDraft(
          cartridgeId: cartridgeId,
          bulletId: c.bullet,
          powderId: c.powder,
          chargeGr: 24.2,
          primerId: c.primer,
          dateDeveloped: DateTime(2026, 2, 2),
          notes: 'and crimped',
        ));
    row = await loads.watchOne(loadId).first;
    expect(row!.notes, 'and crimped');
    expect(await db.select(db.appJournalEntries).get(), hasLength(1));
  });

  test('a range session carries notes, target photos, and computed MOA',
      () async {
    final cartridgeId = await cartridges.create(name: '.308 Test');
    final c = await seedComponents();
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 42.5,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 3, 1),
    ));

    final sessionId = await sessions.create(SessionDraft(
      loadId: loadId,
      date: DateTime(2026, 3, 14),
      firearm: 'the heavy one',
      distanceYd: 100,
      shots: 5,
      groupSizeIn: 0.75,
      chronoAvgFps: 2650.4,
      chronoSdFps: 8.2,
      chronoEsFps: 24,
      weather: 'calm',
      notes: 'best group yet',
      photos: [const JournalPhotoDraft(path: 'target-1.jpg')],
    ));

    final rows = await sessions.watchByLoad(loadId).first;
    expect(rows, hasLength(1));
    final s = rows.single;
    expect(s.notes, 'best group yet');
    expect(s.photos.map((p) => p.path), ['target-1.jpg']);
    expect(s.moa, closeTo(0.75 / 1.047, 1e-9));
    expect(s.session.chronoAvgFps, 2650.4);

    await sessions.delete(sessionId);
    expect(await sessions.watchByLoad(loadId).first, isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
    expect(await db.select(db.appJournalPhotos).get(), isEmpty);
  });

  test('deleting a load takes its sessions and every journal entry',
      () async {
    final cartridgeId = await cartridges.create(name: '.308 Test');
    final c = await seedComponents();
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 42.5,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 3, 1),
      notes: 'the card',
    ));
    await sessions.create(SessionDraft(
      loadId: loadId,
      date: DateTime(2026, 3, 14),
      distanceYd: 100,
      shots: 5,
      notes: 'windy',
    ));

    await loads.delete(loadId);
    expect(await db.select(db.loads).get(), isEmpty);
    expect(await db.select(db.rangeSessions).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
  });

  test('deleting a cartridge cleans the whole chapter', () async {
    final cartridgeId = await cartridges.create(name: '.308 Test');
    final c = await seedComponents();
    for (var i = 0; i < 2; i++) {
      final loadId = await loads.create(LoadDraft(
        cartridgeId: cartridgeId,
        bulletId: c.bullet,
        powderId: c.powder,
        chargeGr: 42.0 + i,
        primerId: c.primer,
        dateDeveloped: DateTime(2026, 3, 1 + i),
        notes: 'card $i',
      ));
      await sessions.create(SessionDraft(
        loadId: loadId,
        date: DateTime(2026, 4, 1 + i),
        distanceYd: 100,
        shots: 5,
        notes: 'trip $i',
      ));
    }
    expect(await cartridges.loadCount(cartridgeId), 2);

    await cartridges.delete(cartridgeId);
    expect(await db.select(db.cartridges).get(), isEmpty);
    expect(await db.select(db.loads).get(), isEmpty);
    expect(await db.select(db.rangeSessions).get(), isEmpty);
    expect(await db.select(db.appJournalEntries).get(), isEmpty);
    // The shelf survives the chapter.
    expect(await db.select(db.components).get(), hasLength(4));
  });

  test('components named by a load refuse deletion; unused ones go',
      () async {
    final cartridgeId = await cartridges.create(name: '.308 Test');
    final c = await seedComponents();
    await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: c.bullet,
      powderId: c.powder,
      chargeGr: 42.5,
      primerId: c.primer,
      dateDeveloped: DateTime(2026, 3, 1),
    ));

    expect(await components.isInUse(c.powder), isTrue);
    await expectLater(components.delete(c.powder), throwsA(anything));
    // Brass wasn't named by this load.
    expect(await components.isInUse(c.brass), isFalse);
    await components.delete(c.brass);
    expect(await db.select(db.components).get(), hasLength(3));
  });

  test('inventory keeps one line per component, updated in place',
      () async {
    final c = await seedComponents();
    await inventory.set(
        componentId: c.powder,
        qtyOnHand: 1,
        unit: 'lb',
        costPaidCents: 4599,
        now: DateTime(2026, 1, 1));
    await inventory.set(
        componentId: c.powder,
        qtyOnHand: 0.4,
        unit: 'lb',
        costPaidCents: 4599,
        now: DateTime(2026, 5, 1));
    await inventory.set(
        componentId: c.primer,
        qtyOnHand: 700,
        unit: 'ct',
        now: DateTime(2026, 2, 1));

    final lines = await inventory.watchAll().first;
    expect(lines, hasLength(2));
    final powderLine =
        lines.singleWhere((l) => l.component.id == c.powder);
    expect(powderLine.row.qtyOnHand, 0.4);
    expect(powderLine.row.costPaidCents, 4599);
    expect(powderLine.row.dateUpdated, DateTime(2026, 5, 1));
    final primerLine =
        lines.singleWhere((l) => l.component.id == c.primer);
    expect(primerLine.row.unit, 'ct');
    expect(primerLine.row.costPaidCents, isNull);
  });
}
