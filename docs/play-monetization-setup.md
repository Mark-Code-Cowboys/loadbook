# Loadbook — Play monetization setup (manual checklist)

Do these in order — the products menu is hidden until Play has
processed a build containing the billing permission. Mirrors the
fleet's checklists; differences called out.

## 0. Payments profile (account level, one-time)

Already done for TableEncore. Skip.

## 1. Upload the AAB

Internal testing → Create release → `app-release.aab` (see
release-checklist.md for the build). The `in_app_purchase` plugin
embeds `com.android.vending.BILLING`; once Play processes the build,
**Monetize** unlocks.

## 2. One-time product (Monetize → Products → In-app products)

| Product ID | Name | Price |
| --- | --- | --- |
| `loadbook_pro_lifetime` | Loadbook Pro — Lifetime | $14.99 |

Id must match `lib/features/monetization/entitlements.dart` exactly.
Purchase option ID: `buy` (the code never reads it — keep the
backwards-compatible default). Mark **Active**.

Description (≤200 chars, shown in the purchase dialog):

> Loadbook Pro, forever: unlimited cartridges, chronograph stats,
> trends, index-card import, target measuring, and export. One
> purchase, no subscription.

## 3. Subscription (Monetize → Products → Subscriptions)

| Product ID | Base plan ID | Billing | Price |
| --- | --- | --- | --- |
| `loadbook_pro_monthly` | `monthly` | Monthly, auto-renewing | $1.49/mo |

Single base plan — cc_core's `premiumPrice()`/`buyPremium()` use the
first base plan. Mark **Active**.

Description:

> Loadbook Pro: unlimited cartridges, chronograph stats, trends,
> index-card import, target measuring, and export. Cancel anytime —
> your notebook stays yours.

## 4. License testers

Play Console → Settings → License testing: add the test accounts.
Purchases are free and auto-refund for them — the release checklist's
paywall pass depends on this.

## 5. Sanity check in-app

On a license-tester device, open the paywall sheet: both live prices
show (not the $1.49/$14.99 fallbacks), monthly and lifetime both
purchasable, Restore purchase works after reinstall.
