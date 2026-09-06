import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';

import '../../core/utils/moa.dart';
import '../database/app_database.dart';

/// A range session joined with its notes and target photos.
class SessionWithStory {
  const SessionWithStory(this.session, {this.entry, this.photos = const []});

  final RangeSession session;
  final JournalEntry? entry;
  final List<JournalPhoto> photos;

  String? get notes => entry?.notes;

  /// Group in minutes of angle — computed here, never stored.
  double? get moa => moaFor(
      groupSizeIn: session.groupSizeIn, distanceYd: session.distanceYd);
}

/// A session being composed. Every measurement is the user's own; the
/// app records and computes, never judges (rails).
class SessionDraft {
  const SessionDraft({
    required this.loadId,
    required this.date,
    this.firearm,
    required this.distanceYd,
    required this.shots,
    this.groupSizeIn,
    this.chronoAvgFps,
    this.chronoSdFps,
    this.chronoEsFps,
    this.weather,
    this.notes,
    this.photos = const [],
  });

  final int loadId;
  final DateTime date;
  final String? firearm;
  final int distanceYd;
  final int shots;
  final double? groupSizeIn;
  final double? chronoAvgFps;
  final double? chronoSdFps;
  final double? chronoEsFps;
  final String? weather;
  final String? notes;
  final List<JournalPhotoDraft> photos;

  bool get hasStory => notes != null || photos.isNotEmpty;
}

/// Range trips. Target photos and notes ride a cc_core journal entry;
/// this repository owns the entry lifecycle.
class RangeSessionRepository {
  RangeSessionRepository(this._db, {AppJournalRepository? journal})
      : _journalOverride = journal; // ignore: prefer_initializing_formals

  final AppDatabase _db;
  final AppJournalRepository? _journalOverride;
  late final AppJournalRepository _journal =
      _journalOverride ?? _db.journal();

  /// One load's sessions, newest first — the history under the recipe
  /// card.
  Stream<List<SessionWithStory>> watchByLoad(int loadId) {
    final query = _db.select(_db.rangeSessions)
      ..where((s) => s.loadId.equals(loadId))
      ..orderBy([
        (s) => OrderingTerm.desc(s.date),
        (s) => OrderingTerm.desc(s.id),
      ]);
    return query.watch().asyncMap(_withStories);
  }

  Future<int> create(SessionDraft d) => _db.transaction(() async {
        int? entryId;
        if (d.hasStory) {
          entryId = await _journal.createEntry(
              JournalEntryDraft(notes: d.notes, photos: d.photos));
        }
        return _db.into(_db.rangeSessions).insert(
            RangeSessionsCompanion.insert(
              loadId: d.loadId,
              date: d.date,
              firearm: Value(d.firearm),
              distanceYd: d.distanceYd,
              shots: d.shots,
              groupSizeIn: Value(d.groupSizeIn),
              chronoAvgFps: Value(d.chronoAvgFps),
              chronoSdFps: Value(d.chronoSdFps),
              chronoEsFps: Value(d.chronoEsFps),
              weather: Value(d.weather),
              journalEntryId: Value(entryId),
            ));
      });

  /// Deletes the session and its journal entry (target-photo files
  /// go with the entry).
  Future<void> delete(int id) async {
    final session = await (_db.select(_db.rangeSessions)
          ..where((s) => s.id.equals(id)))
        .getSingleOrNull();
    await (_db.delete(_db.rangeSessions)..where((s) => s.id.equals(id)))
        .go();
    if (session?.journalEntryId != null) {
      await _journal.deleteEntry(session!.journalEntryId!);
    }
  }

  Future<List<SessionWithStory>> _withStories(
      List<RangeSession> sessions) async {
    if (sessions.isEmpty) return const [];
    final entryIds = [
      for (final s in sessions)
        if (s.journalEntryId != null) s.journalEntryId!,
    ];
    final entries = {
      for (final e in await (_db.select(_db.appJournalEntries)
            ..where((e) => e.id.isIn(entryIds)))
          .get())
        e.id: e,
    };
    final photos = await (_db.select(_db.appJournalPhotos)
          ..where((p) => p.entryId.isIn(entryIds))
          ..orderBy([(p) => OrderingTerm.asc(p.id)]))
        .get();
    return [
      for (final s in sessions)
        SessionWithStory(
          s,
          entry: entries[s.journalEntryId],
          photos: [
            for (final p in photos)
              if (p.entryId == s.journalEntryId) p,
          ],
        ),
    ];
  }
}
