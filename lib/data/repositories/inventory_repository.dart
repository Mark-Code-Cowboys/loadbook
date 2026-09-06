import 'package:drift/drift.dart' hide Component;

import '../database/app_database.dart';

/// One shelf line joined with the component it counts.
class InventoryLine {
  const InventoryLine(this.row, this.component);

  final InventoryData row;
  final Component component;
}

/// On-hand quantities, one line per component, in the user's own unit.
/// Costs are the user's paid prices only (rails). v1 is manual — no
/// auto-decrement on sessions.
class InventoryRepository {
  InventoryRepository(this._db);

  final AppDatabase _db;

  /// Every shelf line with its component, ordered like the shelf
  /// (kind, then maker/name).
  Stream<List<InventoryLine>> watchAll() {
    final query = _db.select(_db.inventory).join([
      innerJoin(_db.components,
          _db.components.id.equalsExp(_db.inventory.componentId)),
    ])
      ..orderBy([
        OrderingTerm.asc(_db.components.kind),
        OrderingTerm.asc(_db.components.maker),
        OrderingTerm.asc(_db.components.name),
      ]);
    return query.watch().map((rows) => [
          for (final row in rows)
            InventoryLine(row.readTable(_db.inventory),
                row.readTable(_db.components)),
        ]);
  }

  Future<InventoryData?> getForComponent(int componentId) =>
      (_db.select(_db.inventory)
            ..where((i) => i.componentId.equals(componentId)))
          .getSingleOrNull();

  /// Writes the line for [componentId] — one line per component, so an
  /// existing line is updated in place.
  Future<void> set({
    required int componentId,
    required double qtyOnHand,
    required String unit,
    int? costPaidCents,
    DateTime? now,
  }) async {
    final existing = await getForComponent(componentId);
    final companion = InventoryCompanion(
      componentId: Value(componentId),
      qtyOnHand: Value(qtyOnHand),
      unit: Value(unit),
      costPaidCents: Value(costPaidCents),
      dateUpdated: Value(now ?? DateTime.now()),
    );
    if (existing == null) {
      await _db.into(_db.inventory).insert(companion);
    } else {
      await (_db.update(_db.inventory)
            ..where((i) => i.id.equals(existing.id)))
          .write(companion);
    }
  }

  Future<void> delete(int id) =>
      (_db.delete(_db.inventory)..where((i) => i.id.equals(id))).go();
}
