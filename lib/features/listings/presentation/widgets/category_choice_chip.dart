import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// A selectable category pill in the filters sheet.
class CategoryChoiceChip extends StatelessWidget {
  const CategoryChoiceChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
            vertical: AppSpacing.kSpacing12,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.kColorPrimary
                : AppColors.kColorSurface,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
            border: Border.all(
              color: isSelected
                  ? AppColors.kColorPrimary
                  : AppColors.kColorBorderDark,
            ),
          ),
          child: Text(
            label,
            style: AppTextStyles.kTextLabel.copyWith(
              color: isSelected
                  ? AppColors.kColorOnPrimary
                  : AppColors.kColorTextPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
