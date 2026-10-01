import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Three layers of soft clouds drifting in opposite directions. It sits on top
/// of a content panel: the front layer is the panel's own colour
/// ([AppColors.kColorPrimaryFaded]), so the panel appears to rise out of the
/// clouds.
///
/// [phase] is a 0–1 value that loops; the parent drives it from a repeating
/// controller (or holds it still for reduced motion).
class CloudBank extends StatelessWidget {
  const CloudBank({required this.phase, super.key});

  final double phase;

  /// Height of the strip the clouds are painted in.
  static const double height = 100;

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: CustomPaint(
        size: const Size(double.infinity, height),
        painter: _CloudPainter(phase),
      ),
    );
  }
}

class _CloudLayer {
  const _CloudLayer({
    required this.color,
    required this.baseY,
    required this.radius,
    required this.drift,
    required this.seed,
  });

  final Color color;
  final double baseY;
  final double radius;
  final double drift;
  final double seed;
}

class _CloudPainter extends CustomPainter {
  _CloudPainter(this.phase);

  final double phase;

  static const double _kSpacingFactor = 1.05;
  static const double _kRadiusVariation = 0.25;

  static final List<_CloudLayer> _layers = [
    _CloudLayer(
      color: AppColors.kColorPrimary.withValues(alpha: 0.16),
      baseY: 62,
      radius: 34,
      drift: 0.6,
      seed: 0.4,
    ),
    _CloudLayer(
      color: AppColors.kColorSurface.withValues(alpha: 0.92),
      baseY: 78,
      radius: 28,
      drift: -1.0,
      seed: 2.1,
    ),
    const _CloudLayer(
      color: AppColors.kColorPrimaryFaded,
      baseY: 92,
      radius: 22,
      drift: 0.8,
      seed: 4.7,
    ),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    for (final layer in _layers) {
      final spacing = layer.radius * _kSpacingFactor;
      final span = size.width + 2 * spacing;
      final count = (span / spacing).ceil() + 1;
      final path = Path();
      for (var i = 0; i < count; i++) {
        final raw = i * spacing + phase * layer.drift * size.width;
        final x = ((raw % span) + span) % span - spacing;
        final r =
            layer.radius *
            (1 -
                _kRadiusVariation +
                _kRadiusVariation * math.sin(i * 2.3 + layer.seed));
        path.addOval(
          Rect.fromCircle(center: Offset(x, layer.baseY), radius: r),
        );
      }
      path.addRect(
        Rect.fromLTRB(0, layer.baseY, size.width, size.height + layer.radius),
      );
      canvas.drawPath(path, Paint()..color = layer.color);
    }
  }

  @override
  bool shouldRepaint(_CloudPainter old) => old.phase != phase;
}
