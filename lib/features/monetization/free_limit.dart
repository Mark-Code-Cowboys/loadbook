import 'package:cc_core/cc_core.dart';

/// The free tier: two cartridges, kept forever. Spent by lifetime
/// tally — starting a page uses a slot; deleting the page doesn't
/// hand it back.
const cartridgesLimit = FreeLimit(2, 'cartridges', detailBuilder: _detail);

String _detail(int remaining) => switch (remaining) {
      0 => 'Loadbook Pro opens unlimited cartridges.',
      1 => 'One free cartridge left — Pro opens unlimited.',
      _ => '$remaining free cartridges left.',
    };
