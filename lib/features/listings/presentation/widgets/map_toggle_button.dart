import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Floating pill that flips between the list and the map.
class MapToggleButton extends StatelessWidget {
  const MapToggleButton({
    required this.showingMap,
    required this.onTap,
    super.key,
  });

  final bool showingMap;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: showingMap ? 'Show list' : 'Show map',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing20,
            vertical: AppSpacing.kSpacing12,
          ),
          decoration: BoxDecoration(
            color: AppColors.kColorPrimary,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
            boxShadow: [
              BoxShadow(
                color: AppColors.kColorTextPrimary.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                showingMap ? Icons.view_agenda_outlined : Icons.map_outlined,
                size: AppSpacing.kIconMedium,
                color: AppColors.kColorOnPrimary,
              ),
              const SizedBox(width: AppSpacing.kSpacing8),
              Text(
                showingMap ? 'List' : 'Map',
                style: AppTextStyles.kTextLabel.copyWith(
                  color: AppColors.kColorOnPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
