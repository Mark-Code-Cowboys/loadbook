// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AppJournalEntriesTable extends AppJournalEntries
    with TableInfo<$AppJournalEntriesTable, JournalEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    true,
    check: () => ComparableExpr(rating).isBetweenValues(1, 5),
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, notes, rating, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalEntry(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AppJournalEntriesTable createAlias(String alias) {
    return $AppJournalEntriesTable(attachedDatabase, alias);
  }
}

class AppJournalEntriesCompanion extends UpdateCompanion<JournalEntry> {
  final Value<int> id;
  final Value<String?> notes;
  final Value<int?> rating;
  final Value<DateTime> createdAt;
  const AppJournalEntriesCompanion({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  AppJournalEntriesCompanion.insert({
    this.id = const Value.absent(),
    this.notes = const Value.absent(),
    this.rating = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  static Insertable<JournalEntry> custom({
    Expression<int>? id,
    Expression<String>? notes,
    Expression<int>? rating,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notes != null) 'notes': notes,
      if (rating != null) 'rating': rating,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  AppJournalEntriesCompanion copyWith({
    Value<int>? id,
    Value<String?>? notes,
    Value<int?>? rating,
    Value<DateTime>? createdAt,
  }) {
    return AppJournalEntriesCompanion(
      id: id ?? this.id,
      notes: notes ?? this.notes,
      rating: rating ?? this.rating,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalEntriesCompanion(')
          ..write('id: $id, ')
          ..write('notes: $notes, ')
          ..write('rating: $rating, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $AppJournalPhotosTable extends AppJournalPhotos
    with TableInfo<$AppJournalPhotosTable, JournalPhoto> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalPhotosTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _captionMeta = const VerificationMeta(
    'caption',
  );
  @override
  late final GeneratedColumn<String> caption = GeneratedColumn<String>(
    'caption',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, path, caption];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_photos';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalPhoto> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('caption')) {
      context.handle(
        _captionMeta,
        caption.isAcceptableOrUnknown(data['caption']!, _captionMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  JournalPhoto map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalPhoto(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      path: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}path'],
      )!,
      caption: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}caption'],
      ),
    );
  }

  @override
  $AppJournalPhotosTable createAlias(String alias) {
    return $AppJournalPhotosTable(attachedDatabase, alias);
  }
}

class AppJournalPhotosCompanion extends UpdateCompanion<JournalPhoto> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> path;
  final Value<String?> caption;
  const AppJournalPhotosCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.path = const Value.absent(),
    this.caption = const Value.absent(),
  });
  AppJournalPhotosCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String path,
    this.caption = const Value.absent(),
  }) : entryId = Value(entryId),
       path = Value(path);
  static Insertable<JournalPhoto> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? path,
    Expression<String>? caption,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (path != null) 'path': path,
      if (caption != null) 'caption': caption,
    });
  }

  AppJournalPhotosCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? path,
    Value<String?>? caption,
  }) {
    return AppJournalPhotosCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      path: path ?? this.path,
      caption: caption ?? this.caption,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (caption.present) {
      map['caption'] = Variable<String>(caption.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalPhotosCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('path: $path, ')
          ..write('caption: $caption')
          ..write(')'))
        .toString();
  }
}

class $AppJournalTagsTable extends AppJournalTags
    with TableInfo<$AppJournalTagsTable, JournalTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppJournalTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _entryIdMeta = const VerificationMeta(
    'entryId',
  );
  @override
  late final GeneratedColumn<int> entryId = GeneratedColumn<int>(
    'entry_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagMeta = const VerificationMeta('tag');
  @override
  late final GeneratedColumn<String> tag = GeneratedColumn<String>(
    'tag',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 60,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, entryId, tag];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'journal_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<JournalTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('entry_id')) {
      context.handle(
        _entryIdMeta,
        entryId.isAcceptableOrUnknown(data['entry_id']!, _entryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entryIdMeta);
    }
    if (data.containsKey('tag')) {
      context.handle(
        _tagMeta,
        tag.isAcceptableOrUnknown(data['tag']!, _tagMeta),
      );
    } else if (isInserting) {
      context.missing(_tagMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {entryId, tag},
  ];
  @override
  JournalTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return JournalTag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      entryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}entry_id'],
      )!,
      tag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag'],
      )!,
    );
  }

  @override
  $AppJournalTagsTable createAlias(String alias) {
    return $AppJournalTagsTable(attachedDatabase, alias);
  }
}

