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
    this.icon,
    super.key,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  /// Small icon before the label, when the chip stands for a category.
  final IconData? icon;

  Color get _foreground =>
      isSelected ? AppColors.kColorOnPrimary : AppColors.kColorTextPrimary;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
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
          // Centered at its own width: the chip is at least 48dp tall but
          // never stretches wider than its label.
          child: Center(
            widthFactor: 1,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: AppSpacing.kIconSmall, color: _foreground),
                  const SizedBox(width: AppSpacing.kSpacing8),
                ],
                Text(
                  label,
                  style: AppTextStyles.kTextLabel.copyWith(color: _foreground),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
