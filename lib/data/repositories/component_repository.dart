import 'package:drift/drift.dart' hide Component;

import '../database/app_database.dart';

/// A component being composed — every field the user's own words.
class ComponentDraft {
  const ComponentDraft({
    required this.kind,
    required this.maker,
    required this.name,
    this.lot,
    this.weightGr,
    this.bulletType,
    this.notes,
  });

  final ComponentKind kind;
  final String maker;
  final String name;
  final String? lot;
  final double? weightGr;
  final String? bulletType;
  final String? notes;
}

/// The shelf: powders, primers, bullets, brass as the user recorded
/// them. No catalog, no lookups — creation is always user entry.
class ComponentRepository {
  ComponentRepository(this._db);

  final AppDatabase _db;

  /// Everything on the shelf, grouped naturally by kind then name.
  Stream<List<Component>> watchAll() {
    final query = _db.select(_db.components)
      ..orderBy([
        (c) => OrderingTerm.asc(c.kind),
        (c) => OrderingTerm.asc(c.maker),
        (c) => OrderingTerm.asc(c.name),
      ]);
    return query.watch();
  }

  /// One kind, for the load composer's pickers.
  Stream<List<Component>> watchByKind(ComponentKind kind) {
    final query = _db.select(_db.components)
      ..where((c) => c.kind.equals(kind.name))
      ..orderBy([
        (c) => OrderingTerm.asc(c.maker),
        (c) => OrderingTerm.asc(c.name),
      ]);
    return query.watch();
  }

  Future<Component?> getById(int id) =>
      (_db.select(_db.components)..where((c) => c.id.equals(id)))
          .getSingleOrNull();

  Future<int> create(ComponentDraft d) =>
      _db.into(_db.components).insert(ComponentsCompanion.insert(
            kind: d.kind,
            maker: d.maker,
            name: d.name,
            lot: Value(d.lot),
            weightGr: Value(d.weightGr),
            bulletType: Value(d.bulletType),
            notes: Value(d.notes),
          ));

  Future<void> update(int id, ComponentDraft d) =>
      (_db.update(_db.components)..where((c) => c.id.equals(id)))
          .write(ComponentsCompanion(
        kind: Value(d.kind),
        maker: Value(d.maker),
        name: Value(d.name),
        lot: Value(d.lot),
        weightGr: Value(d.weightGr),
        bulletType: Value(d.bulletType),
        notes: Value(d.notes),
      ));

  /// True when any load names this component — deletes are RESTRICTed
  /// then, so callers can offer the honest explanation up front.
  Future<bool> isInUse(int id) async {
    final l = _db.loads;
    final query = _db.selectOnly(l)
      ..addColumns([l.id])
      ..where(l.bulletId.equals(id) |
          l.powderId.equals(id) |
          l.primerId.equals(id) |
          l.brassId.equals(id))
      ..limit(1);
    return (await query.get()).isNotEmpty;
  }

  /// Deletes a shelf entry (its inventory line cascades). Throws on a
  /// component any load still names — check [isInUse] first.
  Future<void> delete(int id) =>
      (_db.delete(_db.components)..where((c) => c.id.equals(id))).go();
}
