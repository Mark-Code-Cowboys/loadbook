import 'package:flutter_test/flutter_test.dart';
import 'package:loadbook/data/database/app_database.dart';
import 'package:loadbook/data/repositories/cartridge_repository.dart';
import 'package:loadbook/data/repositories/component_repository.dart';
import 'package:loadbook/data/repositories/load_repository.dart';
import 'package:loadbook/features/scan_import/card_parser.dart';
import 'package:loadbook/features/scan_import/notebook_importer.dart';

import '../helpers.dart';

void main() {
  late AppDatabase db;
  late CartridgeRepository cartridges;
  late ComponentRepository components;
  late LoadRepository loads;

  setUp(() {
    db = makeTestDb();
    cartridges = CartridgeRepository(db);
    components = ComponentRepository(db);
    loads = LoadRepository(db);
  });

  tearDown(() => db.close());

  Future<ImportReport> run(List<CardDraft> drafts) => insertCardDrafts(
      db: db,
      cartridges: cartridges,
      components: components,
      loads: loads,
      drafts: drafts);

  test('splitMakerName: one word means no maker was written', () {
    expect(splitMakerName('Fakeco TP-1'),
        (maker: 'Fakeco', name: 'TP-1'));
    expect(splitMakerName('Testmaker Match King'),
        (maker: 'Testmaker', name: 'Match King'));
    expect(splitMakerName('TP-1'), (maker: '—', name: 'TP-1'));
  });

  test('cards file under matched-or-created cartridges and components',
      () async {
    // The user already has a chapter and a powder; the card's casing
    // differs — matching is case-insensitive, never duplicating.
    final existing = await cartridges.create(name: '.308 Win');
    await components.create(const ComponentDraft(
        kind: ComponentKind.powder, maker: 'Fakeco', name: 'TP-1'));

    final report = await run([
      CardDraft(
        cartridge: '.308 WIN',
        bullet: 'Testmaker Match',
        bulletWeightGr: 168,
        powder: 'fakeco tp-1',
        chargeGr: 42.5,
        primer: 'Testmaker LR',
        date: DateTime(2024, 3, 14),
        notes: 'from the shoebox',
      ),
      CardDraft(
        cartridge: '6.5 Test',
        bullet: 'Testmaker Heavy',
        powder: 'Fakeco TP-1',
        chargeGr: 41,
        primer: 'Testmaker LR',
      ),
    ]);

    expect(report.loadsAdded, 2);
    expect(report.cartridgesCreated, 1);
    expect(report.skipped, 0);

    final allCartridges = await db.select(db.cartridges).get();
    expect(allCartridges, hasLength(2));
    expect(allCartridges.first.id, existing);

    final allComponents = await db.select(db.components).get();
    // One powder (matched), two bullets, one primer (shared).
    expect(
        allComponents.where((c) => c.kind == ComponentKind.powder),
        hasLength(1));
    expect(
        allComponents.where((c) => c.kind == ComponentKind.primer),
        hasLength(1));

    final first = await loads.watchByCartridge(existing).first;
    expect(first.single.load.chargeGr, 42.5);
    expect(first.single.notes, 'from the shoebox');
    expect(first.single.bullet.weightGr, 168);
  });

  test('incomplete cards are skipped and counted, never guessed at',
      () async {
    final report = await run([
      CardDraft(cartridge: '.308 Test', powder: 'TP-1', chargeGr: 42.5),
      CardDraft(
        cartridge: '.308 Test',
        bullet: 'Testmaker Match',
        powder: 'TP-1',
        chargeGr: 42.5,
        primer: 'Testmaker LR',
      ),
    ]);
    expect(report.loadsAdded, 1);
    expect(report.skipped, 1);
    expect(report.summary, contains('1 card skipped'));
    expect(await db.select(db.loads).get(), hasLength(1));
  });

  test('a dateless card files under today', () async {
    await run([
      CardDraft(
        cartridge: '.308 Test',
        bullet: 'Match',
        powder: 'TP-1',
        chargeGr: 42.5,
        primer: 'LR',
      ),
    ]);
    final load = await db.select(db.loads).getSingle();
    final now = DateTime.now();
    expect(load.dateDeveloped.year, now.year);
    expect(load.dateDeveloped.month, now.month);
    expect(load.dateDeveloped.day, now.day);
    // The one-word components carry the "—" placeholder maker.
    final bullet = (await db.select(db.components).get())
        .singleWhere((c) => c.kind == ComponentKind.bullet);
    expect(bullet.maker, '—');
    expect(bullet.name, 'Match');
  });
}
