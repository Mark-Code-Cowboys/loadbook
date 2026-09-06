import '../../data/database/app_database.dart';
import '../../data/repositories/cartridge_repository.dart';
import '../../data/repositories/component_repository.dart';
import '../../data/repositories/load_repository.dart';
import 'card_parser.dart';

/// What the bulk insert did, for the closing snackbar.
class ImportReport {
  const ImportReport({
    required this.loadsAdded,
    required this.cartridgesCreated,
    required this.skipped,
  });

  final int loadsAdded;
  final int cartridgesCreated;
  final int skipped;

  String get summary {
    final added = loadsAdded == 1 ? '1 load' : '$loadsAdded loads';
    final parts = [
      'Added $added',
      if (cartridgesCreated > 0)
        '$cartridgesCreated new '
            '${cartridgesCreated == 1 ? 'cartridge' : 'cartridges'}',
    ].join(', ');
    final tail = skipped == 0
        ? '.'
        : '. $skipped ${skipped == 1 ? 'card' : 'cards'} skipped — '
            'missing cartridge, bullet, powder, charge, or primer.';
    return '$parts$tail';
  }
}

/// "Maker Name" as written -> (maker, name). One word means the maker
/// wasn't written; it becomes the name with a placeholder maker (the
/// fleet's "—" convention) so nothing is invented.
({String maker, String name}) splitMakerName(String text) {
  final parts = text.trim().split(RegExp(r'\s+'));
  if (parts.length == 1) return (maker: '—', name: parts.single);
  return (maker: parts.first, name: parts.sublist(1).join(' '));
}

/// Files the kept cards: cartridges and components matched
/// case-insensitively against what the user already has, created from
/// the card's own words otherwise. Cards missing a required field are
/// skipped (counted, never guessed at). Dateless cards file under
/// today, like every CC converter.
Future<ImportReport> insertCardDrafts({
  required AppDatabase db,
  required CartridgeRepository cartridges,
  required ComponentRepository components,
  required LoadRepository loads,
  required List<CardDraft> drafts,
}) async {
  var added = 0;
  var newCartridges = 0;
  var skipped = 0;

  final cartridgeIds = <String, int>{};
  for (final c in await db.select(db.cartridges).get()) {
    cartridgeIds[c.name.trim().toLowerCase()] = c.id;
  }
  final componentIds = <String, int>{};
  for (final c in await db.select(db.components).get()) {
    componentIds['${c.kind.name}|${c.maker} ${c.name}'.toLowerCase()] =
        c.id;
  }

  Future<int> resolveComponent(ComponentKind kind, String text,
      {double? weightGr}) async {
    final (:maker, :name) = splitMakerName(text);
    final key = '${kind.name}|$maker $name'.toLowerCase();
    final existing = componentIds[key];
    if (existing != null) return existing;
    final id = await components.create(ComponentDraft(
        kind: kind, maker: maker, name: name, weightGr: weightGr));
    componentIds[key] = id;
    return id;
  }

  for (final draft in drafts) {
    if (!draft.isComplete) {
      skipped++;
      continue;
    }

    final cartridgeKey = draft.cartridge!.trim().toLowerCase();
    var cartridgeId = cartridgeIds[cartridgeKey];
    if (cartridgeId == null) {
      cartridgeId = await cartridges.create(name: draft.cartridge!.trim());
      cartridgeIds[cartridgeKey] = cartridgeId;
      newCartridges++;
    }

    await loads.create(LoadDraft(
      cartridgeId: cartridgeId,
      bulletId: await resolveComponent(ComponentKind.bullet, draft.bullet!,
          weightGr: draft.bulletWeightGr),
      powderId:
          await resolveComponent(ComponentKind.powder, draft.powder!),
      chargeGr: draft.chargeGr!,
      primerId:
          await resolveComponent(ComponentKind.primer, draft.primer!),
      brassId: draft.brass == null
          ? null
          : await resolveComponent(ComponentKind.brass, draft.brass!),
      coalIn: draft.coalIn,
      dateDeveloped: draft.date ?? DateTime.now(),
      notes: draft.notes,
    ));
    added++;
  }

  return ImportReport(
      loadsAdded: added,
      cartridgesCreated: newCartridges,
      skipped: skipped);
}
