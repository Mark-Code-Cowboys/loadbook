import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart' hide Component;

import '../../data/database/app_database.dart';

/// The whole notebook as a JSON-encodable map (format 1). Pure data —
/// photo files are referenced by store name; the backup archive
/// carries their bytes separately.
Future<Map<String, Object?>> buildExportData(
  AppDatabase db, {
  required int lifetimeCartridges,
  DateTime? now,
}) async {
  final cartridges = await (db.select(db.cartridges)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final components = await (db.select(db.components)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final loads =
      await (db.select(db.loads)..orderBy([(t) => OrderingTerm.asc(t.id)]))
          .get();
  final sessions = await (db.select(db.rangeSessions)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  final inventory = await (db.select(db.inventory)
        ..orderBy([(t) => OrderingTerm.asc(t.id)]))
      .get();
  return {
    'app': 'Loadbook',
    'format': 1,
    'exportedAt': (now ?? DateTime.now()).toIso8601String(),
    // Carried so a restore never resets the free tier (raiseTo).
    'lifetimeCartridges': lifetimeCartridges,
    'cartridges': [
      for (final c in cartridges)
        {
          'id': c.id,
          'name': c.name,
          'notes': c.notes,
          'createdAt': c.createdAt.toIso8601String(),
        },
    ],
    'components': [
      for (final c in components)
        {
          'id': c.id,
          'kind': c.kind.name,
          'maker': c.maker,
          'name': c.name,
          'lot': c.lot,
          'weightGr': c.weightGr,
          'bulletType': c.bulletType,
          'notes': c.notes,
        },
    ],
    'loads': [
      for (final l in loads)
        {
          'id': l.id,
          'cartridgeId': l.cartridgeId,
          'bulletId': l.bulletId,
          'powderId': l.powderId,
          'chargeGr': l.chargeGr,
          'primerId': l.primerId,
          'brassId': l.brassId,
          'coalIn': l.coalIn,
          'crimp': l.crimp,
          'dateDeveloped': l.dateDeveloped.toIso8601String(),
          'status': l.status.name,
          'createdAt': l.createdAt.toIso8601String(),
          'journalEntryId': l.journalEntryId,
        },
    ],
    'rangeSessions': [
      for (final s in sessions)
        {
          'id': s.id,
          'loadId': s.loadId,
          'date': s.date.toIso8601String(),
          'firearm': s.firearm,
          'distanceYd': s.distanceYd,
          'shots': s.shots,
          'groupSizeIn': s.groupSizeIn,
          'chronoAvgFps': s.chronoAvgFps,
          'chronoSdFps': s.chronoSdFps,
          'chronoEsFps': s.chronoEsFps,
          'weather': s.weather,
          'journalEntryId': s.journalEntryId,
        },
    ],
    'inventory': [
      for (final i in inventory)
        {
          'id': i.id,
          'componentId': i.componentId,
          'qtyOnHand': i.qtyOnHand,
          'unit': i.unit,
          'costPaidCents': i.costPaidCents,
          'dateUpdated': i.dateUpdated.toIso8601String(),
        },
    ],
    ...await db.journal().dumpJournalTables(),
  };
}

/// Replaces the entire notebook with the contents of an export. Runs
/// in one transaction; ids are preserved.
///
/// Returns the backup's lifetime-cartridges figure so the caller can
/// `raiseTo` the tally (never lowered).
Future<int> restoreFromExportData(
    AppDatabase db, Map<String, Object?> data) async {
  if (data['app'] != 'Loadbook' || data['format'] != 1) {
    throw const InvalidBackupException('Unrecognized export format');
  }
  final cartridges = data['cartridges'];
  final components = data['components'];
  final loads = data['loads'];
  final sessions = data['rangeSessions'];
  final inventory = data['inventory'];
  if (cartridges is! List ||
      components is! List ||
      loads is! List ||
      sessions is! List ||
      inventory is! List) {
    throw const InvalidBackupException('Malformed export tables');
  }

  await db.transaction(() async {
    // Loads RESTRICT component deletes, so the chapters go first
    // (loads and sessions cascade), then the shelf (inventory
    // cascades), then the journal.
    await db.delete(db.cartridges).go();
    await db.delete(db.components).go();
    await db.delete(db.appJournalEntries).go();

    await db.journal().restoreJournalTables(data);

    for (final row in components.cast<Map<String, dynamic>>()) {
      await db.into(db.components).insert(ComponentsCompanion(
            id: Value(row['id'] as int),
            kind: Value(
                ComponentKind.values.byName(row['kind'] as String)),
            maker: Value(row['maker'] as String),
            name: Value(row['name'] as String),
            lot: Value(row['lot'] as String?),
            weightGr: Value((row['weightGr'] as num?)?.toDouble()),
            bulletType: Value(row['bulletType'] as String?),
            notes: Value(row['notes'] as String?),
          ));
    }
    for (final row in cartridges.cast<Map<String, dynamic>>()) {
      await db.into(db.cartridges).insert(CartridgesCompanion(
            id: Value(row['id'] as int),
            name: Value(row['name'] as String),
            notes: Value(row['notes'] as String?),
            createdAt: Value(DateTime.parse(row['createdAt'] as String)),
          ));
    }
    for (final row in loads.cast<Map<String, dynamic>>()) {
      await db.into(db.loads).insert(LoadsCompanion(
            id: Value(row['id'] as int),
            cartridgeId: Value(row['cartridgeId'] as int),
            bulletId: Value(row['bulletId'] as int),
            powderId: Value(row['powderId'] as int),
            chargeGr: Value((row['chargeGr'] as num).toDouble()),
            primerId: Value(row['primerId'] as int),
            brassId: Value(row['brassId'] as int?),
            coalIn: Value((row['coalIn'] as num?)?.toDouble()),
            crimp: Value(row['crimp'] as String?),
            dateDeveloped:
                Value(DateTime.parse(row['dateDeveloped'] as String)),
            status:
                Value(LoadStatus.values.byName(row['status'] as String)),
            createdAt: Value(DateTime.parse(row['createdAt'] as String)),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in sessions.cast<Map<String, dynamic>>()) {
      await db.into(db.rangeSessions).insert(RangeSessionsCompanion(
            id: Value(row['id'] as int),
            loadId: Value(row['loadId'] as int),
            date: Value(DateTime.parse(row['date'] as String)),
            firearm: Value(row['firearm'] as String?),
            distanceYd: Value(row['distanceYd'] as int),
            shots: Value(row['shots'] as int),
            groupSizeIn: Value((row['groupSizeIn'] as num?)?.toDouble()),
            chronoAvgFps:
                Value((row['chronoAvgFps'] as num?)?.toDouble()),
            chronoSdFps: Value((row['chronoSdFps'] as num?)?.toDouble()),
            chronoEsFps: Value((row['chronoEsFps'] as num?)?.toDouble()),
            weather: Value(row['weather'] as String?),
            journalEntryId: Value(row['journalEntryId'] as int?),
          ));
    }
    for (final row in inventory.cast<Map<String, dynamic>>()) {
      await db.into(db.inventory).insert(InventoryCompanion(
            id: Value(row['id'] as int),
            componentId: Value(row['componentId'] as int),
            qtyOnHand: Value((row['qtyOnHand'] as num).toDouble()),
            unit: Value(row['unit'] as String),
            costPaidCents: Value(row['costPaidCents'] as int?),
            dateUpdated:
                Value(DateTime.parse(row['dateUpdated'] as String)),
          ));
    }
  });
  return (data['lifetimeCartridges'] as num?)?.toInt() ??
      cartridges.length;
}
