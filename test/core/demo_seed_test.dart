import 'package:flutter_test/flutter_test.dart';

import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/database/seed.dart';

import '../helpers.dart';

void main() {
  test('the demo seed is unmistakably fictional (rails §1)', () async {
    final db = makeTestDb();
    await seedDemoData(db);

    final cartridges = await db.select(db.cartridges).get();
    expect([for (final c in cartridges) c.name],
        ['.30 Fable', '6.5 Folktale']);

    // Every charge is a repeating-digit placeholder — nothing anyone
    // could transcribe as a recipe.
    final loads = await db.select(db.loads).get();
    expect(loads, hasLength(5));
    expect({for (final l in loads) l.chargeGr}, {11.1, 22.2, 33.3});
    expect({for (final l in loads) l.coalIn}, {2.222});

    // Makers are fictional companies only.
    final components = await db.select(db.components).get();
    expect({for (final c in components) c.maker},
        {'Ponderosa', 'Bluestem', 'Caprock', 'Drybrush'});

    // Three trips with shrinking groups and a walking-down SD so both
    // trend lines draw.
    final sessions = await db.select(db.rangeSessions).get();
    expect([for (final s in sessions) s.groupSizeIn], [2.2, 1.6, 1.1]);
    expect([for (final s in sessions) s.chronoSdFps], [9.9, 8.8, 7.7]);

    expect(await db.select(db.inventory).get(), hasLength(3));

    await db.close();
  });

  test('seeding is a no-op on a phone with data', () async {
    final db = makeTestDb();
    await db
        .into(db.cartridges)
        .insert(CartridgesCompanion.insert(name: 'The real notebook'));
    await seedDemoData(db);
    final cartridges = await db.select(db.cartridges).get();
    expect(cartridges, hasLength(1));
    expect(cartridges.single.name, 'The real notebook');
    await db.close();
  });

  testWidgets('paintDemoTarget renders a real PNG', (tester) async {
    await tester.runAsync(() async {
      final bytes = await paintDemoTarget(1.1);
      // PNG signature.
      expect(bytes.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
      expect(bytes.length, greaterThan(1000));
    });
  });

  testWidgets('demo target photos land in the store', (tester) async {
    await tester.runAsync(() async {
      final db = makeTestDb();
      final photos = FakeAppPhotoService();
      await seedDemoData(db, photos: photos);
      final rows = await db.select(db.appJournalPhotos).get();
      expect([for (final p in rows) p.path],
          ['demo-target-1.png', 'demo-target-2.png', 'demo-target-3.png']);
      await db.close();
    });
  });
}
