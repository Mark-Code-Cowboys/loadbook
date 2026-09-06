import 'dart:async';

import 'package:cc_core/cc_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';
import 'entitlements.dart';
import 'free_limit.dart';

final entitlementServiceProvider = Provider<EntitlementService>((ref) {
  final service =
      StoreEntitlementService(ref.watch(kvStoreProvider), lbStoreProducts);
  // Fire-and-forget lapse check; the cache answers until it lands.
  unawaited(service.refreshEntitlements());
  ref.onDispose(service.dispose);
  return service;
});

/// True when Pro is owned — the lifetime unlock or an active monthly
/// subscription. Defaults false while loading so gating stays
/// conservative.
final isProProvider = StreamProvider<bool>(
  (ref) => ref.watch(entitlementServiceProvider).watchUnlimited(),
);

/// Store failure messages so an open paywall sheet can show why
/// nothing happened.
final storeErrorsProvider = StreamProvider<String>(
  (ref) => ref.watch(entitlementServiceProvider).storeErrors,
);

/// Cartridges ever started on this device, live. Deleting one doesn't
/// lower it: the free tier is spent by starting a page, not by keeping
/// it — a chapter isn't a recyclable slot.
final lifetimeCartridgesProvider = StreamProvider<int>(
  (ref) => ref.watch(cartridgeRepositoryProvider).watchLifetimeCreated(),
);

/// Null while loading and null whenever the cap doesn't apply (Pro
/// owned) — counter UI simply disappears for paying users.
final freeTierUsageProvider = Provider<FreeLimitUsage?>((ref) {
  final pro = ref.watch(isProProvider).value;
  final count = ref.watch(lifetimeCartridgesProvider).value;
  if (pro == null || pro || count == null) return null;
  return cartridgesLimit.usage(count);
});
