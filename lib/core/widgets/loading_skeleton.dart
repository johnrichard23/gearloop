import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/app_spacing.dart';

/// Placeholder box while content loads (simple grey block, no shimmer yet).
class LoadingSkeleton extends StatelessWidget {
  const LoadingSkeleton({
    required this.width,
    required this.height,
    this.radius = AppSpacing.kRadiusMedium,
    super.key,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.kColorBorder,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
