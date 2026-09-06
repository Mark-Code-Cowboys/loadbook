import 'package:cc_core/cc_core.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/core/backup/backup_service.dart';
import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/inventory_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/data/repositories/range_session_repository.dart';

import '../helpers.dart';

void main() {
  test('the whole notebook survives a backup round trip', () async {
    final source = makeTestDb();
    final cartridges = CartridgeRepository(source);
    final components = ComponentRepository(source);
    final loads = LoadRepository(source);
    final sessions = RangeSessionRepository(source);
    final inventory = InventoryRepository(source);

    final cartridgeId =
        await cartridges.create(name: '.308 Test', notes: 'bench 1');
    final bullet = await components.create(const ComponentDraft(
        kind: ComponentKind.bullet,
        maker: 'Testmaker',
        name: 'Match',
        weightGr: 168,
        bulletType: 'HPBT'));
    final powder = await components.create(const ComponentDraft(
        kind: ComponentKind.powder,
        maker: 'Fakeco',
        name: 'TP-1',
        lot: 'L42'));
    final primer = await components.create(const ComponentDraft(
        kind: ComponentKind.primer, maker: 'Testmaker', name: 'LR'));
    final loadId = await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: bullet,
      powderId: powder,
      chargeGr: 42.5,
      primerId: primer,
      coalIn: 2.8,
      crimp: 'light',
      dateDeveloped: DateTime(2026, 3, 1),
      status: LoadStatus.keeper,
      notes: 'the card',
    ));
    await sessions.create(SessionDraft(
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
    await inventory.set(
        componentId: powder,
        qtyOnHand: 0.4,
        unit: 'lb',
        costPaidCents: 4599,
        now: DateTime(2026, 5, 1));

    final data =
        await buildExportData(source, lifetimeCartridges: 5, now: DateTime(2026, 6, 1));

    final target = makeTestDb();
    final lifetime = await restoreFromExportData(target, data);
    expect(lifetime, 5);

    final cartridge = await target.select(target.cartridges).getSingle();
    expect(cartridge.name, '.308 Test');
    expect(cartridge.notes, 'bench 1');

    final load = await target.select(target.loads).getSingle();
    expect(load.chargeGr, 42.5);
    expect(load.status, LoadStatus.keeper);
    expect(load.coalIn, 2.8);

    final restored =
        await LoadRepository(target).watchByCartridge(cartridge.id).first;
    expect(restored.single.notes, 'the card');
    expect(restored.single.powder.lot, 'L42');
    expect(restored.single.bullet.weightGr, 168);

    final session =
        await RangeSessionRepository(target).watchByLoad(load.id).first;
    expect(session.single.notes, 'best group yet');
    expect(session.single.photos.map((p) => p.path), ['target-1.jpg']);
    expect(session.single.session.chronoSdFps, 8.2);
    expect(session.single.moa, closeTo(0.75 / 1.047, 1e-9));

    final line =
        (await InventoryRepository(target).watchAll().first).single;
    expect(line.row.qtyOnHand, 0.4);
    expect(line.row.costPaidCents, 4599);
    expect(line.component.name, 'TP-1');

    await source.close();
    await target.close();
  });

  test('restore replaces, never merges', () async {
    final source = makeTestDb();
    await CartridgeRepository(source).create(name: '.308 Test');
    final data = await buildExportData(source, lifetimeCartridges: 1);

    final target = makeTestDb();
    await CartridgeRepository(target).create(name: 'Stale chapter');
    await restoreFromExportData(target, data);
    final names = [
      for (final c in await target.select(target.cartridges).get()) c.name,
    ];
    expect(names, ['.308 Test']);

    await source.close();
    await target.close();
  });

  test('foreign exports are refused whole', () async {
    final db = makeTestDb();
    await expectLater(
        restoreFromExportData(db, {'app': 'FreshPot', 'format': 1}),
        throwsA(isA<InvalidBackupException>()));
    await expectLater(restoreFromExportData(db, {'app': 'Loadbook'}),
        throwsA(isA<InvalidBackupException>()));
    await db.close();
  });
}
