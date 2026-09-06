# Loadbook — Release checklist

Work top to bottom; nothing ships with an unchecked box above it.
RE-READ THE STORE-POLICY RAILS (prompt §1–6) BEFORE THE STORE SECTION:
ships empty, transcribe-only, no purchase links, no firearm imagery,
notebook framing, regional availability chosen deliberately.

## Code

- [x] `pubspec.yaml` version bumped (`1.0.0+1` for the first release)
- [x] cc_core pinned to a pushed tag (currently `v0.21.2`) —
      `pubspec_overrides.yaml` is git-ignored and must NOT influence the
      release build: `flutter pub get` on a clean checkout resolves
- [x] `flutter analyze` — zero issues
- [x] `flutter test` — all green (49)
- [x] `dart run flutter_launcher_icons` output committed (android/ios)

## The paywall pass (both platforms, sandbox/license testers)

Run in order on a fresh install. Same pass on iOS once the Codemagic
lane exists — steps identical, StoreKit sandbox account instead.

1. [ ] Fresh install → onboarding → "Just look around": counter reads
       "0 of 2 cartridges", Trends shows the Pro teaser
2. [ ] Add 2 cartridges → each add ticks the counter; the 3rd add
       opens the paywall instead of the dialog
3. [ ] Dismiss ("Not now") → no cartridge added, gate still closed
4. [ ] Delete a cartridge → still gated (lifetime tally — slots are
       never refunded)
5. [ ] Chrono fields in the session composer: visible, marked Pro,
       tap opens the paywall; distance/shots/group still editable free
6. [ ] Index-card import as free user → paywall first
7. [ ] Buy monthly (sandbox) → sheet closes itself, counter gone,
       3rd cartridge dialog opens, chrono fields editable, Trends live
8. [ ] Kill + relaunch offline → still Pro (entitlement cache)
9. [ ] Cancel the subscription → after sandbox expiry + relaunch,
       gates return; every load and session still readable/editable
10. [ ] Buy lifetime on a second tester → same entitlement; lifetime
        price shown correctly beforehand
11. [ ] Uninstall → reinstall → Restore purchase → Pro returns; then
        restore a backup → notebook AND free-tier tally intact

## On-device (Pixel), release build

- [ ] `flutter run --release` cold start < 2s, no red screens
- [ ] Onboarding shows once; kill/relaunch skips it. Check the
      finish-tap does NOT fall through to the list underneath (seen
      once on the emulator — same-spot double-delivery through the
      route swap; debounce if it reproduces on device)
- [ ] Index-card import with 3 real cards: scanner opens, review shows
      transcriptions verbatim (no field ever prefilled with a guess),
      edit one, bulk insert lands under the right cartridges
- [ ] Target measure on a real target photo: calibrate against a known
      grid square, measured inches match a caliper measurement within
      reason, MOA fills the composer field
- [ ] Load composer: an out-of-pattern charge saves exactly as typed —
      no hint, no flag, no warning anywhere (rails §3 spot check)
- [ ] Backup → share to Drive → wipe app data → restore → notebook,
      target photos, and free-tier tally intact
- [ ] CSV opens in Sheets: session rows joined with recipes,
      sessionless loads present, MOA column sane
- [ ] DEMO_SEED build only for screenshots — never the uploaded AAB
- [ ] Dark theme spot-check: home, recipe card, composers, paywall,
      trends, measurer

## Store (rails re-read here)

- [ ] Privacy policy live at code-cowboys.com/privacy/loadbook
      (source: `docs/privacy-policy.md`)
- [ ] Listing fields pasted from `docs/play-store-listing.md` —
      final read-through against rails §1–5: no wording that implies
      the app provides or checks load data; no firearm imagery in any
      asset
- [ ] **Region availability chosen deliberately (rails §6)**: pick the
      initial country list (US-first is fine), record it here, and
      treat every later expansion as a policy review — this category
      is restricted in some countries and Play may restrict further.
      Nothing in the app assumes universal availability.
- [ ] Content rating questionnaire answered truthfully (no weapons
      depicted, no load data; record-keeping journal)
- [ ] Screenshots: 6 per the listing doc, all from DEMO_SEED (only
      fictional values on screen)
- [ ] Feature graphic + 512 store icon exported (brass mark, no
      firearm imagery)
- [ ] Products created per `docs/play-monetization-setup.md`, Active
- [ ] Data safety form matches the privacy policy (no data collected)

## Build & upload

- [ ] `android/key.properties` + keystore in place (never committed)
- [ ] `flutter build appbundle --release`
- [ ] Internal testing release; license testers run the paywall pass
- [ ] Promote to closed → production when the boxes above are checked

## Post-launch

- [ ] Tag the app repo `v1.0.0`
- [ ] Note any cc_core friction found during release in
      course-ledger's `docs/cc-core-gaps.md` (the fleet ledger)
- [ ] Backlog: onboarding tap debounce if seen on device; zoom in the
      target measurer for finer handle placement; optional
      decrement-on-session inventory toggle (deliberately out of v1)
