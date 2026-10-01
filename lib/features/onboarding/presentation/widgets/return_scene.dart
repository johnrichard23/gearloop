import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'scene_parts.dart';
import 'scene_timing.dart';

/// Onboarding slide 3 visual: Rent → Use → Return as three zig-zag step cards.
/// [progress] is the slide's 0–1 timeline: each card drops in and lights up
/// in turn (0.18, 0.38, 0.58), dotted connectors draw between them, a
/// "deposit back" chip lands on the last step (0.72), and from 0.85 the scene
/// collapses into the centre point.
class ReturnScene extends StatelessWidget {
  const ReturnScene({required this.progress, super.key});

  final double progress;

  static const double _kDesignWidth = 360;
  static const double _kDesignHeight = 340;
  static const double _kCardWidth = 224;
  static const double _kCardHeight = 72;
  static const double _kCardDrop = 0.1;
  static const double _kActivateAfter = 0.06;
  static const double _kIconSize = 44;

  static const List<_Step> _steps = [
    _Step(
      icon: Icons.event_available,
      title: 'Rent',
      subtitle: 'Pick your dates',
      offset: Offset(0, 0),
      start: 0.18,
    ),
    _Step(
      icon: Icons.photo_camera,
      title: 'Use',
      subtitle: 'Pick up & enjoy',
      offset: Offset(136, 108),
      start: 0.38,
    ),
    _Step(
      icon: Icons.assignment_return,
      title: 'Return',
      subtitle: 'Bring it back',
      offset: Offset(0, 216),
      start: 0.58,
    ),
  ];

  static const List<_Link> _links = [
    _Link(
      from: Offset(112, 72),
      control1: Offset(112, 96),
      control2: Offset(248, 84),
      to: Offset(248, 108),
      start: 0.28,
    ),
    _Link(
      from: Offset(248, 180),
      control1: Offset(248, 204),
      control2: Offset(112, 192),
      to: Offset(112, 216),
      start: 0.48,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final t = progress;
    final growth = sceneGrowth(t);
    return ExcludeSemantics(
      child: Padding(
        padding: const EdgeInsets.only(bottom: sceneCloudClearance),
        child: Stack(
          alignment: Alignment.center,
          children: [
            SceneOriginDot(growth: growth),
            Transform.scale(
              scale: growth,
              child: FittedBox(
                child: SizedBox(
                  width: _kDesignWidth,
                  height: _kDesignHeight,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        child: CustomPaint(painter: _LinksPainter(_links, t)),
                      ),
                      for (final step in _steps) _buildStep(step, t),
                      _buildRefund(t),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(_Step step, double t) {
    final drop = sceneInterval(
      t,
      step.start,
      step.start + _kCardDrop,
      Curves.easeOutBack,
    );
    final active = sceneInterval(
      t,
      step.start + _kActivateAfter,
      step.start + _kActivateAfter + 0.05,
      Curves.easeInOut,
    );
    return Positioned(
      left: step.offset.dx,
      top: step.offset.dy,
      child: Opacity(
        opacity: drop.clamp(0.0, 1.0),
        child: Transform.translate(
          offset: Offset(0, -14 * (1 - drop)),
          child: Transform.scale(
            scale: 0.9 + 0.1 * drop,
            child: _StepCard(step: step, active: active),
          ),
        ),
      ),
    );
  }

  Widget _buildRefund(double t) {
    final pop = sceneInterval(t, 0.72, 0.8, Curves.easeOutBack);
    return Positioned(
      left: 12,
      top: 298,
      child: Opacity(
        opacity: pop.clamp(0.0, 1.0),
        child: Transform.scale(
          scale: pop,
          alignment: Alignment.centerLeft,
          child: const _RefundChip(),
        ),
      ),
    );
  }
}

class _Step {
  const _Step({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.offset,
    required this.start,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Offset offset;
  final double start;
}

class _Link {
  const _Link({
    required this.from,
    required this.control1,
    required this.control2,
    required this.to,
    required this.start,
  });

  final Offset from;
  final Offset control1;
  final Offset control2;
  final Offset to;
  final double start;
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step, required this.active});

  final _Step step;

  /// 0 = waiting, 1 = reached.
  final double active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ReturnScene._kCardWidth,
      height: ReturnScene._kCardHeight,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.kSpacing12),
      decoration: sceneCardDecoration(AppSpacing.kRadiusLarge),
      child: Row(
        children: [
          Container(
            width: ReturnScene._kIconSize,
            height: ReturnScene._kIconSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Color.lerp(
                AppColors.kColorPrimaryFaded,
                AppColors.kColorPrimary,
                active,
              ),
            ),
            child: Icon(
              step.icon,
              color: Color.lerp(
                AppColors.kColorPrimary,
                AppColors.kColorOnPrimary,
                active,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(step.title, style: AppTextStyles.kTextHeading3),
                Text(step.subtitle, style: AppTextStyles.kTextBodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RefundChip extends StatelessWidget {
  const _RefundChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing12,
        vertical: AppSpacing.kSpacing8,
      ),
      decoration: sceneCardDecoration(AppSpacing.kRadiusCircular),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle,
            size: AppSpacing.kIconSmall,
            color: AppColors.kColorSuccess,
          ),
          const SizedBox(width: AppSpacing.kSpacing4),
          Text(
            '₱5,000 deposit back',
            style: AppTextStyles.kTextLabel.copyWith(
              color: AppColors.kColorTextPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Draws each [_Link] as a dotted curve that reveals itself from its start
/// time over a short interval.
class _LinksPainter extends CustomPainter {
  _LinksPainter(this.links, this.t);

  final List<_Link> links;
  final double t;

  static const double _kDraw = 0.1;
  static const double _kDash = 4;
  static const double _kGap = 5;
  static const double _kStroke = 2.5;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.kColorPrimary.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = _kStroke;
    for (final link in links) {
      final reveal = sceneInterval(
        t,
        link.start,
        link.start + _kDraw,
        Curves.easeInOut,
      );
      if (reveal <= 0) continue;
      final path = Path()
        ..moveTo(link.from.dx, link.from.dy)
        ..cubicTo(
          link.control1.dx,
          link.control1.dy,
          link.control2.dx,
          link.control2.dy,
          link.to.dx,
          link.to.dy,
        );
      final metric = path.computeMetrics().first;
      final end = metric.length * reveal;
      for (var d = 0.0; d < end; d += _kDash + _kGap) {
        canvas.drawPath(
          metric.extractPath(d, math.min(d + _kDash, end)),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_LinksPainter old) => old.t != t;
}