class AppJournalTagsCompanion extends UpdateCompanion<JournalTag> {
  final Value<int> id;
  final Value<int> entryId;
  final Value<String> tag;
  const AppJournalTagsCompanion({
    this.id = const Value.absent(),
    this.entryId = const Value.absent(),
    this.tag = const Value.absent(),
  });
  AppJournalTagsCompanion.insert({
    this.id = const Value.absent(),
    required int entryId,
    required String tag,
  }) : entryId = Value(entryId),
       tag = Value(tag);
  static Insertable<JournalTag> custom({
    Expression<int>? id,
    Expression<int>? entryId,
    Expression<String>? tag,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entryId != null) 'entry_id': entryId,
      if (tag != null) 'tag': tag,
    });
  }

  AppJournalTagsCompanion copyWith({
    Value<int>? id,
    Value<int>? entryId,
    Value<String>? tag,
  }) {
    return AppJournalTagsCompanion(
      id: id ?? this.id,
      entryId: entryId ?? this.entryId,
      tag: tag ?? this.tag,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (entryId.present) {
      map['entry_id'] = Variable<int>(entryId.value);
    }
    if (tag.present) {
      map['tag'] = Variable<String>(tag.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppJournalTagsCompanion(')
          ..write('id: $id, ')
          ..write('entryId: $entryId, ')
          ..write('tag: $tag')
          ..write(')'))
        .toString();
  }
}

class $CartridgesTable extends Cartridges
    with TableInfo<$CartridgesTable, Cartridge> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CartridgesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, notes, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cartridges';
  @override
  VerificationContext validateIntegrity(
    Insertable<Cartridge> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Cartridge map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Cartridge(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CartridgesTable createAlias(String alias) {
    return $CartridgesTable(attachedDatabase, alias);
  }
}

class Cartridge extends DataClass implements Insertable<Cartridge> {
  final int id;
  final String name;
  final String? notes;
  final DateTime createdAt;
  const Cartridge({
    required this.id,
    required this.name,
    this.notes,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CartridgesCompanion toCompanion(bool nullToAbsent) {
    return CartridgesCompanion(
      id: Value(id),
      name: Value(name),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      createdAt: Value(createdAt),
    );
  }

  factory Cartridge.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Cartridge(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'notes': serializer.toJson<String?>(notes),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Cartridge copyWith({
    int? id,
    String? name,
    Value<String?> notes = const Value.absent(),
    DateTime? createdAt,
  }) => Cartridge(
    id: id ?? this.id,
    name: name ?? this.name,
    notes: notes.present ? notes.value : this.notes,
    createdAt: createdAt ?? this.createdAt,
  );
  Cartridge copyWithCompanion(CartridgesCompanion data) {
    return Cartridge(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Cartridge(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, notes, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Cartridge &&
          other.id == this.id &&
          other.name == this.name &&
          other.notes == this.notes &&
          other.createdAt == this.createdAt);
}

class CartridgesCompanion extends UpdateCompanion<Cartridge> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> notes;
  final Value<DateTime> createdAt;
  const CartridgesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  CartridgesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.notes = const Value.absent(),
    this.createdAt = const Value.absent(),
  }) : name = Value(name);
  static Insertable<Cartridge> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? notes,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (notes != null) 'notes': notes,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  CartridgesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? notes,
    Value<DateTime>? createdAt,
  }) {
    return CartridgesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CartridgesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('notes: $notes, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $ComponentsTable extends Components
    with TableInfo<$ComponentsTable, Component> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ComponentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ComponentKind, String> kind =
      GeneratedColumn<String>(
        'kind',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<ComponentKind>($ComponentsTable.$converterkind);
  static const VerificationMeta _makerMeta = const VerificationMeta('maker');
  @override
  late final GeneratedColumn<String> maker = GeneratedColumn<String>(
    'maker',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lotMeta = const VerificationMeta('lot');
  @override
  late final GeneratedColumn<String> lot = GeneratedColumn<String>(
    'lot',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weightGrMeta = const VerificationMeta(
    'weightGr',
  );
  @override
  late final GeneratedColumn<double> weightGr = GeneratedColumn<double>(
    'weight_gr',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bulletTypeMeta = const VerificationMeta(
    'bulletType',
  );
  @override
  late final GeneratedColumn<String> bulletType = GeneratedColumn<String>(
    'bullet_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    kind,
    maker,
    name,
    lot,
    weightGr,
    bulletType,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'components';
  @override
  VerificationContext validateIntegrity(
    Insertable<Component> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('maker')) {
      context.handle(
        _makerMeta,
        maker.isAcceptableOrUnknown(data['maker']!, _makerMeta),
      );
    } else if (isInserting) {
      context.missing(_makerMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('lot')) {
      context.handle(
        _lotMeta,
        lot.isAcceptableOrUnknown(data['lot']!, _lotMeta),
      );
    }
    if (data.containsKey('weight_gr')) {
      context.handle(
        _weightGrMeta,
        weightGr.isAcceptableOrUnknown(data['weight_gr']!, _weightGrMeta),
      );
    }
    if (data.containsKey('bullet_type')) {
      context.handle(
        _bulletTypeMeta,
        bulletType.isAcceptableOrUnknown(data['bullet_type']!, _bulletTypeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Component map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Component(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      kind: $ComponentsTable.$converterkind.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}kind'],
        )!,
      ),
      maker: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}maker'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      lot: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}lot'],
      ),
      weightGr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_gr'],
      ),
      bulletType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bullet_type'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $ComponentsTable createAlias(String alias) {
    return $ComponentsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<ComponentKind, String, String> $converterkind =
      const EnumNameConverter<ComponentKind>(ComponentKind.values);
}

class Component extends DataClass implements Insertable<Component> {
  final int id;
  final ComponentKind kind;
  final String maker;
  final String name;
  final String? lot;
  final double? weightGr;
  final String? bulletType;
  final String? notes;
  const Component({
    required this.id,
    required this.kind,
    required this.maker,
    required this.name,
    this.lot,
    this.weightGr,
    this.bulletType,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['kind'] = Variable<String>(
        $ComponentsTable.$converterkind.toSql(kind),
      );
    }
    map['maker'] = Variable<String>(maker);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || lot != null) {
      map['lot'] = Variable<String>(lot);
    }
    if (!nullToAbsent || weightGr != null) {
      map['weight_gr'] = Variable<double>(weightGr);
    }
    if (!nullToAbsent || bulletType != null) {
      map['bullet_type'] = Variable<String>(bulletType);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  ComponentsCompanion toCompanion(bool nullToAbsent) {
    return ComponentsCompanion(
      id: Value(id),
      kind: Value(kind),
      maker: Value(maker),
      name: Value(name),
      lot: lot == null && nullToAbsent ? const Value.absent() : Value(lot),
      weightGr: weightGr == null && nullToAbsent
          ? const Value.absent()
          : Value(weightGr),
      bulletType: bulletType == null && nullToAbsent
          ? const Value.absent()
          : Value(bulletType),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory Component.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Component(
      id: serializer.fromJson<int>(json['id']),
      kind: $ComponentsTable.$converterkind.fromJson(
        serializer.fromJson<String>(json['kind']),
      ),
      maker: serializer.fromJson<String>(json['maker']),
      name: serializer.fromJson<String>(json['name']),
      lot: serializer.fromJson<String?>(json['lot']),
      weightGr: serializer.fromJson<double?>(json['weightGr']),
      bulletType: serializer.fromJson<String?>(json['bulletType']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'kind': serializer.toJson<String>(
        $ComponentsTable.$converterkind.toJson(kind),
      ),
      'maker': serializer.toJson<String>(maker),
      'name': serializer.toJson<String>(name),
      'lot': serializer.toJson<String?>(lot),
      'weightGr': serializer.toJson<double?>(weightGr),
      'bulletType': serializer.toJson<String?>(bulletType),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Component copyWith({
    int? id,
    ComponentKind? kind,
    String? maker,
    String? name,
    Value<String?> lot = const Value.absent(),
    Value<double?> weightGr = const Value.absent(),
    Value<String?> bulletType = const Value.absent(),
    Value<String?> notes = const Value.absent(),
  }) => Component(
    id: id ?? this.id,
    kind: kind ?? this.kind,
    maker: maker ?? this.maker,
    name: name ?? this.name,
    lot: lot.present ? lot.value : this.lot,
    weightGr: weightGr.present ? weightGr.value : this.weightGr,
    bulletType: bulletType.present ? bulletType.value : this.bulletType,
    notes: notes.present ? notes.value : this.notes,
  );
  Component copyWithCompanion(ComponentsCompanion data) {
    return Component(
      id: data.id.present ? data.id.value : this.id,
      kind: data.kind.present ? data.kind.value : this.kind,
      maker: data.maker.present ? data.maker.value : this.maker,
      name: data.name.present ? data.name.value : this.name,
      lot: data.lot.present ? data.lot.value : this.lot,
      weightGr: data.weightGr.present ? data.weightGr.value : this.weightGr,
      bulletType: data.bulletType.present
          ? data.bulletType.value
          : this.bulletType,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Component(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('maker: $maker, ')
          ..write('name: $name, ')
          ..write('lot: $lot, ')
          ..write('weightGr: $weightGr, ')
          ..write('bulletType: $bulletType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, kind, maker, name, lot, weightGr, bulletType, notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Component &&
          other.id == this.id &&
          other.kind == this.kind &&
          other.maker == this.maker &&
          other.name == this.name &&
          other.lot == this.lot &&
          other.weightGr == this.weightGr &&
          other.bulletType == this.bulletType &&
          other.notes == this.notes);
}

class ComponentsCompanion extends UpdateCompanion<Component> {
  final Value<int> id;
  final Value<ComponentKind> kind;
  final Value<String> maker;
  final Value<String> name;
  final Value<String?> lot;
  final Value<double?> weightGr;
  final Value<String?> bulletType;
  final Value<String?> notes;
  const ComponentsCompanion({
    this.id = const Value.absent(),
    this.kind = const Value.absent(),
    this.maker = const Value.absent(),
    this.name = const Value.absent(),
    this.lot = const Value.absent(),
    this.weightGr = const Value.absent(),
    this.bulletType = const Value.absent(),
    this.notes = const Value.absent(),
  });
  ComponentsCompanion.insert({
    this.id = const Value.absent(),
    required ComponentKind kind,
    required String maker,
    required String name,
    this.lot = const Value.absent(),
    this.weightGr = const Value.absent(),
    this.bulletType = const Value.absent(),
    this.notes = const Value.absent(),
  }) : kind = Value(kind),
       maker = Value(maker),
       name = Value(name);
  static Insertable<Component> custom({
    Expression<int>? id,
    Expression<String>? kind,
    Expression<String>? maker,
    Expression<String>? name,
    Expression<String>? lot,
    Expression<double>? weightGr,
    Expression<String>? bulletType,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (kind != null) 'kind': kind,
      if (maker != null) 'maker': maker,
      if (name != null) 'name': name,
      if (lot != null) 'lot': lot,
      if (weightGr != null) 'weight_gr': weightGr,
      if (bulletType != null) 'bullet_type': bulletType,
      if (notes != null) 'notes': notes,
    });
  }

  ComponentsCompanion copyWith({
    Value<int>? id,
    Value<ComponentKind>? kind,
    Value<String>? maker,
    Value<String>? name,
    Value<String?>? lot,
    Value<double?>? weightGr,
    Value<String?>? bulletType,
    Value<String?>? notes,
  }) {
    return ComponentsCompanion(
      id: id ?? this.id,
      kind: kind ?? this.kind,
      maker: maker ?? this.maker,
      name: name ?? this.name,
      lot: lot ?? this.lot,
      weightGr: weightGr ?? this.weightGr,
      bulletType: bulletType ?? this.bulletType,
      notes: notes ?? this.notes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (kind.present) {
      map['kind'] = Variable<String>(
        $ComponentsTable.$converterkind.toSql(kind.value),
      );
    }
    if (maker.present) {
      map['maker'] = Variable<String>(maker.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (lot.present) {
      map['lot'] = Variable<String>(lot.value);
    }
    if (weightGr.present) {
      map['weight_gr'] = Variable<double>(weightGr.value);
    }
    if (bulletType.present) {
      map['bullet_type'] = Variable<String>(bulletType.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ComponentsCompanion(')
          ..write('id: $id, ')
          ..write('kind: $kind, ')
          ..write('maker: $maker, ')
          ..write('name: $name, ')
          ..write('lot: $lot, ')
          ..write('weightGr: $weightGr, ')
          ..write('bulletType: $bulletType, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $LoadsTable extends Loads with TableInfo<$LoadsTable, Load> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LoadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _cartridgeIdMeta = const VerificationMeta(
    'cartridgeId',
  );
  @override
  late final GeneratedColumn<int> cartridgeId = GeneratedColumn<int>(
    'cartridge_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES cartridges (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _bulletIdMeta = const VerificationMeta(
    'bulletId',
  );
  @override
  late final GeneratedColumn<int> bulletId = GeneratedColumn<int>(
    'bullet_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _powderIdMeta = const VerificationMeta(
    'powderId',
  );
  @override
  late final GeneratedColumn<int> powderId = GeneratedColumn<int>(
    'powder_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _chargeGrMeta = const VerificationMeta(
    'chargeGr',
  );
  @override
  late final GeneratedColumn<double> chargeGr = GeneratedColumn<double>(
    'charge_gr',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _primerIdMeta = const VerificationMeta(
    'primerId',
  );
  @override
  late final GeneratedColumn<int> primerId = GeneratedColumn<int>(
    'primer_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _brassIdMeta = const VerificationMeta(
    'brassId',
  );
  @override
  late final GeneratedColumn<int> brassId = GeneratedColumn<int>(
    'brass_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _coalInMeta = const VerificationMeta('coalIn');
  @override
  late final GeneratedColumn<double> coalIn = GeneratedColumn<double>(
    'coal_in',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _crimpMeta = const VerificationMeta('crimp');
  @override
  late final GeneratedColumn<String> crimp = GeneratedColumn<String>(
    'crimp',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateDevelopedMeta = const VerificationMeta(
    'dateDeveloped',
  );
  @override
  late final GeneratedColumn<DateTime> dateDeveloped =
      GeneratedColumn<DateTime>(
        'date_developed',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  @override
  late final GeneratedColumnWithTypeConverter<LoadStatus, String> status =
      GeneratedColumn<String>(
        'status',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultValue: const Constant('working'),
      ).withConverter<LoadStatus>($LoadsTable.$converterstatus);
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    cartridgeId,
    bulletId,
    powderId,
    chargeGr,
    primerId,
    brassId,
    coalIn,
    crimp,
    dateDeveloped,
    status,
    createdAt,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'loads';
  @override
  VerificationContext validateIntegrity(
    Insertable<Load> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('cartridge_id')) {
      context.handle(
        _cartridgeIdMeta,
        cartridgeId.isAcceptableOrUnknown(
          data['cartridge_id']!,
          _cartridgeIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cartridgeIdMeta);
    }
    if (data.containsKey('bullet_id')) {
      context.handle(
        _bulletIdMeta,
        bulletId.isAcceptableOrUnknown(data['bullet_id']!, _bulletIdMeta),
      );
    } else if (isInserting) {
      context.missing(_bulletIdMeta);
    }
    if (data.containsKey('powder_id')) {
      context.handle(
        _powderIdMeta,
        powderId.isAcceptableOrUnknown(data['powder_id']!, _powderIdMeta),
      );
    } else if (isInserting) {
      context.missing(_powderIdMeta);
    }
    if (data.containsKey('charge_gr')) {
      context.handle(
        _chargeGrMeta,
        chargeGr.isAcceptableOrUnknown(data['charge_gr']!, _chargeGrMeta),
      );
    } else if (isInserting) {
      context.missing(_chargeGrMeta);
    }
    if (data.containsKey('primer_id')) {
      context.handle(
        _primerIdMeta,
        primerId.isAcceptableOrUnknown(data['primer_id']!, _primerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_primerIdMeta);
    }
    if (data.containsKey('brass_id')) {
      context.handle(
        _brassIdMeta,
        brassId.isAcceptableOrUnknown(data['brass_id']!, _brassIdMeta),
      );
    }
    if (data.containsKey('coal_in')) {
      context.handle(
        _coalInMeta,
        coalIn.isAcceptableOrUnknown(data['coal_in']!, _coalInMeta),
      );
    }
    if (data.containsKey('crimp')) {
      context.handle(
        _crimpMeta,
        crimp.isAcceptableOrUnknown(data['crimp']!, _crimpMeta),
      );
    }
    if (data.containsKey('date_developed')) {
      context.handle(
        _dateDevelopedMeta,
        dateDeveloped.isAcceptableOrUnknown(
          data['date_developed']!,
          _dateDevelopedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateDevelopedMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Load map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Load(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      cartridgeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cartridge_id'],
      )!,
      bulletId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}bullet_id'],
      )!,
      powderId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}powder_id'],
      )!,
      chargeGr: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}charge_gr'],
      )!,
      primerId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}primer_id'],
      )!,
      brassId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}brass_id'],
      ),
      coalIn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}coal_in'],
      ),
      crimp: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}crimp'],
      ),
      dateDeveloped: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_developed'],
      )!,
      status: $LoadsTable.$converterstatus.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}status'],
        )!,
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $LoadsTable createAlias(String alias) {
    return $LoadsTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<LoadStatus, String, String> $converterstatus =
      const EnumNameConverter<LoadStatus>(LoadStatus.values);
}

class Load extends DataClass implements Insertable<Load> {
  final int id;
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
  final DateTime createdAt;
  final int? journalEntryId;
  const Load({
    required this.id,
    required this.cartridgeId,
    required this.bulletId,
    required this.powderId,
    required this.chargeGr,
    required this.primerId,
    this.brassId,
    this.coalIn,
    this.crimp,
    required this.dateDeveloped,
    required this.status,
    required this.createdAt,
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['cartridge_id'] = Variable<int>(cartridgeId);
    map['bullet_id'] = Variable<int>(bulletId);
    map['powder_id'] = Variable<int>(powderId);
    map['charge_gr'] = Variable<double>(chargeGr);
    map['primer_id'] = Variable<int>(primerId);
    if (!nullToAbsent || brassId != null) {
      map['brass_id'] = Variable<int>(brassId);
    }
    if (!nullToAbsent || coalIn != null) {
      map['coal_in'] = Variable<double>(coalIn);
    }
    if (!nullToAbsent || crimp != null) {
      map['crimp'] = Variable<String>(crimp);
    }
    map['date_developed'] = Variable<DateTime>(dateDeveloped);
    {
      map['status'] = Variable<String>(
        $LoadsTable.$converterstatus.toSql(status),
      );
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  LoadsCompanion toCompanion(bool nullToAbsent) {
    return LoadsCompanion(
      id: Value(id),
      cartridgeId: Value(cartridgeId),
      bulletId: Value(bulletId),
      powderId: Value(powderId),
      chargeGr: Value(chargeGr),
      primerId: Value(primerId),
      brassId: brassId == null && nullToAbsent
          ? const Value.absent()
          : Value(brassId),
      coalIn: coalIn == null && nullToAbsent
          ? const Value.absent()
          : Value(coalIn),
      crimp: crimp == null && nullToAbsent
          ? const Value.absent()
          : Value(crimp),
      dateDeveloped: Value(dateDeveloped),
      status: Value(status),
      createdAt: Value(createdAt),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory Load.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Load(
      id: serializer.fromJson<int>(json['id']),
      cartridgeId: serializer.fromJson<int>(json['cartridgeId']),
      bulletId: serializer.fromJson<int>(json['bulletId']),
      powderId: serializer.fromJson<int>(json['powderId']),
      chargeGr: serializer.fromJson<double>(json['chargeGr']),
      primerId: serializer.fromJson<int>(json['primerId']),
      brassId: serializer.fromJson<int?>(json['brassId']),
      coalIn: serializer.fromJson<double?>(json['coalIn']),
      crimp: serializer.fromJson<String?>(json['crimp']),
      dateDeveloped: serializer.fromJson<DateTime>(json['dateDeveloped']),
      status: $LoadsTable.$converterstatus.fromJson(
        serializer.fromJson<String>(json['status']),
      ),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'cartridgeId': serializer.toJson<int>(cartridgeId),
      'bulletId': serializer.toJson<int>(bulletId),
      'powderId': serializer.toJson<int>(powderId),
      'chargeGr': serializer.toJson<double>(chargeGr),
      'primerId': serializer.toJson<int>(primerId),
      'brassId': serializer.toJson<int?>(brassId),
      'coalIn': serializer.toJson<double?>(coalIn),
      'crimp': serializer.toJson<String?>(crimp),
      'dateDeveloped': serializer.toJson<DateTime>(dateDeveloped),
      'status': serializer.toJson<String>(
        $LoadsTable.$converterstatus.toJson(status),
      ),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  Load copyWith({
    int? id,
    int? cartridgeId,
    int? bulletId,
    int? powderId,
    double? chargeGr,
    int? primerId,
    Value<int?> brassId = const Value.absent(),
    Value<double?> coalIn = const Value.absent(),
    Value<String?> crimp = const Value.absent(),
    DateTime? dateDeveloped,
    LoadStatus? status,
    DateTime? createdAt,
    Value<int?> journalEntryId = const Value.absent(),
  }) => Load(
    id: id ?? this.id,
    cartridgeId: cartridgeId ?? this.cartridgeId,
    bulletId: bulletId ?? this.bulletId,
    powderId: powderId ?? this.powderId,
    chargeGr: chargeGr ?? this.chargeGr,
    primerId: primerId ?? this.primerId,
    brassId: brassId.present ? brassId.value : this.brassId,
    coalIn: coalIn.present ? coalIn.value : this.coalIn,
    crimp: crimp.present ? crimp.value : this.crimp,
    dateDeveloped: dateDeveloped ?? this.dateDeveloped,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  Load copyWithCompanion(LoadsCompanion data) {
    return Load(
      id: data.id.present ? data.id.value : this.id,
      cartridgeId: data.cartridgeId.present
          ? data.cartridgeId.value
          : this.cartridgeId,
      bulletId: data.bulletId.present ? data.bulletId.value : this.bulletId,
      powderId: data.powderId.present ? data.powderId.value : this.powderId,
      chargeGr: data.chargeGr.present ? data.chargeGr.value : this.chargeGr,
      primerId: data.primerId.present ? data.primerId.value : this.primerId,
      brassId: data.brassId.present ? data.brassId.value : this.brassId,
      coalIn: data.coalIn.present ? data.coalIn.value : this.coalIn,
      crimp: data.crimp.present ? data.crimp.value : this.crimp,
      dateDeveloped: data.dateDeveloped.present
          ? data.dateDeveloped.value
          : this.dateDeveloped,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Load(')
          ..write('id: $id, ')
          ..write('cartridgeId: $cartridgeId, ')
          ..write('bulletId: $bulletId, ')
          ..write('powderId: $powderId, ')
          ..write('chargeGr: $chargeGr, ')
          ..write('primerId: $primerId, ')
          ..write('brassId: $brassId, ')
          ..write('coalIn: $coalIn, ')
          ..write('crimp: $crimp, ')
          ..write('dateDeveloped: $dateDeveloped, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    cartridgeId,
    bulletId,
    powderId,
    chargeGr,
    primerId,
    brassId,
    coalIn,
    crimp,
    dateDeveloped,
    status,
    createdAt,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Load &&
          other.id == this.id &&
          other.cartridgeId == this.cartridgeId &&
          other.bulletId == this.bulletId &&
          other.powderId == this.powderId &&
          other.chargeGr == this.chargeGr &&
          other.primerId == this.primerId &&
          other.brassId == this.brassId &&
          other.coalIn == this.coalIn &&
          other.crimp == this.crimp &&
          other.dateDeveloped == this.dateDeveloped &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.journalEntryId == this.journalEntryId);
}

class LoadsCompanion extends UpdateCompanion<Load> {
  final Value<int> id;
  final Value<int> cartridgeId;
  final Value<int> bulletId;
  final Value<int> powderId;
  final Value<double> chargeGr;
  final Value<int> primerId;
  final Value<int?> brassId;
  final Value<double?> coalIn;
  final Value<String?> crimp;
  final Value<DateTime> dateDeveloped;
  final Value<LoadStatus> status;
  final Value<DateTime> createdAt;
  final Value<int?> journalEntryId;
  const LoadsCompanion({
    this.id = const Value.absent(),
    this.cartridgeId = const Value.absent(),
    this.bulletId = const Value.absent(),
    this.powderId = const Value.absent(),
    this.chargeGr = const Value.absent(),
    this.primerId = const Value.absent(),
    this.brassId = const Value.absent(),
    this.coalIn = const Value.absent(),
    this.crimp = const Value.absent(),
    this.dateDeveloped = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  LoadsCompanion.insert({
    this.id = const Value.absent(),
    required int cartridgeId,
    required int bulletId,
    required int powderId,
    required double chargeGr,
    required int primerId,
    this.brassId = const Value.absent(),
    this.coalIn = const Value.absent(),
    this.crimp = const Value.absent(),
    required DateTime dateDeveloped,
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : cartridgeId = Value(cartridgeId),
       bulletId = Value(bulletId),
       powderId = Value(powderId),
       chargeGr = Value(chargeGr),
       primerId = Value(primerId),
       dateDeveloped = Value(dateDeveloped);
  static Insertable<Load> custom({
    Expression<int>? id,
    Expression<int>? cartridgeId,
    Expression<int>? bulletId,
    Expression<int>? powderId,
    Expression<double>? chargeGr,
    Expression<int>? primerId,
    Expression<int>? brassId,
    Expression<double>? coalIn,
    Expression<String>? crimp,
    Expression<DateTime>? dateDeveloped,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (cartridgeId != null) 'cartridge_id': cartridgeId,
      if (bulletId != null) 'bullet_id': bulletId,
      if (powderId != null) 'powder_id': powderId,
      if (chargeGr != null) 'charge_gr': chargeGr,
      if (primerId != null) 'primer_id': primerId,
      if (brassId != null) 'brass_id': brassId,
      if (coalIn != null) 'coal_in': coalIn,
      if (crimp != null) 'crimp': crimp,
      if (dateDeveloped != null) 'date_developed': dateDeveloped,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  LoadsCompanion copyWith({
    Value<int>? id,
    Value<int>? cartridgeId,
    Value<int>? bulletId,
    Value<int>? powderId,
    Value<double>? chargeGr,
    Value<int>? primerId,
    Value<int?>? brassId,
    Value<double?>? coalIn,
    Value<String?>? crimp,
    Value<DateTime>? dateDeveloped,
    Value<LoadStatus>? status,
    Value<DateTime>? createdAt,
    Value<int?>? journalEntryId,
  }) {
    return LoadsCompanion(
      id: id ?? this.id,
      cartridgeId: cartridgeId ?? this.cartridgeId,
      bulletId: bulletId ?? this.bulletId,
      powderId: powderId ?? this.powderId,
      chargeGr: chargeGr ?? this.chargeGr,
      primerId: primerId ?? this.primerId,
      brassId: brassId ?? this.brassId,
      coalIn: coalIn ?? this.coalIn,
      crimp: crimp ?? this.crimp,
      dateDeveloped: dateDeveloped ?? this.dateDeveloped,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (cartridgeId.present) {
      map['cartridge_id'] = Variable<int>(cartridgeId.value);
    }
    if (bulletId.present) {
      map['bullet_id'] = Variable<int>(bulletId.value);
    }
    if (powderId.present) {
      map['powder_id'] = Variable<int>(powderId.value);
    }
    if (chargeGr.present) {
      map['charge_gr'] = Variable<double>(chargeGr.value);
    }
    if (primerId.present) {
      map['primer_id'] = Variable<int>(primerId.value);
    }
    if (brassId.present) {
      map['brass_id'] = Variable<int>(brassId.value);
    }
    if (coalIn.present) {
      map['coal_in'] = Variable<double>(coalIn.value);
    }
    if (crimp.present) {
      map['crimp'] = Variable<String>(crimp.value);
    }
    if (dateDeveloped.present) {
      map['date_developed'] = Variable<DateTime>(dateDeveloped.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(
        $LoadsTable.$converterstatus.toSql(status.value),
      );
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LoadsCompanion(')
          ..write('id: $id, ')
          ..write('cartridgeId: $cartridgeId, ')
          ..write('bulletId: $bulletId, ')
          ..write('powderId: $powderId, ')
          ..write('chargeGr: $chargeGr, ')
          ..write('primerId: $primerId, ')
          ..write('brassId: $brassId, ')
          ..write('coalIn: $coalIn, ')
          ..write('crimp: $crimp, ')
          ..write('dateDeveloped: $dateDeveloped, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $RangeSessionsTable extends RangeSessions
    with TableInfo<$RangeSessionsTable, RangeSession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RangeSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _loadIdMeta = const VerificationMeta('loadId');
  @override
  late final GeneratedColumn<int> loadId = GeneratedColumn<int>(
    'load_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES loads (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _firearmMeta = const VerificationMeta(
    'firearm',
  );
  @override
  late final GeneratedColumn<String> firearm = GeneratedColumn<String>(
    'firearm',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _distanceYdMeta = const VerificationMeta(
    'distanceYd',
  );
  @override
  late final GeneratedColumn<int> distanceYd = GeneratedColumn<int>(
    'distance_yd',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _shotsMeta = const VerificationMeta('shots');
  @override
  late final GeneratedColumn<int> shots = GeneratedColumn<int>(
    'shots',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _groupSizeInMeta = const VerificationMeta(
    'groupSizeIn',
  );
  @override
  late final GeneratedColumn<double> groupSizeIn = GeneratedColumn<double>(
    'group_size_in',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chronoAvgFpsMeta = const VerificationMeta(
    'chronoAvgFps',
  );
  @override
  late final GeneratedColumn<double> chronoAvgFps = GeneratedColumn<double>(
    'chrono_avg_fps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chronoSdFpsMeta = const VerificationMeta(
    'chronoSdFps',
  );
  @override
  late final GeneratedColumn<double> chronoSdFps = GeneratedColumn<double>(
    'chrono_sd_fps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _chronoEsFpsMeta = const VerificationMeta(
    'chronoEsFps',
  );
  @override
  late final GeneratedColumn<double> chronoEsFps = GeneratedColumn<double>(
    'chrono_es_fps',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weatherMeta = const VerificationMeta(
    'weather',
  );
  @override
  late final GeneratedColumn<String> weather = GeneratedColumn<String>(
    'weather',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _journalEntryIdMeta = const VerificationMeta(
    'journalEntryId',
  );
  @override
  late final GeneratedColumn<int> journalEntryId = GeneratedColumn<int>(
    'journal_entry_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    loadId,
    date,
    firearm,
    distanceYd,
    shots,
    groupSizeIn,
    chronoAvgFps,
    chronoSdFps,
    chronoEsFps,
    weather,
    journalEntryId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'range_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<RangeSession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('load_id')) {
      context.handle(
        _loadIdMeta,
        loadId.isAcceptableOrUnknown(data['load_id']!, _loadIdMeta),
      );
    } else if (isInserting) {
      context.missing(_loadIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('firearm')) {
      context.handle(
        _firearmMeta,
        firearm.isAcceptableOrUnknown(data['firearm']!, _firearmMeta),
      );
    }
    if (data.containsKey('distance_yd')) {
      context.handle(
        _distanceYdMeta,
        distanceYd.isAcceptableOrUnknown(data['distance_yd']!, _distanceYdMeta),
      );
    } else if (isInserting) {
      context.missing(_distanceYdMeta);
    }
    if (data.containsKey('shots')) {
      context.handle(
        _shotsMeta,
        shots.isAcceptableOrUnknown(data['shots']!, _shotsMeta),
      );
    } else if (isInserting) {
      context.missing(_shotsMeta);
    }
    if (data.containsKey('group_size_in')) {
      context.handle(
        _groupSizeInMeta,
        groupSizeIn.isAcceptableOrUnknown(
          data['group_size_in']!,
          _groupSizeInMeta,
        ),
      );
    }
    if (data.containsKey('chrono_avg_fps')) {
      context.handle(
        _chronoAvgFpsMeta,
        chronoAvgFps.isAcceptableOrUnknown(
          data['chrono_avg_fps']!,
          _chronoAvgFpsMeta,
        ),
      );
    }
    if (data.containsKey('chrono_sd_fps')) {
      context.handle(
        _chronoSdFpsMeta,
        chronoSdFps.isAcceptableOrUnknown(
          data['chrono_sd_fps']!,
          _chronoSdFpsMeta,
        ),
      );
    }
    if (data.containsKey('chrono_es_fps')) {
      context.handle(
        _chronoEsFpsMeta,
        chronoEsFps.isAcceptableOrUnknown(
          data['chrono_es_fps']!,
          _chronoEsFpsMeta,
        ),
      );
    }
    if (data.containsKey('weather')) {
      context.handle(
        _weatherMeta,
        weather.isAcceptableOrUnknown(data['weather']!, _weatherMeta),
      );
    }
    if (data.containsKey('journal_entry_id')) {
      context.handle(
        _journalEntryIdMeta,
        journalEntryId.isAcceptableOrUnknown(
          data['journal_entry_id']!,
          _journalEntryIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RangeSession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RangeSession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      loadId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}load_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      firearm: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}firearm'],
      ),
      distanceYd: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distance_yd'],
      )!,
      shots: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shots'],
      )!,
      groupSizeIn: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}group_size_in'],
      ),
      chronoAvgFps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chrono_avg_fps'],
      ),
      chronoSdFps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chrono_sd_fps'],
      ),
      chronoEsFps: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}chrono_es_fps'],
      ),
      weather: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}weather'],
      ),
      journalEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}journal_entry_id'],
      ),
    );
  }

  @override
  $RangeSessionsTable createAlias(String alias) {
    return $RangeSessionsTable(attachedDatabase, alias);
  }
}

class RangeSession extends DataClass implements Insertable<RangeSession> {
  final int id;
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
  final int? journalEntryId;
  const RangeSession({
    required this.id,
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
    this.journalEntryId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['load_id'] = Variable<int>(loadId);
    map['date'] = Variable<DateTime>(date);
    if (!nullToAbsent || firearm != null) {
      map['firearm'] = Variable<String>(firearm);
    }
    map['distance_yd'] = Variable<int>(distanceYd);
    map['shots'] = Variable<int>(shots);
    if (!nullToAbsent || groupSizeIn != null) {
      map['group_size_in'] = Variable<double>(groupSizeIn);
    }
    if (!nullToAbsent || chronoAvgFps != null) {
      map['chrono_avg_fps'] = Variable<double>(chronoAvgFps);
    }
    if (!nullToAbsent || chronoSdFps != null) {
      map['chrono_sd_fps'] = Variable<double>(chronoSdFps);
    }
    if (!nullToAbsent || chronoEsFps != null) {
      map['chrono_es_fps'] = Variable<double>(chronoEsFps);
    }
    if (!nullToAbsent || weather != null) {
      map['weather'] = Variable<String>(weather);
    }
    if (!nullToAbsent || journalEntryId != null) {
      map['journal_entry_id'] = Variable<int>(journalEntryId);
    }
    return map;
  }

  RangeSessionsCompanion toCompanion(bool nullToAbsent) {
    return RangeSessionsCompanion(
      id: Value(id),
      loadId: Value(loadId),
      date: Value(date),
      firearm: firearm == null && nullToAbsent
          ? const Value.absent()
          : Value(firearm),
      distanceYd: Value(distanceYd),
      shots: Value(shots),
      groupSizeIn: groupSizeIn == null && nullToAbsent
          ? const Value.absent()
          : Value(groupSizeIn),
      chronoAvgFps: chronoAvgFps == null && nullToAbsent
          ? const Value.absent()
          : Value(chronoAvgFps),
      chronoSdFps: chronoSdFps == null && nullToAbsent
          ? const Value.absent()
          : Value(chronoSdFps),
      chronoEsFps: chronoEsFps == null && nullToAbsent
          ? const Value.absent()
          : Value(chronoEsFps),
      weather: weather == null && nullToAbsent
          ? const Value.absent()
          : Value(weather),
      journalEntryId: journalEntryId == null && nullToAbsent
          ? const Value.absent()
          : Value(journalEntryId),
    );
  }

  factory RangeSession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RangeSession(
      id: serializer.fromJson<int>(json['id']),
      loadId: serializer.fromJson<int>(json['loadId']),
      date: serializer.fromJson<DateTime>(json['date']),
      firearm: serializer.fromJson<String?>(json['firearm']),
      distanceYd: serializer.fromJson<int>(json['distanceYd']),
      shots: serializer.fromJson<int>(json['shots']),
      groupSizeIn: serializer.fromJson<double?>(json['groupSizeIn']),
      chronoAvgFps: serializer.fromJson<double?>(json['chronoAvgFps']),
      chronoSdFps: serializer.fromJson<double?>(json['chronoSdFps']),
      chronoEsFps: serializer.fromJson<double?>(json['chronoEsFps']),
      weather: serializer.fromJson<String?>(json['weather']),
      journalEntryId: serializer.fromJson<int?>(json['journalEntryId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'loadId': serializer.toJson<int>(loadId),
      'date': serializer.toJson<DateTime>(date),
      'firearm': serializer.toJson<String?>(firearm),
      'distanceYd': serializer.toJson<int>(distanceYd),
      'shots': serializer.toJson<int>(shots),
      'groupSizeIn': serializer.toJson<double?>(groupSizeIn),
      'chronoAvgFps': serializer.toJson<double?>(chronoAvgFps),
      'chronoSdFps': serializer.toJson<double?>(chronoSdFps),
      'chronoEsFps': serializer.toJson<double?>(chronoEsFps),
      'weather': serializer.toJson<String?>(weather),
      'journalEntryId': serializer.toJson<int?>(journalEntryId),
    };
  }

  RangeSession copyWith({
    int? id,
    int? loadId,
    DateTime? date,
    Value<String?> firearm = const Value.absent(),
    int? distanceYd,
    int? shots,
    Value<double?> groupSizeIn = const Value.absent(),
    Value<double?> chronoAvgFps = const Value.absent(),
    Value<double?> chronoSdFps = const Value.absent(),
    Value<double?> chronoEsFps = const Value.absent(),
    Value<String?> weather = const Value.absent(),
    Value<int?> journalEntryId = const Value.absent(),
  }) => RangeSession(
    id: id ?? this.id,
    loadId: loadId ?? this.loadId,
    date: date ?? this.date,
    firearm: firearm.present ? firearm.value : this.firearm,
    distanceYd: distanceYd ?? this.distanceYd,
    shots: shots ?? this.shots,
    groupSizeIn: groupSizeIn.present ? groupSizeIn.value : this.groupSizeIn,
    chronoAvgFps: chronoAvgFps.present ? chronoAvgFps.value : this.chronoAvgFps,
    chronoSdFps: chronoSdFps.present ? chronoSdFps.value : this.chronoSdFps,
    chronoEsFps: chronoEsFps.present ? chronoEsFps.value : this.chronoEsFps,
    weather: weather.present ? weather.value : this.weather,
    journalEntryId: journalEntryId.present
        ? journalEntryId.value
        : this.journalEntryId,
  );
  RangeSession copyWithCompanion(RangeSessionsCompanion data) {
    return RangeSession(
      id: data.id.present ? data.id.value : this.id,
      loadId: data.loadId.present ? data.loadId.value : this.loadId,
      date: data.date.present ? data.date.value : this.date,
      firearm: data.firearm.present ? data.firearm.value : this.firearm,
      distanceYd: data.distanceYd.present
          ? data.distanceYd.value
          : this.distanceYd,
      shots: data.shots.present ? data.shots.value : this.shots,
      groupSizeIn: data.groupSizeIn.present
          ? data.groupSizeIn.value
          : this.groupSizeIn,
      chronoAvgFps: data.chronoAvgFps.present
          ? data.chronoAvgFps.value
          : this.chronoAvgFps,
      chronoSdFps: data.chronoSdFps.present
          ? data.chronoSdFps.value
          : this.chronoSdFps,
      chronoEsFps: data.chronoEsFps.present
          ? data.chronoEsFps.value
          : this.chronoEsFps,
      weather: data.weather.present ? data.weather.value : this.weather,
      journalEntryId: data.journalEntryId.present
          ? data.journalEntryId.value
          : this.journalEntryId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RangeSession(')
          ..write('id: $id, ')
          ..write('loadId: $loadId, ')
          ..write('date: $date, ')
          ..write('firearm: $firearm, ')
          ..write('distanceYd: $distanceYd, ')
          ..write('shots: $shots, ')
          ..write('groupSizeIn: $groupSizeIn, ')
          ..write('chronoAvgFps: $chronoAvgFps, ')
          ..write('chronoSdFps: $chronoSdFps, ')
          ..write('chronoEsFps: $chronoEsFps, ')
          ..write('weather: $weather, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    loadId,
    date,
    firearm,
    distanceYd,
    shots,
    groupSizeIn,
    chronoAvgFps,
    chronoSdFps,
    chronoEsFps,
    weather,
    journalEntryId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RangeSession &&
          other.id == this.id &&
          other.loadId == this.loadId &&
          other.date == this.date &&
          other.firearm == this.firearm &&
          other.distanceYd == this.distanceYd &&
          other.shots == this.shots &&
          other.groupSizeIn == this.groupSizeIn &&
          other.chronoAvgFps == this.chronoAvgFps &&
          other.chronoSdFps == this.chronoSdFps &&
          other.chronoEsFps == this.chronoEsFps &&
          other.weather == this.weather &&
          other.journalEntryId == this.journalEntryId);
}

class RangeSessionsCompanion extends UpdateCompanion<RangeSession> {
  final Value<int> id;
  final Value<int> loadId;
  final Value<DateTime> date;
  final Value<String?> firearm;
  final Value<int> distanceYd;
  final Value<int> shots;
  final Value<double?> groupSizeIn;
  final Value<double?> chronoAvgFps;
  final Value<double?> chronoSdFps;
  final Value<double?> chronoEsFps;
  final Value<String?> weather;
  final Value<int?> journalEntryId;
  const RangeSessionsCompanion({
    this.id = const Value.absent(),
    this.loadId = const Value.absent(),
    this.date = const Value.absent(),
    this.firearm = const Value.absent(),
    this.distanceYd = const Value.absent(),
    this.shots = const Value.absent(),
    this.groupSizeIn = const Value.absent(),
    this.chronoAvgFps = const Value.absent(),
    this.chronoSdFps = const Value.absent(),
    this.chronoEsFps = const Value.absent(),
    this.weather = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  });
  RangeSessionsCompanion.insert({
    this.id = const Value.absent(),
    required int loadId,
    required DateTime date,
    this.firearm = const Value.absent(),
    required int distanceYd,
    required int shots,
    this.groupSizeIn = const Value.absent(),
    this.chronoAvgFps = const Value.absent(),
    this.chronoSdFps = const Value.absent(),
    this.chronoEsFps = const Value.absent(),
    this.weather = const Value.absent(),
    this.journalEntryId = const Value.absent(),
  }) : loadId = Value(loadId),
       date = Value(date),
       distanceYd = Value(distanceYd),
       shots = Value(shots);
  static Insertable<RangeSession> custom({
    Expression<int>? id,
    Expression<int>? loadId,
    Expression<DateTime>? date,
    Expression<String>? firearm,
    Expression<int>? distanceYd,
    Expression<int>? shots,
    Expression<double>? groupSizeIn,
    Expression<double>? chronoAvgFps,
    Expression<double>? chronoSdFps,
    Expression<double>? chronoEsFps,
    Expression<String>? weather,
    Expression<int>? journalEntryId,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (loadId != null) 'load_id': loadId,
      if (date != null) 'date': date,
      if (firearm != null) 'firearm': firearm,
      if (distanceYd != null) 'distance_yd': distanceYd,
      if (shots != null) 'shots': shots,
      if (groupSizeIn != null) 'group_size_in': groupSizeIn,
      if (chronoAvgFps != null) 'chrono_avg_fps': chronoAvgFps,
      if (chronoSdFps != null) 'chrono_sd_fps': chronoSdFps,
      if (chronoEsFps != null) 'chrono_es_fps': chronoEsFps,
      if (weather != null) 'weather': weather,
      if (journalEntryId != null) 'journal_entry_id': journalEntryId,
    });
  }

  RangeSessionsCompanion copyWith({
    Value<int>? id,
    Value<int>? loadId,
    Value<DateTime>? date,
    Value<String?>? firearm,
    Value<int>? distanceYd,
    Value<int>? shots,
    Value<double?>? groupSizeIn,
    Value<double?>? chronoAvgFps,
    Value<double?>? chronoSdFps,
    Value<double?>? chronoEsFps,
    Value<String?>? weather,
    Value<int?>? journalEntryId,
  }) {
    return RangeSessionsCompanion(
      id: id ?? this.id,
      loadId: loadId ?? this.loadId,
      date: date ?? this.date,
      firearm: firearm ?? this.firearm,
      distanceYd: distanceYd ?? this.distanceYd,
      shots: shots ?? this.shots,
      groupSizeIn: groupSizeIn ?? this.groupSizeIn,
      chronoAvgFps: chronoAvgFps ?? this.chronoAvgFps,
      chronoSdFps: chronoSdFps ?? this.chronoSdFps,
      chronoEsFps: chronoEsFps ?? this.chronoEsFps,
      weather: weather ?? this.weather,
      journalEntryId: journalEntryId ?? this.journalEntryId,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (loadId.present) {
      map['load_id'] = Variable<int>(loadId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (firearm.present) {
      map['firearm'] = Variable<String>(firearm.value);
    }
    if (distanceYd.present) {
      map['distance_yd'] = Variable<int>(distanceYd.value);
    }
    if (shots.present) {
      map['shots'] = Variable<int>(shots.value);
    }
    if (groupSizeIn.present) {
      map['group_size_in'] = Variable<double>(groupSizeIn.value);
    }
    if (chronoAvgFps.present) {
      map['chrono_avg_fps'] = Variable<double>(chronoAvgFps.value);
    }
    if (chronoSdFps.present) {
      map['chrono_sd_fps'] = Variable<double>(chronoSdFps.value);
    }
    if (chronoEsFps.present) {
      map['chrono_es_fps'] = Variable<double>(chronoEsFps.value);
    }
    if (weather.present) {
      map['weather'] = Variable<String>(weather.value);
    }
    if (journalEntryId.present) {
      map['journal_entry_id'] = Variable<int>(journalEntryId.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RangeSessionsCompanion(')
          ..write('id: $id, ')
          ..write('loadId: $loadId, ')
          ..write('date: $date, ')
          ..write('firearm: $firearm, ')
          ..write('distanceYd: $distanceYd, ')
          ..write('shots: $shots, ')
          ..write('groupSizeIn: $groupSizeIn, ')
          ..write('chronoAvgFps: $chronoAvgFps, ')
          ..write('chronoSdFps: $chronoSdFps, ')
          ..write('chronoEsFps: $chronoEsFps, ')
          ..write('weather: $weather, ')
          ..write('journalEntryId: $journalEntryId')
          ..write(')'))
        .toString();
  }
}

class $InventoryTable extends Inventory
    with TableInfo<$InventoryTable, InventoryData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _componentIdMeta = const VerificationMeta(
    'componentId',
  );
  @override
  late final GeneratedColumn<int> componentId = GeneratedColumn<int>(
    'component_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES components (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _qtyOnHandMeta = const VerificationMeta(
    'qtyOnHand',
  );
  @override
  late final GeneratedColumn<double> qtyOnHand = GeneratedColumn<double>(
    'qty_on_hand',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _costPaidCentsMeta = const VerificationMeta(
    'costPaidCents',
  );
  @override
  late final GeneratedColumn<int> costPaidCents = GeneratedColumn<int>(
    'cost_paid_cents',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateUpdatedMeta = const VerificationMeta(
    'dateUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> dateUpdated = GeneratedColumn<DateTime>(
    'date_updated',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    componentId,
    qtyOnHand,
    unit,
    costPaidCents,
    dateUpdated,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('component_id')) {
      context.handle(
        _componentIdMeta,
        componentId.isAcceptableOrUnknown(
          data['component_id']!,
          _componentIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_componentIdMeta);
    }
    if (data.containsKey('qty_on_hand')) {
      context.handle(
        _qtyOnHandMeta,
        qtyOnHand.isAcceptableOrUnknown(data['qty_on_hand']!, _qtyOnHandMeta),
      );
    } else if (isInserting) {
      context.missing(_qtyOnHandMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('cost_paid_cents')) {
      context.handle(
        _costPaidCentsMeta,
        costPaidCents.isAcceptableOrUnknown(
          data['cost_paid_cents']!,
          _costPaidCentsMeta,
        ),
      );
    }
    if (data.containsKey('date_updated')) {
      context.handle(
        _dateUpdatedMeta,
        dateUpdated.isAcceptableOrUnknown(
          data['date_updated']!,
          _dateUpdatedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateUpdatedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      componentId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}component_id'],
      )!,
      qtyOnHand: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}qty_on_hand'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      costPaidCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cost_paid_cents'],
      ),
      dateUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date_updated'],
      )!,
    );
  }

  @override
  $InventoryTable createAlias(String alias) {
    return $InventoryTable(attachedDatabase, alias);
  }
}

class InventoryData extends DataClass implements Insertable<InventoryData> {
  final int id;
  final int componentId;
  final double qtyOnHand;
  final String unit;
  final int? costPaidCents;
  final DateTime dateUpdated;
  const InventoryData({
    required this.id,
    required this.componentId,
    required this.qtyOnHand,
    required this.unit,
    this.costPaidCents,
    required this.dateUpdated,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['component_id'] = Variable<int>(componentId);
    map['qty_on_hand'] = Variable<double>(qtyOnHand);
    map['unit'] = Variable<String>(unit);
    if (!nullToAbsent || costPaidCents != null) {
      map['cost_paid_cents'] = Variable<int>(costPaidCents);
    }
    map['date_updated'] = Variable<DateTime>(dateUpdated);
    return map;
  }

  InventoryCompanion toCompanion(bool nullToAbsent) {
    return InventoryCompanion(
      id: Value(id),
      componentId: Value(componentId),
      qtyOnHand: Value(qtyOnHand),
      unit: Value(unit),
      costPaidCents: costPaidCents == null && nullToAbsent
          ? const Value.absent()
          : Value(costPaidCents),
      dateUpdated: Value(dateUpdated),
    );
  }

  factory InventoryData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryData(
      id: serializer.fromJson<int>(json['id']),
      componentId: serializer.fromJson<int>(json['componentId']),
      qtyOnHand: serializer.fromJson<double>(json['qtyOnHand']),
      unit: serializer.fromJson<String>(json['unit']),
      costPaidCents: serializer.fromJson<int?>(json['costPaidCents']),
      dateUpdated: serializer.fromJson<DateTime>(json['dateUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'componentId': serializer.toJson<int>(componentId),
      'qtyOnHand': serializer.toJson<double>(qtyOnHand),
      'unit': serializer.toJson<String>(unit),
      'costPaidCents': serializer.toJson<int?>(costPaidCents),
      'dateUpdated': serializer.toJson<DateTime>(dateUpdated),
    };
  }

  InventoryData copyWith({
    int? id,
    int? componentId,
    double? qtyOnHand,
    String? unit,
    Value<int?> costPaidCents = const Value.absent(),
    DateTime? dateUpdated,
  }) => InventoryData(
    id: id ?? this.id,
    componentId: componentId ?? this.componentId,
    qtyOnHand: qtyOnHand ?? this.qtyOnHand,
    unit: unit ?? this.unit,
    costPaidCents: costPaidCents.present
        ? costPaidCents.value
        : this.costPaidCents,
    dateUpdated: dateUpdated ?? this.dateUpdated,
  );
  InventoryData copyWithCompanion(InventoryCompanion data) {
    return InventoryData(
      id: data.id.present ? data.id.value : this.id,
      componentId: data.componentId.present
          ? data.componentId.value
          : this.componentId,
      qtyOnHand: data.qtyOnHand.present ? data.qtyOnHand.value : this.qtyOnHand,
      unit: data.unit.present ? data.unit.value : this.unit,
      costPaidCents: data.costPaidCents.present
          ? data.costPaidCents.value
          : this.costPaidCents,
      dateUpdated: data.dateUpdated.present
          ? data.dateUpdated.value
          : this.dateUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryData(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('qtyOnHand: $qtyOnHand, ')
          ..write('unit: $unit, ')
          ..write('costPaidCents: $costPaidCents, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, componentId, qtyOnHand, unit, costPaidCents, dateUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryData &&
          other.id == this.id &&
          other.componentId == this.componentId &&
          other.qtyOnHand == this.qtyOnHand &&
          other.unit == this.unit &&
          other.costPaidCents == this.costPaidCents &&
          other.dateUpdated == this.dateUpdated);
}

class InventoryCompanion extends UpdateCompanion<InventoryData> {
  final Value<int> id;
  final Value<int> componentId;
  final Value<double> qtyOnHand;
  final Value<String> unit;
  final Value<int?> costPaidCents;
  final Value<DateTime> dateUpdated;
  const InventoryCompanion({
    this.id = const Value.absent(),
    this.componentId = const Value.absent(),
    this.qtyOnHand = const Value.absent(),
    this.unit = const Value.absent(),
    this.costPaidCents = const Value.absent(),
    this.dateUpdated = const Value.absent(),
  });
  InventoryCompanion.insert({
    this.id = const Value.absent(),
    required int componentId,
    required double qtyOnHand,
    required String unit,
    this.costPaidCents = const Value.absent(),
    required DateTime dateUpdated,
  }) : componentId = Value(componentId),
       qtyOnHand = Value(qtyOnHand),
       unit = Value(unit),
       dateUpdated = Value(dateUpdated);
  static Insertable<InventoryData> custom({
    Expression<int>? id,
    Expression<int>? componentId,
    Expression<double>? qtyOnHand,
    Expression<String>? unit,
    Expression<int>? costPaidCents,
    Expression<DateTime>? dateUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (componentId != null) 'component_id': componentId,
      if (qtyOnHand != null) 'qty_on_hand': qtyOnHand,
      if (unit != null) 'unit': unit,
      if (costPaidCents != null) 'cost_paid_cents': costPaidCents,
      if (dateUpdated != null) 'date_updated': dateUpdated,
    });
  }

  InventoryCompanion copyWith({
    Value<int>? id,
    Value<int>? componentId,
    Value<double>? qtyOnHand,
    Value<String>? unit,
    Value<int?>? costPaidCents,
    Value<DateTime>? dateUpdated,
  }) {
    return InventoryCompanion(
      id: id ?? this.id,
      componentId: componentId ?? this.componentId,
      qtyOnHand: qtyOnHand ?? this.qtyOnHand,
      unit: unit ?? this.unit,
      costPaidCents: costPaidCents ?? this.costPaidCents,
      dateUpdated: dateUpdated ?? this.dateUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (componentId.present) {
      map['component_id'] = Variable<int>(componentId.value);
    }
    if (qtyOnHand.present) {
      map['qty_on_hand'] = Variable<double>(qtyOnHand.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (costPaidCents.present) {
      map['cost_paid_cents'] = Variable<int>(costPaidCents.value);
    }
    if (dateUpdated.present) {
      map['date_updated'] = Variable<DateTime>(dateUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryCompanion(')
          ..write('id: $id, ')
          ..write('componentId: $componentId, ')
          ..write('qtyOnHand: $qtyOnHand, ')
          ..write('unit: $unit, ')
          ..write('costPaidCents: $costPaidCents, ')
          ..write('dateUpdated: $dateUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AppJournalEntriesTable appJournalEntries =
      $AppJournalEntriesTable(this);
  late final $AppJournalPhotosTable appJournalPhotos = $AppJournalPhotosTable(
    this,
  );
  late final $AppJournalTagsTable appJournalTags = $AppJournalTagsTable(this);
  late final $CartridgesTable cartridges = $CartridgesTable(this);
  late final $ComponentsTable components = $ComponentsTable(this);
  late final $LoadsTable loads = $LoadsTable(this);
  late final $RangeSessionsTable rangeSessions = $RangeSessionsTable(this);
  late final $InventoryTable inventory = $InventoryTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    appJournalEntries,
    appJournalPhotos,
    appJournalTags,
    cartridges,
    components,
    loads,
    rangeSessions,
    inventory,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'cartridges',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('loads', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'loads',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('range_sessions', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'components',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('inventory', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$AppJournalEntriesTableCreateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });
typedef $$AppJournalEntriesTableUpdateCompanionBuilder =
    AppJournalEntriesCompanion Function({
      Value<int> id,
      Value<String?> notes,
      Value<int?> rating,
      Value<DateTime> createdAt,
    });

class $$AppJournalEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalEntriesTable> {
  $$AppJournalEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AppJournalEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalEntriesTable,
          JournalEntry,
          $$AppJournalEntriesTableFilterComposer,
          $$AppJournalEntriesTableOrderingComposer,
          $$AppJournalEntriesTableAnnotationComposer,
          $$AppJournalEntriesTableCreateCompanionBuilder,
          $$AppJournalEntriesTableUpdateCompanionBuilder,
          (
            JournalEntry,
            BaseReferences<
              _$AppDatabase,
              $AppJournalEntriesTable,
              JournalEntry
            >,
          ),
          JournalEntry,
          PrefetchHooks Function()
        > {
  $$AppJournalEntriesTableTableManager(
    _$AppDatabase db,
    $AppJournalEntriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalEntriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int?> rating = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => AppJournalEntriesCompanion.insert(
                id: id,
                notes: notes,
                rating: rating,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalEntriesTable, JournalEntry>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalEntriesTable,
                    JournalEntry
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalEntriesTable,
      JournalEntry,
      $$AppJournalEntriesTableFilterComposer,
      $$AppJournalEntriesTableOrderingComposer,
      $$AppJournalEntriesTableAnnotationComposer,
      $$AppJournalEntriesTableCreateCompanionBuilder,
      $$AppJournalEntriesTableUpdateCompanionBuilder,
      (
        JournalEntry,
        BaseReferences<_$AppDatabase, $AppJournalEntriesTable, JournalEntry>,
      ),
      JournalEntry,
      PrefetchHooks Function()
    >;
typedef $$AppJournalPhotosTableCreateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      required int entryId,
      required String path,
      Value<String?> caption,
    });
typedef $$AppJournalPhotosTableUpdateCompanionBuilder =
    AppJournalPhotosCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> path,
      Value<String?> caption,
    });

class $$AppJournalPhotosTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalPhotosTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get caption => $composableBuilder(
    column: $table.caption,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalPhotosTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalPhotosTable> {
  $$AppJournalPhotosTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<String> get caption =>
      $composableBuilder(column: $table.caption, builder: (column) => column);
}

class $$AppJournalPhotosTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalPhotosTable,
          JournalPhoto,
          $$AppJournalPhotosTableFilterComposer,
          $$AppJournalPhotosTableOrderingComposer,
          $$AppJournalPhotosTableAnnotationComposer,
          $$AppJournalPhotosTableCreateCompanionBuilder,
          $$AppJournalPhotosTableUpdateCompanionBuilder,
          (
            JournalPhoto,
            BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
          ),
          JournalPhoto,
          PrefetchHooks Function()
        > {
  $$AppJournalPhotosTableTableManager(
    _$AppDatabase db,
    $AppJournalPhotosTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalPhotosTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalPhotosTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalPhotosTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String path,
                Value<String?> caption = const Value.absent(),
              }) => AppJournalPhotosCompanion.insert(
                id: id,
                entryId: entryId,
                path: path,
                caption: caption,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalPhotosTable, JournalPhoto>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalPhotosTable,
                    JournalPhoto
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalPhotosTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalPhotosTable,
      JournalPhoto,
      $$AppJournalPhotosTableFilterComposer,
      $$AppJournalPhotosTableOrderingComposer,
      $$AppJournalPhotosTableAnnotationComposer,
      $$AppJournalPhotosTableCreateCompanionBuilder,
      $$AppJournalPhotosTableUpdateCompanionBuilder,
      (
        JournalPhoto,
        BaseReferences<_$AppDatabase, $AppJournalPhotosTable, JournalPhoto>,
      ),
      JournalPhoto,
      PrefetchHooks Function()
    >;
typedef $$AppJournalTagsTableCreateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      required int entryId,
      required String tag,
    });
typedef $$AppJournalTagsTableUpdateCompanionBuilder =
    AppJournalTagsCompanion Function({
      Value<int> id,
      Value<int> entryId,
      Value<String> tag,
    });

class $$AppJournalTagsTableFilterComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppJournalTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get entryId => $composableBuilder(
    column: $table.entryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tag => $composableBuilder(
    column: $table.tag,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppJournalTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppJournalTagsTable> {
  $$AppJournalTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get entryId =>
      $composableBuilder(column: $table.entryId, builder: (column) => column);

  GeneratedColumn<String> get tag =>
      $composableBuilder(column: $table.tag, builder: (column) => column);
}

class $$AppJournalTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppJournalTagsTable,
          JournalTag,
          $$AppJournalTagsTableFilterComposer,
          $$AppJournalTagsTableOrderingComposer,
          $$AppJournalTagsTableAnnotationComposer,
          $$AppJournalTagsTableCreateCompanionBuilder,
          $$AppJournalTagsTableUpdateCompanionBuilder,
          (
            JournalTag,
            BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
          ),
          JournalTag,
          PrefetchHooks Function()
        > {
  $$AppJournalTagsTableTableManager(
    _$AppDatabase db,
    $AppJournalTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppJournalTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppJournalTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppJournalTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> entryId = const Value.absent(),
                Value<String> tag = const Value.absent(),
              }) => AppJournalTagsCompanion(id: id, entryId: entryId, tag: tag),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int entryId,
                required String tag,
              }) => AppJournalTagsCompanion.insert(
                id: id,
                entryId: entryId,
                tag: tag,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$AppJournalTagsTable, JournalTag>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $AppJournalTagsTable,
                    JournalTag
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppJournalTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppJournalTagsTable,
      JournalTag,
      $$AppJournalTagsTableFilterComposer,
      $$AppJournalTagsTableOrderingComposer,
      $$AppJournalTagsTableAnnotationComposer,
      $$AppJournalTagsTableCreateCompanionBuilder,
      $$AppJournalTagsTableUpdateCompanionBuilder,
      (
        JournalTag,
        BaseReferences<_$AppDatabase, $AppJournalTagsTable, JournalTag>,
      ),
      JournalTag,
      PrefetchHooks Function()
    >;
typedef $$CartridgesTableCreateCompanionBuilder =
    CartridgesCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });
typedef $$CartridgesTableUpdateCompanionBuilder =
    CartridgesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> notes,
      Value<DateTime> createdAt,
    });

final class $$CartridgesTableReferences
    extends BaseReferences<_$AppDatabase, $CartridgesTable, Cartridge> {
  $$CartridgesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$LoadsTable, List<Load>> _loadsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.loads,
    aliasName: 'cartridges__id__loads__cartridge_id',
  );

  $$LoadsTableProcessedTableManager get loadsRefs {
    final manager = $$LoadsTableTableManager(
      $_db,
      $_db.loads,
    ).filter((f) => f.cartridgeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_loadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CartridgesTableFilterComposer
    extends Composer<_$AppDatabase, $CartridgesTable> {
  $$CartridgesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> loadsRefs(
    Expression<bool> Function($$LoadsTableFilterComposer f) f,
  ) {
    final $$LoadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loads,
      getReferencedColumn: (t) => t.cartridgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoadsTableFilterComposer(
            $db: $db,
            $table: $db.loads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartridgesTableOrderingComposer
    extends Composer<_$AppDatabase, $CartridgesTable> {
  $$CartridgesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CartridgesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CartridgesTable> {
  $$CartridgesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> loadsRefs<T extends Object>(
    Expression<T> Function($$LoadsTableAnnotationComposer a) f,
  ) {
    final $$LoadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.loads,
      getReferencedColumn: (t) => t.cartridgeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoadsTableAnnotationComposer(
            $db: $db,
            $table: $db.loads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CartridgesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CartridgesTable,
          Cartridge,
          $$CartridgesTableFilterComposer,
          $$CartridgesTableOrderingComposer,
          $$CartridgesTableAnnotationComposer,
          $$CartridgesTableCreateCompanionBuilder,
          $$CartridgesTableUpdateCompanionBuilder,
          (Cartridge, $$CartridgesTableReferences),
          Cartridge,
          PrefetchHooks Function({bool loadsRefs})
        > {
  $$CartridgesTableTableManager(_$AppDatabase db, $CartridgesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CartridgesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CartridgesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CartridgesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CartridgesCompanion(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> notes = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => CartridgesCompanion.insert(
                id: id,
                name: name,
                notes: notes,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$CartridgesTable, Cartridge>(table),
                  $$CartridgesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loadsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (loadsRefs) db.loads],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (loadsRefs)
                    await $_getPrefetchedData<
                      Cartridge,
                      $CartridgesTable,
                      Load
                    >(
                      currentTable: table,
                      referencedTable: $$CartridgesTableReferences
                          ._loadsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CartridgesTableReferences(db, table, p0).loadsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.cartridgeId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CartridgesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CartridgesTable,
      Cartridge,
      $$CartridgesTableFilterComposer,
      $$CartridgesTableOrderingComposer,
      $$CartridgesTableAnnotationComposer,
      $$CartridgesTableCreateCompanionBuilder,
      $$CartridgesTableUpdateCompanionBuilder,
      (Cartridge, $$CartridgesTableReferences),
      Cartridge,
      PrefetchHooks Function({bool loadsRefs})
    >;
typedef $$ComponentsTableCreateCompanionBuilder =
    ComponentsCompanion Function({
      Value<int> id,
      required ComponentKind kind,
      required String maker,
      required String name,
      Value<String?> lot,
      Value<double?> weightGr,
      Value<String?> bulletType,
      Value<String?> notes,
    });
typedef $$ComponentsTableUpdateCompanionBuilder =
    ComponentsCompanion Function({
      Value<int> id,
      Value<ComponentKind> kind,
      Value<String> maker,
      Value<String> name,
      Value<String?> lot,
      Value<double?> weightGr,
      Value<String?> bulletType,
      Value<String?> notes,
    });

final class $$ComponentsTableReferences
    extends BaseReferences<_$AppDatabase, $ComponentsTable, Component> {
  $$ComponentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$InventoryTable, List<InventoryData>>
  _inventoryRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.inventory,
    aliasName: 'components__id__inventory__component_id',
  );

  $$InventoryTableProcessedTableManager get inventoryRefs {
    final manager = $$InventoryTableTableManager(
      $_db,
      $_db.inventory,
    ).filter((f) => f.componentId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_inventoryRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ComponentsTableFilterComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ComponentKind, ComponentKind, String>
  get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get maker => $composableBuilder(
    column: $table.maker,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightGr => $composableBuilder(
    column: $table.weightGr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> inventoryRefs(
    Expression<bool> Function($$InventoryTableFilterComposer f) f,
  ) {
    final $$InventoryTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventory,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableFilterComposer(
            $db: $db,
            $table: $db.inventory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComponentsTableOrderingComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get kind => $composableBuilder(
    column: $table.kind,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get maker => $composableBuilder(
    column: $table.maker,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lot => $composableBuilder(
    column: $table.lot,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightGr => $composableBuilder(
    column: $table.weightGr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ComponentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ComponentsTable> {
  $$ComponentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ComponentKind, String> get kind =>
      $composableBuilder(column: $table.kind, builder: (column) => column);

  GeneratedColumn<String> get maker =>
      $composableBuilder(column: $table.maker, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get lot =>
      $composableBuilder(column: $table.lot, builder: (column) => column);

  GeneratedColumn<double> get weightGr =>
      $composableBuilder(column: $table.weightGr, builder: (column) => column);

  GeneratedColumn<String> get bulletType => $composableBuilder(
    column: $table.bulletType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> inventoryRefs<T extends Object>(
    Expression<T> Function($$InventoryTableAnnotationComposer a) f,
  ) {
    final $$InventoryTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.inventory,
      getReferencedColumn: (t) => t.componentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InventoryTableAnnotationComposer(
            $db: $db,
            $table: $db.inventory,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ComponentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ComponentsTable,
          Component,
          $$ComponentsTableFilterComposer,
          $$ComponentsTableOrderingComposer,
          $$ComponentsTableAnnotationComposer,
          $$ComponentsTableCreateCompanionBuilder,
          $$ComponentsTableUpdateCompanionBuilder,
          (Component, $$ComponentsTableReferences),
          Component,
          PrefetchHooks Function({bool inventoryRefs})
        > {
  $$ComponentsTableTableManager(_$AppDatabase db, $ComponentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ComponentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ComponentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ComponentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ComponentKind> kind = const Value.absent(),
                Value<String> maker = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> lot = const Value.absent(),
                Value<double?> weightGr = const Value.absent(),
                Value<String?> bulletType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ComponentsCompanion(
                id: id,
                kind: kind,
                maker: maker,
                name: name,
                lot: lot,
                weightGr: weightGr,
                bulletType: bulletType,
                notes: notes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required ComponentKind kind,
                required String maker,
                required String name,
                Value<String?> lot = const Value.absent(),
                Value<double?> weightGr = const Value.absent(),
                Value<String?> bulletType = const Value.absent(),
                Value<String?> notes = const Value.absent(),
              }) => ComponentsCompanion.insert(
                id: id,
                kind: kind,
                maker: maker,
                name: name,
                lot: lot,
                weightGr: weightGr,
                bulletType: bulletType,
                notes: notes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$ComponentsTable, Component>(table),
                  $$ComponentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({inventoryRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (inventoryRefs) db.inventory],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (inventoryRefs)
                    await $_getPrefetchedData<
                      Component,
                      $ComponentsTable,
                      InventoryData
                    >(
                      currentTable: table,
                      referencedTable: $$ComponentsTableReferences
                          ._inventoryRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$ComponentsTableReferences(
                            db,
                            table,
                            p0,
                          ).inventoryRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.componentId == item.id,
                          ),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$ComponentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ComponentsTable,
      Component,
      $$ComponentsTableFilterComposer,
      $$ComponentsTableOrderingComposer,
      $$ComponentsTableAnnotationComposer,
      $$ComponentsTableCreateCompanionBuilder,
      $$ComponentsTableUpdateCompanionBuilder,
      (Component, $$ComponentsTableReferences),
      Component,
      PrefetchHooks Function({bool inventoryRefs})
    >;
typedef $$LoadsTableCreateCompanionBuilder =
    LoadsCompanion Function({
      Value<int> id,
      required int cartridgeId,
      required int bulletId,
      required int powderId,
      required double chargeGr,
      required int primerId,
      Value<int?> brassId,
      Value<double?> coalIn,
      Value<String?> crimp,
      required DateTime dateDeveloped,
      Value<LoadStatus> status,
      Value<DateTime> createdAt,
      Value<int?> journalEntryId,
    });
typedef $$LoadsTableUpdateCompanionBuilder =
    LoadsCompanion Function({
      Value<int> id,
      Value<int> cartridgeId,
      Value<int> bulletId,
      Value<int> powderId,
      Value<double> chargeGr,
      Value<int> primerId,
      Value<int?> brassId,
      Value<double?> coalIn,
      Value<String?> crimp,
      Value<DateTime> dateDeveloped,
      Value<LoadStatus> status,
      Value<DateTime> createdAt,
      Value<int?> journalEntryId,
    });

final class $$LoadsTableReferences
    extends BaseReferences<_$AppDatabase, $LoadsTable, Load> {
  $$LoadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CartridgesTable _cartridgeIdTable(_$AppDatabase db) =>
      db.cartridges.createAlias('loads__cartridge_id__cartridges__id');

  $$CartridgesTableProcessedTableManager get cartridgeId {
    final $_column = $_itemColumn<int>('cartridge_id')!;

    final manager = $$CartridgesTableTableManager(
      $_db,
      $_db.cartridges,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_cartridgeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _bulletIdTable(_$AppDatabase db) =>
      db.components.createAlias('loads__bullet_id__components__id');

  $$ComponentsTableProcessedTableManager get bulletId {
    final $_column = $_itemColumn<int>('bullet_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_bulletIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _powderIdTable(_$AppDatabase db) =>
      db.components.createAlias('loads__powder_id__components__id');

  $$ComponentsTableProcessedTableManager get powderId {
    final $_column = $_itemColumn<int>('powder_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_powderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _primerIdTable(_$AppDatabase db) =>
      db.components.createAlias('loads__primer_id__components__id');

  $$ComponentsTableProcessedTableManager get primerId {
    final $_column = $_itemColumn<int>('primer_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_primerIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ComponentsTable _brassIdTable(_$AppDatabase db) =>
      db.components.createAlias('loads__brass_id__components__id');

  $$ComponentsTableProcessedTableManager? get brassId {
    final $_column = $_itemColumn<int>('brass_id');
    if ($_column == null) return null;
    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_brassIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$RangeSessionsTable, List<RangeSession>>
  _rangeSessionsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.rangeSessions,
    aliasName: 'loads__id__range_sessions__load_id',
  );

  $$RangeSessionsTableProcessedTableManager get rangeSessionsRefs {
    final manager = $$RangeSessionsTableTableManager(
      $_db,
      $_db.rangeSessions,
    ).filter((f) => f.loadId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_rangeSessionsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$LoadsTableFilterComposer extends Composer<_$AppDatabase, $LoadsTable> {
  $$LoadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chargeGr => $composableBuilder(
    column: $table.chargeGr,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get coalIn => $composableBuilder(
    column: $table.coalIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get crimp => $composableBuilder(
    column: $table.crimp,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateDeveloped => $composableBuilder(
    column: $table.dateDeveloped,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<LoadStatus, LoadStatus, String> get status =>
      $composableBuilder(
        column: $table.status,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );

  $$CartridgesTableFilterComposer get cartridgeId {
    final $$CartridgesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartridgeId,
      referencedTable: $db.cartridges,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartridgesTableFilterComposer(
            $db: $db,
            $table: $db.cartridges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get bulletId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulletId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get powderId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powderId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get primerId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primerId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableFilterComposer get brassId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brassId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> rangeSessionsRefs(
    Expression<bool> Function($$RangeSessionsTableFilterComposer f) f,
  ) {
    final $$RangeSessionsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rangeSessions,
      getReferencedColumn: (t) => t.loadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RangeSessionsTableFilterComposer(
            $db: $db,
            $table: $db.rangeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoadsTableOrderingComposer
    extends Composer<_$AppDatabase, $LoadsTable> {
  $$LoadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chargeGr => $composableBuilder(
    column: $table.chargeGr,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get coalIn => $composableBuilder(
    column: $table.coalIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get crimp => $composableBuilder(
    column: $table.crimp,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateDeveloped => $composableBuilder(
    column: $table.dateDeveloped,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CartridgesTableOrderingComposer get cartridgeId {
    final $$CartridgesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartridgeId,
      referencedTable: $db.cartridges,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartridgesTableOrderingComposer(
            $db: $db,
            $table: $db.cartridges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get bulletId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulletId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get powderId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powderId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get primerId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primerId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableOrderingComposer get brassId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brassId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$LoadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LoadsTable> {
  $$LoadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get chargeGr =>
      $composableBuilder(column: $table.chargeGr, builder: (column) => column);

  GeneratedColumn<double> get coalIn =>
      $composableBuilder(column: $table.coalIn, builder: (column) => column);

  GeneratedColumn<String> get crimp =>
      $composableBuilder(column: $table.crimp, builder: (column) => column);

  GeneratedColumn<DateTime> get dateDeveloped => $composableBuilder(
    column: $table.dateDeveloped,
    builder: (column) => column,
  );

  GeneratedColumnWithTypeConverter<LoadStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );

  $$CartridgesTableAnnotationComposer get cartridgeId {
    final $$CartridgesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.cartridgeId,
      referencedTable: $db.cartridges,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CartridgesTableAnnotationComposer(
            $db: $db,
            $table: $db.cartridges,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get bulletId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.bulletId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get powderId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.powderId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get primerId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.primerId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ComponentsTableAnnotationComposer get brassId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.brassId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> rangeSessionsRefs<T extends Object>(
    Expression<T> Function($$RangeSessionsTableAnnotationComposer a) f,
  ) {
    final $$RangeSessionsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.rangeSessions,
      getReferencedColumn: (t) => t.loadId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RangeSessionsTableAnnotationComposer(
            $db: $db,
            $table: $db.rangeSessions,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$LoadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LoadsTable,
          Load,
          $$LoadsTableFilterComposer,
          $$LoadsTableOrderingComposer,
          $$LoadsTableAnnotationComposer,
          $$LoadsTableCreateCompanionBuilder,
          $$LoadsTableUpdateCompanionBuilder,
          (Load, $$LoadsTableReferences),
          Load,
          PrefetchHooks Function({
            bool cartridgeId,
            bool bulletId,
            bool powderId,
            bool primerId,
            bool brassId,
            bool rangeSessionsRefs,
          })
        > {
  $$LoadsTableTableManager(_$AppDatabase db, $LoadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LoadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LoadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LoadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> cartridgeId = const Value.absent(),
                Value<int> bulletId = const Value.absent(),
                Value<int> powderId = const Value.absent(),
                Value<double> chargeGr = const Value.absent(),
                Value<int> primerId = const Value.absent(),
                Value<int?> brassId = const Value.absent(),
                Value<double?> coalIn = const Value.absent(),
                Value<String?> crimp = const Value.absent(),
                Value<DateTime> dateDeveloped = const Value.absent(),
                Value<LoadStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => LoadsCompanion(
                id: id,
                cartridgeId: cartridgeId,
                bulletId: bulletId,
                powderId: powderId,
                chargeGr: chargeGr,
                primerId: primerId,
                brassId: brassId,
                coalIn: coalIn,
                crimp: crimp,
                dateDeveloped: dateDeveloped,
                status: status,
                createdAt: createdAt,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int cartridgeId,
                required int bulletId,
                required int powderId,
                required double chargeGr,
                required int primerId,
                Value<int?> brassId = const Value.absent(),
                Value<double?> coalIn = const Value.absent(),
                Value<String?> crimp = const Value.absent(),
                required DateTime dateDeveloped,
                Value<LoadStatus> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => LoadsCompanion.insert(
                id: id,
                cartridgeId: cartridgeId,
                bulletId: bulletId,
                powderId: powderId,
                chargeGr: chargeGr,
                primerId: primerId,
                brassId: brassId,
                coalIn: coalIn,
                crimp: crimp,
                dateDeveloped: dateDeveloped,
                status: status,
                createdAt: createdAt,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$LoadsTable, Load>(table),
                  $$LoadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                cartridgeId = false,
                bulletId = false,
                powderId = false,
                primerId = false,
                brassId = false,
                rangeSessionsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (rangeSessionsRefs) db.rangeSessions,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (cartridgeId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.cartridgeId,
                                    referencedTable: $$LoadsTableReferences
                                        ._cartridgeIdTable(db),
                                    referencedColumn: $$LoadsTableReferences
                                        ._cartridgeIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (bulletId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.bulletId,
                                    referencedTable: $$LoadsTableReferences
                                        ._bulletIdTable(db),
                                    referencedColumn: $$LoadsTableReferences
                                        ._bulletIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (powderId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.powderId,
                                    referencedTable: $$LoadsTableReferences
                                        ._powderIdTable(db),
                                    referencedColumn: $$LoadsTableReferences
                                        ._powderIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (primerId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.primerId,
                                    referencedTable: $$LoadsTableReferences
                                        ._primerIdTable(db),
                                    referencedColumn: $$LoadsTableReferences
                                        ._primerIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (brassId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.brassId,
                                    referencedTable: $$LoadsTableReferences
                                        ._brassIdTable(db),
                                    referencedColumn: $$LoadsTableReferences
                                        ._brassIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (rangeSessionsRefs)
                        await $_getPrefetchedData<
                          Load,
                          $LoadsTable,
                          RangeSession
                        >(
                          currentTable: table,
                          referencedTable: $$LoadsTableReferences
                              ._rangeSessionsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$LoadsTableReferences(
                                db,
                                table,
                                p0,
                              ).rangeSessionsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.loadId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$LoadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LoadsTable,
      Load,
      $$LoadsTableFilterComposer,
      $$LoadsTableOrderingComposer,
      $$LoadsTableAnnotationComposer,
      $$LoadsTableCreateCompanionBuilder,
      $$LoadsTableUpdateCompanionBuilder,
      (Load, $$LoadsTableReferences),
      Load,
      PrefetchHooks Function({
        bool cartridgeId,
        bool bulletId,
        bool powderId,
        bool primerId,
        bool brassId,
        bool rangeSessionsRefs,
      })
    >;
typedef $$RangeSessionsTableCreateCompanionBuilder =
    RangeSessionsCompanion Function({
      Value<int> id,
      required int loadId,
      required DateTime date,
      Value<String?> firearm,
      required int distanceYd,
      required int shots,
      Value<double?> groupSizeIn,
      Value<double?> chronoAvgFps,
      Value<double?> chronoSdFps,
      Value<double?> chronoEsFps,
      Value<String?> weather,
      Value<int?> journalEntryId,
    });
typedef $$RangeSessionsTableUpdateCompanionBuilder =
    RangeSessionsCompanion Function({
      Value<int> id,
      Value<int> loadId,
      Value<DateTime> date,
      Value<String?> firearm,
      Value<int> distanceYd,
      Value<int> shots,
      Value<double?> groupSizeIn,
      Value<double?> chronoAvgFps,
      Value<double?> chronoSdFps,
      Value<double?> chronoEsFps,
      Value<String?> weather,
      Value<int?> journalEntryId,
    });

final class $$RangeSessionsTableReferences
    extends BaseReferences<_$AppDatabase, $RangeSessionsTable, RangeSession> {
  $$RangeSessionsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $LoadsTable _loadIdTable(_$AppDatabase db) =>
      db.loads.createAlias('range_sessions__load_id__loads__id');

  $$LoadsTableProcessedTableManager get loadId {
    final $_column = $_itemColumn<int>('load_id')!;

    final manager = $$LoadsTableTableManager(
      $_db,
      $_db.loads,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_loadIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RangeSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $RangeSessionsTable> {
  $$RangeSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get firearm => $composableBuilder(
    column: $table.firearm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distanceYd => $composableBuilder(
    column: $table.distanceYd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shots => $composableBuilder(
    column: $table.shots,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get groupSizeIn => $composableBuilder(
    column: $table.groupSizeIn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chronoAvgFps => $composableBuilder(
    column: $table.chronoAvgFps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chronoSdFps => $composableBuilder(
    column: $table.chronoSdFps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get chronoEsFps => $composableBuilder(
    column: $table.chronoEsFps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnFilters(column),
  );

  $$LoadsTableFilterComposer get loadId {
    final $$LoadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loadId,
      referencedTable: $db.loads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoadsTableFilterComposer(
            $db: $db,
            $table: $db.loads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RangeSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $RangeSessionsTable> {
  $$RangeSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get firearm => $composableBuilder(
    column: $table.firearm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distanceYd => $composableBuilder(
    column: $table.distanceYd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shots => $composableBuilder(
    column: $table.shots,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get groupSizeIn => $composableBuilder(
    column: $table.groupSizeIn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chronoAvgFps => $composableBuilder(
    column: $table.chronoAvgFps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chronoSdFps => $composableBuilder(
    column: $table.chronoSdFps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get chronoEsFps => $composableBuilder(
    column: $table.chronoEsFps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get weather => $composableBuilder(
    column: $table.weather,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => ColumnOrderings(column),
  );

  $$LoadsTableOrderingComposer get loadId {
    final $$LoadsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loadId,
      referencedTable: $db.loads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoadsTableOrderingComposer(
            $db: $db,
            $table: $db.loads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RangeSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RangeSessionsTable> {
  $$RangeSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<String> get firearm =>
      $composableBuilder(column: $table.firearm, builder: (column) => column);

  GeneratedColumn<int> get distanceYd => $composableBuilder(
    column: $table.distanceYd,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shots =>
      $composableBuilder(column: $table.shots, builder: (column) => column);

  GeneratedColumn<double> get groupSizeIn => $composableBuilder(
    column: $table.groupSizeIn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chronoAvgFps => $composableBuilder(
    column: $table.chronoAvgFps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chronoSdFps => $composableBuilder(
    column: $table.chronoSdFps,
    builder: (column) => column,
  );

  GeneratedColumn<double> get chronoEsFps => $composableBuilder(
    column: $table.chronoEsFps,
    builder: (column) => column,
  );

  GeneratedColumn<String> get weather =>
      $composableBuilder(column: $table.weather, builder: (column) => column);

  GeneratedColumn<int> get journalEntryId => $composableBuilder(
    column: $table.journalEntryId,
    builder: (column) => column,
  );

  $$LoadsTableAnnotationComposer get loadId {
    final $$LoadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.loadId,
      referencedTable: $db.loads,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$LoadsTableAnnotationComposer(
            $db: $db,
            $table: $db.loads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RangeSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RangeSessionsTable,
          RangeSession,
          $$RangeSessionsTableFilterComposer,
          $$RangeSessionsTableOrderingComposer,
          $$RangeSessionsTableAnnotationComposer,
          $$RangeSessionsTableCreateCompanionBuilder,
          $$RangeSessionsTableUpdateCompanionBuilder,
          (RangeSession, $$RangeSessionsTableReferences),
          RangeSession,
          PrefetchHooks Function({bool loadId})
        > {
  $$RangeSessionsTableTableManager(_$AppDatabase db, $RangeSessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RangeSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RangeSessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RangeSessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> loadId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<String?> firearm = const Value.absent(),
                Value<int> distanceYd = const Value.absent(),
                Value<int> shots = const Value.absent(),
                Value<double?> groupSizeIn = const Value.absent(),
                Value<double?> chronoAvgFps = const Value.absent(),
                Value<double?> chronoSdFps = const Value.absent(),
                Value<double?> chronoEsFps = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => RangeSessionsCompanion(
                id: id,
                loadId: loadId,
                date: date,
                firearm: firearm,
                distanceYd: distanceYd,
                shots: shots,
                groupSizeIn: groupSizeIn,
                chronoAvgFps: chronoAvgFps,
                chronoSdFps: chronoSdFps,
                chronoEsFps: chronoEsFps,
                weather: weather,
                journalEntryId: journalEntryId,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int loadId,
                required DateTime date,
                Value<String?> firearm = const Value.absent(),
                required int distanceYd,
                required int shots,
                Value<double?> groupSizeIn = const Value.absent(),
                Value<double?> chronoAvgFps = const Value.absent(),
                Value<double?> chronoSdFps = const Value.absent(),
                Value<double?> chronoEsFps = const Value.absent(),
                Value<String?> weather = const Value.absent(),
                Value<int?> journalEntryId = const Value.absent(),
              }) => RangeSessionsCompanion.insert(
                id: id,
                loadId: loadId,
                date: date,
                firearm: firearm,
                distanceYd: distanceYd,
                shots: shots,
                groupSizeIn: groupSizeIn,
                chronoAvgFps: chronoAvgFps,
                chronoSdFps: chronoSdFps,
                chronoEsFps: chronoEsFps,
                weather: weather,
                journalEntryId: journalEntryId,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$RangeSessionsTable, RangeSession>(table),
                  $$RangeSessionsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({loadId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (loadId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.loadId,
                                referencedTable: $$RangeSessionsTableReferences
                                    ._loadIdTable(db),
                                referencedColumn: $$RangeSessionsTableReferences
                                    ._loadIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RangeSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RangeSessionsTable,
      RangeSession,
      $$RangeSessionsTableFilterComposer,
      $$RangeSessionsTableOrderingComposer,
      $$RangeSessionsTableAnnotationComposer,
      $$RangeSessionsTableCreateCompanionBuilder,
      $$RangeSessionsTableUpdateCompanionBuilder,
      (RangeSession, $$RangeSessionsTableReferences),
      RangeSession,
      PrefetchHooks Function({bool loadId})
    >;
typedef $$InventoryTableCreateCompanionBuilder =
    InventoryCompanion Function({
      Value<int> id,
      required int componentId,
      required double qtyOnHand,
      required String unit,
      Value<int?> costPaidCents,
      required DateTime dateUpdated,
    });
typedef $$InventoryTableUpdateCompanionBuilder =
    InventoryCompanion Function({
      Value<int> id,
      Value<int> componentId,
      Value<double> qtyOnHand,
      Value<String> unit,
      Value<int?> costPaidCents,
      Value<DateTime> dateUpdated,
    });

final class $$InventoryTableReferences
    extends BaseReferences<_$AppDatabase, $InventoryTable, InventoryData> {
  $$InventoryTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ComponentsTable _componentIdTable(_$AppDatabase db) =>
      db.components.createAlias('inventory__component_id__components__id');

  $$ComponentsTableProcessedTableManager get componentId {
    final $_column = $_itemColumn<int>('component_id')!;

    final manager = $$ComponentsTableTableManager(
      $_db,
      $_db.components,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_componentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$InventoryTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get qtyOnHand => $composableBuilder(
    column: $table.qtyOnHand,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get costPaidCents => $composableBuilder(
    column: $table.costPaidCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => ColumnFilters(column),
  );

  $$ComponentsTableFilterComposer get componentId {
    final $$ComponentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableFilterComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get qtyOnHand => $composableBuilder(
    column: $table.qtyOnHand,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get costPaidCents => $composableBuilder(
    column: $table.costPaidCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  $$ComponentsTableOrderingComposer get componentId {
    final $$ComponentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableOrderingComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryTable> {
  $$InventoryTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get qtyOnHand =>
      $composableBuilder(column: $table.qtyOnHand, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<int> get costPaidCents => $composableBuilder(
    column: $table.costPaidCents,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get dateUpdated => $composableBuilder(
    column: $table.dateUpdated,
    builder: (column) => column,
  );

  $$ComponentsTableAnnotationComposer get componentId {
    final $$ComponentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.componentId,
      referencedTable: $db.components,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ComponentsTableAnnotationComposer(
            $db: $db,
            $table: $db.components,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InventoryTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryTable,
          InventoryData,
          $$InventoryTableFilterComposer,
          $$InventoryTableOrderingComposer,
          $$InventoryTableAnnotationComposer,
          $$InventoryTableCreateCompanionBuilder,
          $$InventoryTableUpdateCompanionBuilder,
          (InventoryData, $$InventoryTableReferences),
          InventoryData,
          PrefetchHooks Function({bool componentId})
        > {
  $$InventoryTableTableManager(_$AppDatabase db, $InventoryTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InventoryTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InventoryTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InventoryTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> componentId = const Value.absent(),
                Value<double> qtyOnHand = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<int?> costPaidCents = const Value.absent(),
                Value<DateTime> dateUpdated = const Value.absent(),
              }) => InventoryCompanion(
                id: id,
                componentId: componentId,
                qtyOnHand: qtyOnHand,
                unit: unit,
                costPaidCents: costPaidCents,
                dateUpdated: dateUpdated,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int componentId,
                required double qtyOnHand,
                required String unit,
                Value<int?> costPaidCents = const Value.absent(),
                required DateTime dateUpdated,
              }) => InventoryCompanion.insert(
                id: id,
                componentId: componentId,
                qtyOnHand: qtyOnHand,
                unit: unit,
                costPaidCents: costPaidCents,
                dateUpdated: dateUpdated,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$InventoryTable, InventoryData>(table),
                  $$InventoryTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({componentId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (componentId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.componentId,
                                referencedTable: $$InventoryTableReferences
                                    ._componentIdTable(db),
                                referencedColumn: $$InventoryTableReferences
                                    ._componentIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$InventoryTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryTable,
      InventoryData,
      $$InventoryTableFilterComposer,
      $$InventoryTableOrderingComposer,
      $$InventoryTableAnnotationComposer,
      $$InventoryTableCreateCompanionBuilder,
      $$InventoryTableUpdateCompanionBuilder,
      (InventoryData, $$InventoryTableReferences),
      InventoryData,
      PrefetchHooks Function({bool componentId})
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AppJournalEntriesTableTableManager get appJournalEntries =>
      $$AppJournalEntriesTableTableManager(_db, _db.appJournalEntries);
  $$AppJournalPhotosTableTableManager get appJournalPhotos =>
      $$AppJournalPhotosTableTableManager(_db, _db.appJournalPhotos);
  $$AppJournalTagsTableTableManager get appJournalTags =>
      $$AppJournalTagsTableTableManager(_db, _db.appJournalTags);
  $$CartridgesTableTableManager get cartridges =>
      $$CartridgesTableTableManager(_db, _db.cartridges);
  $$ComponentsTableTableManager get components =>
      $$ComponentsTableTableManager(_db, _db.components);
  $$LoadsTableTableManager get loads =>
      $$LoadsTableTableManager(_db, _db.loads);
  $$RangeSessionsTableTableManager get rangeSessions =>
      $$RangeSessionsTableTableManager(_db, _db.rangeSessions);
  $$InventoryTableTableManager get inventory =>
      $$InventoryTableTableManager(_db, _db.inventory);
}
