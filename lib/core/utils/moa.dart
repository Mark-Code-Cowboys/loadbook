/// Group-size angle math. All on-device arithmetic — the only numbers
/// involved are the user's own measurements.
library;

/// Inches subtended by one minute of angle at [distanceYd] yards:
/// 1 MOA = 1.047" at 100 yd, scaling linearly with distance.
double inchesPerMoaAt(int distanceYd) => 1.047 * distanceYd / 100;

/// [groupSizeIn] expressed in minutes of angle at [distanceYd] yards,
/// or null when either measurement is missing or the distance isn't a
/// positive number (nothing to compute, never a guess).
double? moaFor({double? groupSizeIn, int? distanceYd}) {
  if (groupSizeIn == null || distanceYd == null || distanceYd <= 0) {
    return null;
  }
  return groupSizeIn / inchesPerMoaAt(distanceYd);
}
