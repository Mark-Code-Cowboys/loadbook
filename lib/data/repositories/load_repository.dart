import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart' hide Component;

import '../database/app_database.dart';

/// A load joined with its notebook notes (the journal entry) and the
/// components it names.
class LoadWithStory {
  const LoadWithStory(
    this.load, {
    required this.bullet,
    required this.powder,
    required this.primer,
    this.brass,
    this.entry,
  });

  final Load load;
  final Component bullet;
  final Component powder;
  final Component primer;
  final Component? brass;
  final JournalEntry? entry;

  String? get notes => entry?.notes;
}

/// A recipe being composed. The charge is stored exactly as the user
/// entered it — no bounds, no flags (rails).
class LoadDraft {
  const LoadDraft({
    required this.cartridgeId,
    required this.bulletId,
    required this.powderId,
    required this.chargeGr,
    required this.primerId,
    this.brassId,
    this.coalIn,
    this.crimp,
    required this.dateDeveloped,
    this.status = LoadStatus.working,
    this.notes,
  });

  final int cartridgeId;
  final int bulletId;
  final int powderId;
  final double chargeGr;
  final int primerId;
  final int? brassId;
  final double? coalIn;
  final String? crimp;
  final DateTime dateDeveloped;
  final LoadStatus status;
  final String? notes;
}

/// Recipes. The journal entry carries the user's development notes;
/// this repository owns the entry lifecycle.
class LoadRepository {
  LoadRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// One cartridge's recipes, newest development first. The detail
  /// screen groups them by status.
  Stream<List<LoadWithStory>> watchByCartridge(int cartridgeId) {
    final query = _db.select(_db.loads)
      ..where((l) => l.cartridgeId.equals(cartridgeId))
      ..orderBy([
        (l) => OrderingTerm.desc(l.dateDeveloped),
        (l) => OrderingTerm.desc(l.id),
      ]);
    return query.watch().asyncMap(_withStories);
  }

  Stream<LoadWithStory?> watchOne(int id) {
    final query = _db.select(_db.loads)..where((l) => l.id.equals(id));
    return query
        .watchSingleOrNull()
        .asyncMap((l) async =>
            l == null ? null : (await _withStories([l])).first);
  }

  Future<int> create(LoadDraft d) => _db.transaction(() async {
        int? entryId;
        if (d.notes != null) {
          entryId =
              await _journal.createEntry(JournalEntryDraft(notes: d.notes));
        }
        return _db.into(_db.loads).insert(LoadsCompanion.insert(
              cartridgeId: d.cartridgeId,
              bulletId: d.bulletId,
              powderId: d.powderId,
              chargeGr: d.chargeGr,
              primerId: d.primerId,
              brassId: Value(d.brassId),
              coalIn: Value(d.coalIn),
              crimp: Value(d.crimp),
              dateDeveloped: d.dateDeveloped,
              status: Value(d.status),
              journalEntryId: Value(entryId),
            ));
      });

  Future<void> update(int id, LoadDraft d) => _db.transaction(() async {
        final load = await (_db.select(_db.loads)
              ..where((l) => l.id.equals(id)))
            .getSingle();
        var entryId = load.journalEntryId;
        if (d.notes != null && entryId == null) {
          entryId =
              await _journal.createEntry(JournalEntryDraft(notes: d.notes));
        } else if (entryId != null) {
          await _journal.updateEntry(entryId, notes: d.notes);
        }
        await (_db.update(_db.loads)..where((l) => l.id.equals(id)))
            .write(LoadsCompanion(
          bulletId: Value(d.bulletId),
          powderId: Value(d.powderId),
          chargeGr: Value(d.chargeGr),
          primerId: Value(d.primerId),
          brassId: Value(d.brassId),
          coalIn: Value(d.coalIn),
          crimp: Value(d.crimp),
          dateDeveloped: Value(d.dateDeveloped),
          status: Value(d.status),
          journalEntryId: Value(entryId),
        ));
      });

  /// Working -> keeper -> retired, wherever the user says it stands.
  Future<void> setStatus(int id, LoadStatus status) =>
      (_db.update(_db.loads)..where((l) => l.id.equals(id)))
          .write(LoadsCompanion(status: Value(status)));

  /// Range sessions cascade with the load; their journal entries (and
  /// target-photo files) are deleted explicitly since the FK points
  /// domain -> entry.
  Future<void> delete(int id) async {
    final sessionEntry = _db.rangeSessions.journalEntryId;
    final entryIds = [
      for (final row in await (_db.selectOnly(_db.rangeSessions)
            ..addColumns([sessionEntry])
            ..where(_db.rangeSessions.loadId.equals(id) &
                sessionEntry.isNotNull()))
          .get())
        row.read(sessionEntry)!,
    ];
    final load = await (_db.select(_db.loads)
          ..where((l) => l.id.equals(id)))
        .getSingleOrNull();
    if (load?.journalEntryId != null) entryIds.add(load!.journalEntryId!);
    await (_db.delete(_db.loads)..where((l) => l.id.equals(id))).go();
    if (entryIds.isNotEmpty) await _journal.deleteEntries(entryIds);
  }

  Future<List<LoadWithStory>> _withStories(List<Load> loads) async {
    if (loads.isEmpty) return const [];
    final componentIds = <int>{
      for (final l in loads) ...[
        l.bulletId,
        l.powderId,
        l.primerId,
        if (l.brassId != null) l.brassId!,
      ],
    };
    final components = {
      for (final c in await (_db.select(_db.components)
            ..where((c) => c.id.isIn(componentIds)))
          .get())
        c.id: c,
    };
    final entryIds = [
      for (final l in loads)
        if (l.journalEntryId != null) l.journalEntryId!,
    ];
    final entries = {
      for (final e in await (_db.select(_db.appJournalEntries)
            ..where((e) => e.id.isIn(entryIds)))
          .get())
        e.id: e,
    };
    return [
      for (final l in loads)
        LoadWithStory(
          l,
          bullet: components[l.bulletId]!,
          powder: components[l.powderId]!,
          primer: components[l.primerId]!,
          brass: l.brassId == null ? null : components[l.brassId!],
          entry: entries[l.journalEntryId],
        ),
    ];
  }
}
