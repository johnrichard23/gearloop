import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import 'photo_overlay_style.dart';

/// Heart that sits on a listing photo. UI only for now: it toggles on screen
/// but nothing is saved until favourites are built.
class FavoriteHeartButton extends StatefulWidget {
  const FavoriteHeartButton({super.key});

  @override
  State<FavoriteHeartButton> createState() => _FavoriteHeartButtonState();
}

class _FavoriteHeartButtonState extends State<FavoriteHeartButton> {
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      toggled: _isFavorite,
      label: _isFavorite ? 'Remove from favourites' : 'Save to favourites',
      child: GestureDetector(
        onTap: () => setState(() => _isFavorite = !_isFavorite),
        behavior: HitTestBehavior.opaque,
        // 48dp target around a smaller circle.
        child: SizedBox(
          width: AppSpacing.kSpacing48,
          height: AppSpacing.kSpacing48,
          child: Center(
            child: Container(
              width: AppSpacing.kSpacing32,
              height: AppSpacing.kSpacing32,
              decoration: BoxDecoration(
                color: AppColors.kColorSurface,
                shape: BoxShape.circle,
                boxShadow: kPhotoChipShadow,
              ),
              child: Icon(
                _isFavorite ? Icons.favorite : Icons.favorite_border,
                size: AppSpacing.kIconMedium,
                color: AppColors.kColorPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
