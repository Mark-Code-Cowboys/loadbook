
import 'package:flutter/material.dart';

import '../../core/utils/format.dart';
import '../../core/utils/moa.dart';

/// Manual two-handle measurement over a target photo. The user drags a
/// line across something they know the size of (a grid square, a
/// ruler) and types that length, then drags a second line across the
/// group as they judge it. Group inches = group pixels x known length
/// / reference pixels; MOA from the session's distance.
///
/// Rails: nothing is detected and nothing is judged — every endpoint
/// and the reference length are the user's own, and the math is plain
/// recorded arithmetic, all on-device.
class TargetMeasureScreen extends StatefulWidget {
  const TargetMeasureScreen({
    super.key,
    required this.image,
    required this.distanceYd,
  });

  /// The target photo (a FileImage in the app; any provider in tests).
  final ImageProvider image;

  /// The session's shooting distance, already entered by the user.
  final int distanceYd;

  @override
  State<TargetMeasureScreen> createState() => _TargetMeasureScreenState();
}

class _TargetMeasureScreenState extends State<TargetMeasureScreen> {
  var _calibrating = true;
  final _refLength = TextEditingController();

  // Handle positions in the photo area's local coordinates; seeded
  // apart on first layout.
  Offset? _calA, _calB, _groupA, _groupB;

  @override
  void dispose() {
    _refLength.dispose();
    super.dispose();
  }

  double? get _refLen => double.tryParse(_refLength.text.trim());

  double get _refPx => _calA == null ? 0 : (_calA! - _calB!).distance;
  double get _groupPx =>
      _groupA == null ? 0 : (_groupA! - _groupB!).distance;

  /// Null until both lines are real (a collapsed reference line can't
  /// scale anything).
  double? get _groupIn {
    final len = _refLen;
    if (len == null || len <= 0 || _refPx < 8 || _groupPx <= 0) {
      return null;
    }
    return _groupPx / _refPx * len;
  }

