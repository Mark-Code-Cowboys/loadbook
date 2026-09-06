import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'app_database.g.dart';

/// This database's concrete journal repository type (cc_core's
/// JournalRepository is generic over the generated table classes).
typedef AppJournalRepository = JournalRepository<$AppJournalEntriesTable,
    $AppJournalPhotosTable, $AppJournalTagsTable>;

// Thin local registrations of cc_core's journal tables (drift can't
// analyze table classes across package boundaries in the default build
// mode, and @UseRowClass doesn't inherit). Names pinned to the shared
// schema so backups stay fleet-compatible.
@UseRowClass(JournalEntry)
class AppJournalEntries extends JournalEntries {
  @override
  String get tableName => 'journal_entries';
}

@UseRowClass(JournalPhoto)
class AppJournalPhotos extends JournalPhotos {
  @override
  String get tableName => 'journal_photos';
}

@UseRowClass(JournalTag)
class AppJournalTags extends JournalTags {
  @override
  String get tableName => 'journal_tags';
}

/// What a component is. Everything about a component is the user's own
/// transcription — the app ships no component catalog.
enum ComponentKind { powder, primer, bullet, brass }

/// Where a load stands in the user's own development notes.
enum LoadStatus { working, keeper, retired }

/// A cartridge the user loads for — the unit of the notebook (".308
/// Win" is whatever the user typed, never a lookup).
class Cartridges extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

/// One physical component as the user recorded it: a powder, primer,
/// bullet, or brass line from their own shelf. All fields user-entered.
class Components extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get kind => textEnum<ComponentKind>()();
  TextColumn get maker => text().withLength(min: 1, max: 120)();
  TextColumn get name => text().withLength(min: 1, max: 120)();
  TextColumn get lot => text().nullable()();
  // Bullet extras; null for the other kinds.
  RealColumn get weightGr => real().nullable()();
  TextColumn get bulletType => text().nullable()();
  TextColumn get notes => text().nullable()();
}

/// One recipe — the index card, digitized. The charge is the user's
/// own number, stored exactly as entered (rails: the app never
/// validates, flags, or bounds any charge). Notes ride a cc_core
/// journal entry.
///
/// Component references RESTRICT deletes: a notebook page never loses
/// the powder it named because the shelf entry was tidied away.
class Loads extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get cartridgeId =>
      integer().references(Cartridges, #id, onDelete: KeyAction.cascade)();
  IntColumn get bulletId =>
      integer().references(Components, #id, onDelete: KeyAction.restrict)();
  IntColumn get powderId =>
      integer().references(Components, #id, onDelete: KeyAction.restrict)();
  RealColumn get chargeGr => real()();
  IntColumn get primerId =>
      integer().references(Components, #id, onDelete: KeyAction.restrict)();
  IntColumn get brassId => integer()
      .nullable()
      .references(Components, #id, onDelete: KeyAction.restrict)();
  RealColumn get coalIn => real().nullable()();
  TextColumn get crimp => text().nullable()();
  DateTimeColumn get dateDeveloped => dateTime()();
  TextColumn get status =>
      textEnum<LoadStatus>().withDefault(const Constant('working'))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  // Raw-SQL FK for the same cross-package reason as the journal tables.
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

/// One trip to the range with one load. MOA is computed on-device from
/// distance + group (core/utils/moa.dart), never stored. Notes and
/// target photos ride a cc_core journal entry; the firearm is free
/// text only — this app keeps no firearm entity or registry.
class RangeSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get loadId =>
      integer().references(Loads, #id, onDelete: KeyAction.cascade)();
  DateTimeColumn get date => dateTime()();
  TextColumn get firearm => text().nullable()();
  IntColumn get distanceYd => integer()();
  IntColumn get shots => integer()();
  RealColumn get groupSizeIn => real().nullable()();
  RealColumn get chronoAvgFps => real().nullable()();
  RealColumn get chronoSdFps => real().nullable()();
  RealColumn get chronoEsFps => real().nullable()();
  TextColumn get weather => text().nullable()();
  IntColumn get journalEntryId => integer().nullable()();

  @override
  List<String> get customConstraints => [
        'FOREIGN KEY (journal_entry_id) REFERENCES journal_entries (id) '
            'ON DELETE SET NULL',
      ];
}

/// What's on the shelf for one component, in the user's own unit
/// ("lb", "ct", "pieces"). Cost is the user's paid price only — the
/// app never looks prices up (rails).
class Inventory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get componentId =>
      integer().references(Components, #id, onDelete: KeyAction.cascade)();
  RealColumn get qtyOnHand => real()();
  TextColumn get unit => text().withLength(min: 1, max: 40)();
  IntColumn get costPaidCents => integer().nullable()();
  DateTimeColumn get dateUpdated => dateTime()();
}

/// The reloading notebook: cartridges, components, loads, range
/// sessions, and shelf inventory over the shared journal tables.
@DriftDatabase(tables: [
  AppJournalEntries,
  AppJournalPhotos,
  AppJournalTags,
  Cartridges,
  Components,
  Loads,
  RangeSessions,
  Inventory,
])
class AppDatabase extends _$AppDatabase {
  /// Creates the database over any executor (tests pass an in-memory
  /// NativeDatabase).
  AppDatabase(super.e);

  /// The on-device database file.
  factory AppDatabase.open() =>
      AppDatabase(driftDatabase(name: 'loadbook'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        beforeOpen: (details) async {
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// cc_core's journal repository over this database's tables.
  AppJournalRepository journal({PhotoFileStore? photoStore}) =>
      JournalRepository(
        this,
        entries: appJournalEntries,
        photos: appJournalPhotos,
        tags: appJournalTags,
        photoStore: photoStore,
      );
}
