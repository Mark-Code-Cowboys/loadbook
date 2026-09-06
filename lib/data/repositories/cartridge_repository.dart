import 'dart:math';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:stream_transform/stream_transform.dart';

import '../database/app_database.dart';

/// A cartridge with how many loads its chapter holds.
class CartridgeListItem {
  const CartridgeListItem(this.cartridge, this.loadCount);

  final Cartridge cartridge;
  final int loadCount;
}

/// Cartridges — the notebook's chapters and the free-tier unit.
class CartridgeRepository {
  CartridgeRepository(this._db,
      {AppJournalRepository? journal, LifetimeTally? tally})
      // ignore: prefer_initializing_formals
      : _journalOverride = journal,
        _tally = tally; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  final LifetimeTally? _tally;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// Live row count.
  Future<int> count() async {
    final countExp = _db.cartridges.id.count();
    final query = _db.selectOnly(_db.cartridges)..addColumns([countExp]);
    return (await query.getSingle()).read(countExp)!;
  }

  /// Cartridges ever started on this device: the tally, but never
  /// below the live row count (pre-tally installs, backup restores).
  Future<int> lifetimeCreated() async {
    final live = await count();
    final tallied = await _tally?.value() ?? 0;
    return max(live, tallied);
  }

  /// Live [lifetimeCreated], ticking on creates and on row changes.
  Stream<int> watchLifetimeCreated() {
    final live =
        _db.select(_db.cartridges).watch().map((rows) => rows.length);
    final tallied = _tally?.watch() ?? Stream.value(0);
    return live.combineLatest(tallied, (int a, int b) => max(a, b));
  }

  /// All cartridges, oldest first (the order the notebook grew).
  Stream<List<Cartridge>> watchAll() {
    final query = _db.select(_db.cartridges)
      ..orderBy([(c) => OrderingTerm.asc(c.createdAt), (c) => OrderingTerm.asc(c.id)]);
    return query.watch();
  }

  /// The home list: every chapter with its load count. One watch over
  /// a grouped join so counts stay live as loads come and go.
  Stream<List<CartridgeListItem>> watchAllWithLoadCounts() {
    final countExp = _db.loads.id.count();
    final query = _db.select(_db.cartridges).join([
      leftOuterJoin(
          _db.loads, _db.loads.cartridgeId.equalsExp(_db.cartridges.id)),
    ])
      ..addColumns([countExp])
      ..groupBy([_db.cartridges.id])
      ..orderBy([
        OrderingTerm.asc(_db.cartridges.createdAt),
        OrderingTerm.asc(_db.cartridges.id),
      ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            CartridgeListItem(
                row.readTable(_db.cartridges), row.read(countExp) ?? 0),
        ]);
  }

  Future<Cartridge?> getById(int id) =>
      (_db.select(_db.cartridges)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  /// Adds a chapter; [name] is whatever the user wrote. Spends a
  /// free-tier slot (the tally never goes back down).
  Future<int> create({required String name, String? notes}) async {
    final id = await _db.into(_db.cartridges).insert(
        CartridgesCompanion.insert(name: name, notes: Value(notes)));
    await _tally?.recordCreated(liveCount: await count());
    return id;
  }

  Future<void> rename(int id, {required String name, String? notes}) =>
      (_db.update(_db.cartridges)..where((c) => c.id.equals(id))).write(
          CartridgesCompanion(name: Value(name), notes: Value(notes)));

  /// How many loads a delete would take with it.
  Future<int> loadCount(int id) async {
    final countExp = _db.loads.id.count();
    final query = _db.selectOnly(_db.loads)
      ..addColumns([countExp])
      ..where(_db.loads.cartridgeId.equals(id));
    return (await query.getSingle()).read(countExp)!;
  }

  /// Loads and their range sessions cascade with the cartridge; their
  /// journal entries (and target-photo files) are deleted explicitly
  /// since the FK points domain -> entry.
  Future<void> delete(int id) async {
    final loadIds = [
      for (final row in await (_db.selectOnly(_db.loads)
            ..addColumns([_db.loads.id])
            ..where(_db.loads.cartridgeId.equals(id)))
          .get())
        row.read(_db.loads.id)!,
    ];

    final entryIds = <int>[];
    if (loadIds.isNotEmpty) {
      final loadEntry = _db.loads.journalEntryId;
      for (final row in await (_db.selectOnly(_db.loads)
            ..addColumns([loadEntry])
            ..where(_db.loads.id.isIn(loadIds) & loadEntry.isNotNull()))
          .get()) {
        entryIds.add(row.read(loadEntry)!);
      }
      final sessionEntry = _db.rangeSessions.journalEntryId;
      for (final row in await (_db.selectOnly(_db.rangeSessions)
            ..addColumns([sessionEntry])
            ..where(_db.rangeSessions.loadId.isIn(loadIds) &
                sessionEntry.isNotNull()))
          .get()) {
        entryIds.add(row.read(sessionEntry)!);
      }
    }

    await (_db.delete(_db.cartridges)..where((c) => c.id.equals(id))).go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }
}
