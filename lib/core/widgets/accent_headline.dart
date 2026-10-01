import 'dart:ui' show PathMetric;

import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

/// Display headline with one highlighted word underlined by a hand-drawn
/// swoosh: `[lead][highlight]`. [swoosh] (0–1) draws the underline from left
/// to right; leave it at 1 for a static headline.
class AccentHeadline extends StatelessWidget {
  const AccentHeadline({
    required this.lead,
    required this.highlight,
    this.swoosh = 1,
    super.key,
  });

  final String lead;
  final String highlight;
  final double swoosh;

  static const double _kSwooshHeight = 8;
  static const double _kSwooshStroke = 4;

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: AppTextStyles.kTextDisplay,
        children: [
          TextSpan(text: lead),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Text(
                  highlight,
                  style: AppTextStyles.kTextDisplay.copyWith(
                    color: AppColors.kColorPrimary,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: -_kSwooshHeight / 2,
                  height: _kSwooshHeight,
                  child: CustomPaint(painter: _SwooshPainter(swoosh)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SwooshPainter extends CustomPainter {
  _SwooshPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress <= 0) return;
    final path = Path()
      ..moveTo(0, size.height * 0.7)
      ..cubicTo(
        size.width * 0.3,
        size.height * 1.1,
        size.width * 0.65,
        size.height * 0.1,
        size.width,
        size.height * 0.45,
      );
    final paint = Paint()
      ..color = AppColors.kColorAccent
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = AccentHeadline._kSwooshStroke;
    for (final PathMetric metric in path.computeMetrics()) {
      canvas.drawPath(metric.extractPath(0, metric.length * progress), paint);
    }
  }

  @override
  bool shouldRepaint(_SwooshPainter old) => old.progress != progress;
}
