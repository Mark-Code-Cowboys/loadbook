import 'package:cc_core/cc_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'free_limit.dart';
import 'monetization_providers.dart';

/// Shows the Pro pitch. Resolves true if the user owns Pro when the
/// sheet closes (purchase or restore completed while it was open).
Future<bool> showPaywallSheet(BuildContext context) async {
  final result = await showPaywallModal<bool>(
    context,
    builder: (context) => const _PaywallSheet(),
  );
  return result ?? false;
}

class _PaywallSheet extends ConsumerWidget {
  const _PaywallSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPrice = ref.watch(_monthlyPriceProvider).value;
    final lifetimePrice = ref.watch(_lifetimePriceProvider).value;
    final usage = ref.watch(freeTierUsageProvider);
    final service = ref.read(entitlementServiceProvider);

    // Close with success the moment the entitlement lands.
    ref.listen(isProProvider, (_, next) {
      if (next.value == true && context.mounted) {
        Navigator.of(context).pop(true);
      }
    });

    // Purchase-stream failures land asynchronously; show them so
    // "nothing happened" always has a visible reason (offline taps
    // included, via runStoreAction).
    ref.listen(storeErrorsProvider, (_, next) {
      final message = next.value;
      if (message != null && context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    });

    return PaywallSheetScaffold(
      icon: Icons.menu_book_outlined,
      title: 'Loadbook Pro',
      highlight: usage?.label,
      body: 'Your first ${cartridgesLimit.count} cartridges and every '
          'page under them stay yours forever — nothing is ever locked '
          'away. Pro keeps the notebook growing. No account, and your '
          'records never leave this phone.',
      benefits: const [
        PaywallBenefit(
          icon: Icons.all_inclusive,
          title: 'Unlimited cartridges',
          detail: 'A page for everything you load.',
        ),
        PaywallBenefit(
          icon: Icons.speed_outlined,
          title: 'Chronograph stats',
          detail: 'Velocity, SD, and ES on every session.',
        ),
        PaywallBenefit(
          icon: Icons.ios_share_outlined,
          title: 'Export and backup',
          detail: 'Your notebook back out — CSV and full backup.',
        ),
      ],
      // Equal citizens: the lifetime unlock is not the fine print.
      primaryLabel: 'Monthly · ${monthlyPrice ?? r'$1.49'} / month',
      onPrimary: () => runStoreAction(context, service.buyPremium),
      restoreLabel: 'Restore purchase',
      onRestore: () => runStoreAction(context, service.restorePurchases),
      extraActions: [
        FilledButton.tonalIcon(
          icon: const Icon(Icons.workspace_premium_outlined),
          label: Text('Lifetime · ${lifetimePrice ?? r'$14.99'} once'),
          onPressed: () => runStoreAction(context, service.buyUnlimited),
        ),
      ],
      onLater: () => Navigator.of(context).pop(false),
    );
  }
}

final _monthlyPriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).premiumPrice(),
);

final _lifetimePriceProvider = FutureProvider.autoDispose<String?>(
  (ref) => ref.watch(entitlementServiceProvider).unlimitedPrice(),
);
