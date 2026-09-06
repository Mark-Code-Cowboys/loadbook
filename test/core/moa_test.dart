import 'package:flutter_test/flutter_test.dart';
import 'package:loadbook/core/utils/moa.dart';

void main() {
  test('1 MOA is 1.047" at 100 yd', () {
    expect(inchesPerMoaAt(100), closeTo(1.047, 1e-9));
    expect(moaFor(groupSizeIn: 1.047, distanceYd: 100), closeTo(1.0, 1e-9));
  });

  test('scales linearly with distance', () {
    expect(inchesPerMoaAt(300), closeTo(3.141, 1e-9));
    // The same 1 MOA group is twice the inches at twice the distance.
    expect(moaFor(groupSizeIn: 2.094, distanceYd: 200), closeTo(1.0, 1e-9));
    // And a 100-yd-sized group at 50 yd is twice the angle.
    expect(moaFor(groupSizeIn: 1.047, distanceYd: 50), closeTo(2.0, 1e-9));
  });

  test('sub-MOA math', () {
    expect(
        moaFor(groupSizeIn: 0.5235, distanceYd: 100), closeTo(0.5, 1e-9));
    expect(moaFor(groupSizeIn: 0.75, distanceYd: 100),
        closeTo(0.75 / 1.047, 1e-9));
  });

  test('missing measurements compute nothing, never a guess', () {
    expect(moaFor(groupSizeIn: null, distanceYd: 100), isNull);
    expect(moaFor(groupSizeIn: 1.0, distanceYd: null), isNull);
    expect(moaFor(groupSizeIn: 1.0, distanceYd: 0), isNull);
    expect(moaFor(groupSizeIn: 1.0, distanceYd: -25), isNull);
  });
}
