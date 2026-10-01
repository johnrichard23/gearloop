import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// White raised surface used by cards and chips inside onboarding scenes.
BoxDecoration sceneCardDecoration(double radius) => BoxDecoration(
  color: AppColors.kColorSurface,
  borderRadius: BorderRadius.circular(radius),
  boxShadow: [
    BoxShadow(
      color: AppColors.kColorTextPrimary.withValues(alpha: 0.12),
      blurRadius: AppSpacing.kSpacing12,
      offset: const Offset(0, AppSpacing.kSpacing4),
    ),
  ],
);

/// The teal dot every scene grows out of and collapses back into. It is only
/// visible while the scene is small (low [growth]).
class SceneOriginDot extends StatelessWidget {
  const SceneOriginDot({required this.growth, super.key});

  final double growth;

  static const double _kSize = 18;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: (1 - growth * 2).clamp(0.0, 1.0),
      child: Container(
        width: _kSize,
        height: _kSize,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}
