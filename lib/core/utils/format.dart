const _months = [
  'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
  'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
];

/// "Mar 14, 2026" — the notebook's date style, no intl dependency.
String formatDate(DateTime d) => '${_months[d.month - 1]} ${d.day}, ${d.year}';

/// A user-entered decimal back out the way it went in: up to two
/// places, trailing zeros trimmed ("42.5", "42", "2.81").
String formatDecimal(double value) {
  var s = value.toStringAsFixed(2);
  while (s.endsWith('0')) {
    s = s.substring(0, s.length - 1);
  }
  if (s.endsWith('.')) s = s.substring(0, s.length - 1);
  return s;
}
