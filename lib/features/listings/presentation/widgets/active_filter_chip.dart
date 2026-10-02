import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The category currently applied, with a clear button.
class ActiveFilterChip extends StatelessWidget {
  const ActiveFilterChip({
    required this.label,
    required this.onClear,
    super.key,
  });

  final String label;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Clear $label filter',
      child: GestureDetector(
        onTap: onClear,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing12,
            vertical: AppSpacing.kSpacing8,
          ),
          decoration: BoxDecoration(
            color: AppColors.kColorPrimary,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: AppTextStyles.kTextLabel.copyWith(
                  color: AppColors.kColorOnPrimary,
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing8),
              const Icon(
                Icons.close_rounded,
                size: AppSpacing.kIconSmall,
                color: AppColors.kColorOnPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
