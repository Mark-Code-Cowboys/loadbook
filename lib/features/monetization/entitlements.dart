import 'package:cc_core/cc_core.dart';

// The billing wrapper, entitlement cache, and store types live in
// cc_core; this file keeps Loadbook's product catalog and re-exports
// the shared types for app import sites.
export 'package:cc_core/cc_core.dart'
    show
        EntitlementService,
        FakeEntitlementService,
        StoreEntitlementService,
        StoreProducts,
        StoreUnavailableException;

/// Store product ids. Must match the products configured in Play
/// Console (and later App Store Connect) exactly.
abstract final class ProductIds {
  static const proMonthly = 'loadbook_pro_monthly';
  static const proLifetime = 'loadbook_pro_lifetime';
  static const all = [proMonthly, proLifetime];
}

/// Loadbook's catalog: one Pro entitlement, sold as a cheap monthly
/// subscription or a lifetime unlock — equal citizens, per the rescue
/// positioning (a notebook you could lose to a lapsed subscription is
/// no rescue at all). cc_core's `isUnlimited()` is true for either.
const lbStoreProducts = StoreProducts(
  lifetimeUnlock: ProductIds.proLifetime,
  premiumSubscription: ProductIds.proMonthly,
);
