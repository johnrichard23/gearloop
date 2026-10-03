import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Tappable search field that opens Browse, where the typing happens.
class HomeSearchPill extends StatelessWidget {
  const HomeSearchPill({required this.onTap, super.key});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search cameras, drones, gear',
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
          ),
          decoration: BoxDecoration(
            color: AppColors.kColorSurface,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
            border: Border.all(color: AppColors.kColorBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.search,
                size: AppSpacing.kIconMedium,
                color: AppColors.kColorTextSecondary,
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Text(
                'Search cameras, drones, gear...',
                style: AppTextStyles.kTextBodyMedium.copyWith(
                  color: AppColors.kColorTextHint,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
