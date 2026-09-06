import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart' hide Component;

import '../../core/utils/moa.dart';
import '../../data/database/app_database.dart';
import '../backup/backup_service.dart';

/// Writes exports to temp files and hands them to the share sheet.
/// The temp directory is injected so tests stay plugin-free.
class ExportService {
  ExportService(this._db, this._share, this._tempDir,
      {PhotoService? photos})
      : _photos = photos; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final ShareLauncher _share;
  final Future<Directory> Function() _tempDir;
  final PhotoService? _photos;

  /// Loads and sessions flattened into one sheet: a row per range
  /// session joined with its full recipe, and a row with empty session
  /// columns for every load never taken out. MOA is the same recorded
  /// arithmetic the screens show. Returns the written file.
  Future<File> shareLoadsCsv({DateTime? now}) async {
    final cartridges = {
      for (final c in await _db.select(_db.cartridges).get()) c.id: c,
    };
    final components = {
      for (final c in await _db.select(_db.components).get()) c.id: c,
    };
    final loads = await (_db.select(_db.loads)
          ..orderBy([(t) => OrderingTerm.asc(t.id)]))
        .get();
    final sessions = await (_db.select(_db.rangeSessions)
          ..orderBy([
            (t) => OrderingTerm.asc(t.date),
            (t) => OrderingTerm.asc(t.id),
          ]))
        .get();
    final entries = {
      for (final e in await _db.select(_db.appJournalEntries).get())
        e.id: e,
    };

    String? componentName(int? id) {
      final c = components[id];
      return c == null ? null : '${c.maker} ${c.name}';
    }

    List<Object?> row(Load l, RangeSession? s) => [
          cartridges[l.cartridgeId]?.name,
          l.status.name,
          componentName(l.bulletId),
          components[l.bulletId]?.weightGr,
          componentName(l.powderId),
          l.chargeGr,
          componentName(l.primerId),
          componentName(l.brassId),
          l.coalIn,
          l.crimp,
          l.dateDeveloped.toIso8601String().substring(0, 10),
          entries[l.journalEntryId]?.notes,
          s?.date.toIso8601String().substring(0, 10),
          s?.firearm,
          s?.distanceYd,
          s?.shots,
          s?.groupSizeIn,
          s == null
              ? null
              : moaFor(
                      groupSizeIn: s.groupSizeIn,
                      distanceYd: s.distanceYd)
                  ?.toStringAsFixed(3),
          s?.chronoAvgFps,
          s?.chronoSdFps,
          s?.chronoEsFps,
          s?.weather,
          entries[s?.journalEntryId]?.notes,
        ];

    final csv = buildCsv([
      [
        'cartridge', 'status', 'bullet', 'bullet_weight_gr', 'powder',
        'charge_gr', 'primer', 'brass', 'coal_in', 'crimp',
        'date_developed', 'load_notes', 'session_date', 'firearm',
        'distance_yd', 'shots', 'group_in', 'moa', 'chrono_avg_fps',
        'chrono_sd_fps', 'chrono_es_fps', 'weather', 'session_notes',
      ],
      for (final l in loads) ...[
        if (sessions.every((s) => s.loadId != l.id)) row(l, null),
        for (final s in sessions)
          if (s.loadId == l.id) row(l, s),
      ],
    ]);

    return shareStampedFile(
      share: _share,
      tempDir: _tempDir,
      baseName: 'loadbook-loads',
      extension: 'csv',
      mimeType: 'text/csv',
      shareText: 'Loadbook loads and sessions',
      text: csv,
      now: now,
    );
  }

  /// The full notebook as one zip: export JSON plus target photos.
  Future<File> shareBackup(
      {required int lifetimeCartridges, DateTime? now}) async {
    final store = _photos;
    final bytes = buildBackupArchive(
      exportData: await buildExportData(_db,
          lifetimeCartridges: lifetimeCartridges, now: now),
      media: store == null
          ? const {}
          : await _db.journal().collectMedia(store),
    );
    return shareStampedFile(
      share: _share,
      tempDir: _tempDir,
      baseName: 'loadbook-backup',
      extension: 'zip',
      mimeType: 'application/zip',
      shareText: 'Loadbook backup',
      bytes: bytes,
      now: now,
    );
  }
}
