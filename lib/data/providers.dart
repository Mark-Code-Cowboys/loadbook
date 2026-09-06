import 'dart:io';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'database/app_database.dart';
import 'repositories/cartridge_repository.dart';
import 'repositories/component_repository.dart';
import 'repositories/inventory_repository.dart';
import 'repositories/load_repository.dart';
import 'repositories/range_session_repository.dart';

/// Overridden in main() with the real on-device database, and in tests
/// with an in-memory one.
final databaseProvider = Provider<AppDatabase>(
  (ref) => throw UnimplementedError('databaseProvider must be overridden'),
);

/// Overridden in tests with [InMemoryKeyValueStore].
final kvStoreProvider = Provider<KeyValueStore>((ref) => SharedPrefsStore());

/// Overridden in main() with ImagePickerPhotoService over the app's
/// photo directory, and in tests with a fake.
final photoServiceProvider = Provider<PhotoService>(
  (ref) => throw UnimplementedError('photoServiceProvider must be overridden'),
);

/// Overridden in main() with SharePlusLauncher, and in tests with
/// cc_core's FakeShareLauncher.
final shareLauncherProvider = Provider<ShareLauncher>(
  (ref) =>
      throw UnimplementedError('shareLauncherProvider must be overridden'),
);

/// Overridden in main() with getTemporaryDirectory, and in tests with
/// a systemTemp-backed function.
final tempDirProvider = Provider<Future<Directory> Function()>(
  (ref) => throw UnimplementedError('tempDirProvider must be overridden'),
);

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

/// Storage key for the lifetime cartridge tally — stable forever; a
/// backup's figure restores against the same key.
const kCartridgeTallyKey = 'cartridges_created_lifetime';

/// The free tier's memory: cartridges ever started, never decremented.
final cartridgeTallyProvider = Provider<LifetimeTally>(
  (ref) =>
      LifetimeTally(ref.watch(kvStoreProvider), key: kCartridgeTallyKey),
);

final cartridgeRepositoryProvider = Provider<CartridgeRepository>(
  (ref) => CartridgeRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider),
      tally: ref.watch(cartridgeTallyProvider)),
);

final componentRepositoryProvider = Provider<ComponentRepository>(
  (ref) => ComponentRepository(ref.watch(databaseProvider)),
);

final loadRepositoryProvider = Provider<LoadRepository>(
  (ref) => LoadRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final rangeSessionRepositoryProvider = Provider<RangeSessionRepository>(
  (ref) => RangeSessionRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
);

final inventoryRepositoryProvider = Provider<InventoryRepository>(
  (ref) => InventoryRepository(ref.watch(databaseProvider)),
);
