import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import 'onboarding_progress_bar.dart';

/// The top of the onboarding screen: the segmented progress bar and, until the
/// last slide, a Skip link.
class OnboardingTopBar extends StatelessWidget {
  const OnboardingTopBar({
    required this.animation,
    required this.fill,
    required this.count,
    required this.index,
    required this.showSkip,
    required this.onSkip,
    super.key,
  });

  /// Total height, so the screen can leave room for it.
  static const double height = 64;

  static const Duration _kSwap = Duration(milliseconds: 300);

  /// Rebuilds the progress bar as this animation ticks.
  final Listenable animation;

  /// Current fill (0–1) of the active segment.
  final double Function() fill;
  final int count;
  final int index;
  final bool showSkip;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AnimatedBuilder(
          animation: animation,
          builder: (context, _) =>
              OnboardingProgressBar(count: count, index: index, fill: fill()),
        ),
        SizedBox(
          height: height - AppSpacing.kSpacing16,
          child: Align(
            alignment: Alignment.centerRight,
            child: AnimatedOpacity(
              duration: _kSwap,
              opacity: showSkip ? 1 : 0,
              child: IgnorePointer(
                ignoring: !showSkip,
                child: TextButton(
                  onPressed: onSkip,
                  child: Text(
                    'Skip',
                    style: AppTextStyles.kTextButton.copyWith(
                      color: AppColors.kColorTextSecondary,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
