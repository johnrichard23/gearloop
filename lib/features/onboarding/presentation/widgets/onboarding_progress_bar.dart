import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Full-width segmented progress for the onboarding carousel.
///
/// Segments before [index] are full, the segment at [index] is filled to
/// [fill] (0–1), and later segments are empty.
class OnboardingProgressBar extends StatelessWidget {
  const OnboardingProgressBar({
    required this.count,
    required this.index,
    required this.fill,
    super.key,
  });

  final int count;
  final int index;
  final double fill;

  static const double _kSegmentHeight = 4;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step ${index + 1} of $count',
      child: Row(
        children: [
          for (var i = 0; i < count; i++)
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: i == 0 ? 0 : AppSpacing.kSpacing4,
                ),
                child: _Segment(value: _valueFor(i)),
              ),
            ),
        ],
      ),
    );
  }

  double _valueFor(int segment) {
    if (segment < index) return 1;
    if (segment == index) return fill.clamp(0.0, 1.0);
    return 0;
  }
}

class _Segment extends StatelessWidget {
  const _Segment({required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
      child: SizedBox(
        height: OnboardingProgressBar._kSegmentHeight,
        child: Stack(
          children: [
            const Positioned.fill(
              child: ColoredBox(color: AppColors.kColorBorder),
            ),
            Positioned.fill(
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: const ColoredBox(color: AppColors.kColorPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
