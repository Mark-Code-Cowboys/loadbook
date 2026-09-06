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

/// cc_core's journal repository over this database's generated tables.
final journalRepositoryProvider = Provider<AppJournalRepository>(
  (ref) => ref
      .watch(databaseProvider)
      .journal(photoStore: ref.watch(photoServiceProvider)),
);

final cartridgeRepositoryProvider = Provider<CartridgeRepository>(
  (ref) => CartridgeRepository(ref.watch(databaseProvider),
      journal: ref.watch(journalRepositoryProvider)),
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
