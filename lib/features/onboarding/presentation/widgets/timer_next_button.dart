import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// Round "next" button wrapped in a ring that fills as the slide plays.
class TimerNextButton extends StatelessWidget {
  const TimerNextButton({required this.fill, required this.onTap, super.key});

  /// 0–1 progress of the current slide.
  final double fill;
  final VoidCallback onTap;

  static const double _kSize = 64;
  static const double _kInnerSize = 52;
  static const double _kRingStroke = 3;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Next',
      child: SizedBox(
        width: _kSize,
        height: _kSize,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned.fill(child: CustomPaint(painter: _RingPainter(fill))),
            Material(
              color: AppColors.kColorPrimary,
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: onTap,
                child: const SizedBox(
                  width: _kInnerSize,
                  height: _kInnerSize,
                  child: Icon(
                    Icons.arrow_forward,
                    color: AppColors.kColorOnPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RingPainter extends CustomPainter {
  _RingPainter(this.fill);

  final double fill;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final inset = rect.deflate(TimerNextButton._kRingStroke / 2);
    final track = Paint()
      ..color = AppColors.kColorSurface
      ..style = PaintingStyle.stroke
      ..strokeWidth = TimerNextButton._kRingStroke;
    canvas.drawArc(inset, 0, 2 * math.pi, false, track);
    final arc = Paint()
      ..color = AppColors.kColorPrimary
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = TimerNextButton._kRingStroke;
    canvas.drawArc(
      inset,
      -math.pi / 2,
      2 * math.pi * fill.clamp(0.0, 1.0),
      false,
      arc,
    );
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.fill != fill;
}
