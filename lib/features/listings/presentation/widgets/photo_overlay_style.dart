import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';

/// Lift for chips and buttons that sit on a listing photo, so they stay
/// visible on bright or busy images. Uses the styleguide's overlay shadow
/// numbers; move to an elevation token when one exists.
final List<BoxShadow> kPhotoChipShadow = [
  BoxShadow(
    color: AppColors.kColorTextPrimary.withValues(alpha: 0.12),
    blurRadius: AppSpacing.kSpacing16,
    offset: const Offset(0, AppSpacing.kSpacing4),
  ),
];

/// Soft dark fade along the top edge of a listing photo. Keeps the chips
/// readable on a bright sky or a white background without hiding the photo.
class PhotoTopScrim extends StatelessWidget {
  const PhotoTopScrim({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      height: AppSpacing.kSpacing64,
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.kColorTextPrimary.withValues(alpha: 0.35),
                AppColors.kColorTextPrimary.withValues(alpha: 0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
