import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Cartridges — the notebook's chapters and the free-tier unit.
class CartridgeRepository {
  CartridgeRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// All cartridges, oldest first (the order the notebook grew).
  Stream<List<Cartridge>> watchAll() {
    final query = _db.select(_db.cartridges)
      ..orderBy([(c) => OrderingTerm.asc(c.createdAt), (c) => OrderingTerm.asc(c.id)]);
    return query.watch();
  }

  Future<Cartridge?> getById(int id) =>
      (_db.select(_db.cartridges)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  /// Adds a chapter; [name] is whatever the user wrote.
  Future<int> create({required String name, String? notes}) =>
      _db.into(_db.cartridges).insert(CartridgesCompanion.insert(
          name: name, notes: Value(notes)));

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