  void _seed(Size size) {
    _calA ??= Offset(size.width * 0.3, size.height * 0.4);
    _calB ??= Offset(size.width * 0.7, size.height * 0.4);
    _groupA ??= Offset(size.width * 0.35, size.height * 0.6);
    _groupB ??= Offset(size.width * 0.65, size.height * 0.6);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupIn = _groupIn;
    final moa = groupIn == null
        ? null
        : moaFor(groupSizeIn: groupIn, distanceYd: widget.distanceYd);
    return Scaffold(
      appBar: AppBar(title: const Text('Measure group')),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              final size = constraints.biggest;
              _seed(size);
              Offset clamp(Offset o) => Offset(
                  o.dx.clamp(0, size.width), o.dy.clamp(0, size.height));
              return Stack(
                fit: StackFit.expand,
                children: [
                  Image(
                    image: widget.image,
                    fit: BoxFit.contain,
                    errorBuilder: (_, _, _) => ColoredBox(
                        color: theme.colorScheme.surfaceContainerHighest),
                  ),
                  CustomPaint(
                    painter: _LinesPainter(
                      calA: _calA!,
                      calB: _calB!,
                      groupA: _groupA!,
                      groupB: _groupB!,
                      calColor: theme.colorScheme.primary,
                      groupColor: theme.colorScheme.tertiary,
                      calibrating: _calibrating,
                    ),
                  ),
                  if (_calibrating) ...[
                    _Handle(
                      key: const Key('cal-a'),
                      position: _calA!,
                      color: theme.colorScheme.primary,
                      onMoved: (d) =>
                          setState(() => _calA = clamp(_calA! + d)),
                    ),
                    _Handle(
                      key: const Key('cal-b'),
                      position: _calB!,
                      color: theme.colorScheme.primary,
                      onMoved: (d) =>
                          setState(() => _calB = clamp(_calB! + d)),
                    ),
                  ] else ...[
                    _Handle(
                      key: const Key('group-a'),
                      position: _groupA!,
                      color: theme.colorScheme.tertiary,
                      onMoved: (d) =>
                          setState(() => _groupA = clamp(_groupA! + d)),
                    ),
                    _Handle(
                      key: const Key('group-b'),
                      position: _groupB!,
                      color: theme.colorScheme.tertiary,
                      onMoved: (d) =>
                          setState(() => _groupB = clamp(_groupB! + d)),
                    ),
                  ],
                ],
              );
            }),
          ),
          Material(
            color: theme.colorScheme.surface,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: _calibrating
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Drag the line ends across something on the '
                          'target you know the size of — a grid square, '
                          'a ruler — and enter that length.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _refLength,
                                decoration: const InputDecoration(
                                    labelText: 'Its length',
                                    suffixText: 'in'),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                        decimal: true),
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed:
                                  (_refLen ?? 0) > 0 && _refPx >= 8
                                      ? () => setState(
                                          () => _calibrating = false)
                                      : null,
                              child: const Text('Next'),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Now drag the line across the group, wherever '
                          'you measure it from.',
                          style: theme.textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          groupIn == null
                              ? '—'
                              : '${formatDecimal(groupIn)}"'
                                  '${moa == null ? '' : ' · ${moa.toStringAsFixed(2)} MOA '
                                      'at ${widget.distanceYd} yd'}',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            TextButton(
                              onPressed: () =>
                                  setState(() => _calibrating = true),
                              child: const Text('Re-calibrate'),
                            ),
                            const Spacer(),
                            FilledButton(
                              onPressed: groupIn == null
                                  ? null
                                  : () => Navigator.of(context)
                                      .pop(groupIn),
                              child: Text(groupIn == null
                                  ? 'Use'
                                  : 'Use ${formatDecimal(groupIn)}"'),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Handle extends StatelessWidget {
  const _Handle({
    super.key,
    required this.position,
    required this.color,
    required this.onMoved,
  });

  final Offset position;
  final Color color;
  final ValueChanged<Offset> onMoved;

  @override
  Widget build(BuildContext context) {
    const size = 44.0;
    return Positioned(
      left: position.dx - size / 2,
      top: position.dy - size / 2,
      child: GestureDetector(
        onPanUpdate: (d) => onMoved(d.delta),
        child: Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          decoration: const BoxDecoration(shape: BoxShape.circle),
          child: Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withValues(alpha: 0.9),
              border: Border.all(color: Colors.white, width: 2),
            ),
          ),
        ),
      ),
    );
  }
}

class _LinesPainter extends CustomPainter {
  const _LinesPainter({
    required this.calA,
    required this.calB,
    required this.groupA,
    required this.groupB,
    required this.calColor,
    required this.groupColor,
    required this.calibrating,
  });

  final Offset calA, calB, groupA, groupB;
  final Color calColor, groupColor;
  final bool calibrating;

  @override
  void paint(Canvas canvas, Size size) {
    final cal = Paint()
      ..color = calColor.withValues(alpha: calibrating ? 1 : 0.4)
      ..strokeWidth = 3;
    canvas.drawLine(calA, calB, cal);
    if (!calibrating) {
      final group = Paint()
        ..color = groupColor
        ..strokeWidth = 3;
      canvas.drawLine(groupA, groupB, group);
      // End caps perpendicular to the group line, caliper-style.
      final dir = (groupB - groupA);
      if (dir.distance > 0) {
        final n = Offset(-dir.dy, dir.dx) / dir.distance * 10;
        canvas.drawLine(groupA - n, groupA + n, group);
        canvas.drawLine(groupB - n, groupB + n, group);
      }
    }
  }

  @override
  bool shouldRepaint(_LinesPainter old) =>
      old.calA != calA ||
      old.calB != calB ||
      old.groupA != groupA ||
      old.groupB != groupB ||
      old.calibrating != calibrating;
}

/// Convenience: push the screen and hand back the measured inches, or
/// null if the user backed out.
Future<double?> measureTargetPhoto(
  BuildContext context, {
  required ImageProvider image,
  required int distanceYd,
}) =>
    Navigator.of(context).push<double>(MaterialPageRoute(
        builder: (_) =>
            TargetMeasureScreen(image: image, distanceYd: distanceYd)));
