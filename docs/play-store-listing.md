# Loadbook — Google Play Store Listing

Copy-paste source for the Play Console listing. Character limits noted
per field. Rails apply to every word and image here: notebook framing,
no firearm imagery (press, brass, targets, notebook only), and nothing
that reads as load data — the demo seed's fictional values are the only
values ever shown.

---

## App name (max 30 chars)

> Loadbook: Reloading Journal

(26 chars. Alternatives: "Loadbook" alone (8); "Loadbook — Handload
Notebook" (28).)

## Short description (max 80 chars)

> Your reloading notebook — recipes, range sessions, and the shelf, off the cards.

(80 chars — reloading notebook is the lead phrase.)

## Full description (max 4000 chars)

> **Your reloading notebook, off the index cards.**
>
> Loadbook is a journal of what you did at your bench: the recipes you
> developed, the range sessions that proved them, and what's on the
> shelf. Your records, in your own words and your own numbers.
>
> **It ships empty — and stays out of your way.** Loadbook contains no
> load data, no reference tables, and no lookups. It never suggests a
> charge, never flags a value, and never second-guesses a card. It is
> a notebook, not a manual: what you write is what it keeps.
>
> **The recipe card, digitized**
> • A page per cartridge, loads grouped the way you actually work:
>   working, keepers, retired
> • Every card exactly as you wrote it — bullet, powder and charge,
>   primer, brass, COAL, crimp, date, notes
> • Components live once on your shelf and are picked, not retyped
>
> **Range sessions under every load**
> Date, firearm (free text — Loadbook keeps no firearm registry),
> distance, shots, group size with MOA computed on-device, weather,
> notes, and target photos. Measure a group straight off the photo:
> calibrate against a grid square you know, drag a line across the
> group, done.
>
> **The index-card import**
> Years of cards in a shoebox? Photograph them 20 at a time. Loadbook
> transcribes each card — you confirm every field before anything is
> saved, and missing values stay blank until you fill them. Nothing is
> ever guessed.
>
> **Inventory, your way**
> What's on hand per component, in whatever unit you count in, at the
> prices you actually paid. No price lookups, no store links.
>
> **Trends (Pro)**
> Loads developed over time for every cartridge. Group size and chrono
> SD over sessions for every load. Chronograph stats on sessions, CSV
> export of the whole notebook, and full backup/restore.
>
> **Private by construction**
> No account. No cloud. No analytics. Card reading happens on-device
> and the app requests no location permission. Your first 2 cartridges
> are free forever; Loadbook Pro (monthly or one-time lifetime)
> removes the cap. Restoring your own backup is never paywalled.
>
> The notebook is yours. We never see it.

## Keywords (App Store keyword field; woven into Play description above)

reloading log, reloading journal, handload notebook, load development
log, reloading notebook, range log, handloading journal

## Category

Sports (secondary consideration: Lifestyle). Content rating
questionnaire: answer the weapons-related questions truthfully — the
app depicts no weapons and contains no load data; it is a
record-keeping journal.

## Privacy policy URL

https://code-cowboys.com/privacy/loadbook
(Source text: `docs/privacy-policy.md` — publish before submission.)

## Region availability (rails §6)

Expect store restrictions on this category by country. Choose the
country list deliberately at first rollout (US first is fine) and
treat every expansion as a policy decision, not a default. Nothing in
the app depends on universal availability.

---

## Screenshots (phone, 1080×2400, DEMO_SEED data)

Run `flutter run --dart-define=DEMO_SEED=true`; the seed plants the
two fictional chapters (.30 Fable / 6.5 Folktale) with repeating-digit
placeholder charges — the only values that ever appear in store art.
Order tells the product story:

1. **The recipe card** — .30 Fable keeper load detail: the card rows,
   status selector. Caption: "The index card, digitized."
2. **Session history** — same screen scrolled to the session cards
   (groups, MOA, chrono, target-photo counts) with the two trend
   lines above. Caption: "Every trip, under the load that fired it."
3. **The notebook import** — batch review screen mid-import (stage 2-3
   demo cards; screenshot the review list). Caption: "Shoot the
   shoebox. Confirm every field. Done."
4. **Target measure** — the measurer over a demo target, group line
   placed, MOA readout showing. Caption: "Measure the group off the
   photo."
5. **Inventory** — the shelf grouped by kind, user units and paid
   prices. Caption: "The shelf, in your units."
6. **Trends** — headline counts + per-cartridge year bars. Caption:
   "The long arc of your load development."

If a 7th slot is wanted: home with the "1 of 2 free cartridges"
counter (fresh NON-demo install — demo fakes Pro and hides it).

Feature graphic (1024×500) and 512px store icon: derive from
`assets/icon/` art — warm brass, the notebook-and-target mark,
wordmark right. No firearm imagery anywhere (rails §4). TODO alongside
first upload.
