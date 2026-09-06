import 'package:cc_core/cc_core.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/providers.dart';

/// The free tier: two cartridges, kept forever. A lifetime tally comes
/// with Phase C; for now the gate counts live chapters.
const cartridgesLimit = FreeLimit(2, 'cartridges', detailBuilder: _detail);

String _detail(int remaining) => switch (remaining) {
      0 => 'Loadbook Pro opens unlimited cartridges.',
      1 => 'One free cartridge left — Pro opens unlimited.',
      _ => '$remaining free cartridges left.',
    };

/// Live cartridge count for the gate and the home chip.
final cartridgeCountProvider = StreamProvider<int>((ref) {
  final db = ref.watch(databaseProvider);
  final countExp = db.cartridges.id.count();
  final query = db.selectOnly(db.cartridges)..addColumns([countExp]);
  return query.watchSingle().map((row) => row.read(countExp) ?? 0);
});

/// PHASE C replaces this stub with the real store-backed sheet
/// (products loadbook_pro_monthly / loadbook_pro_lifetime).
Future<void> showPaywallSheet(BuildContext context) {
  return showPaywallModal<void>(
    context,
    builder: (context) => PaywallSheetScaffold(
      icon: Icons.menu_book_outlined,
      title: 'Loadbook Pro',
      highlight: cartridgesLimit.usage(cartridgesLimit.count).label,
      body: 'Unlimited cartridges for your notebook. Phase C wires the '
          'real products here.',
      primaryLabel: 'Coming soon',
      onPrimary: () => Navigator.of(context).pop(),
      onLater: () => Navigator.of(context).pop(),
    ),
  );
}
