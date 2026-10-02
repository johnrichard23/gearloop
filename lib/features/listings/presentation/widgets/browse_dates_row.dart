import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// A row in the filters sheet that shows the chosen dates and opens the dates
/// screen.
class BrowseDatesRow extends StatelessWidget {
  const BrowseDatesRow({required this.value, required this.onTap, super.key});

  /// "Oct 12-15", or null when no dates are chosen.
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Dates, ${value ?? 'any dates'}',
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
            vertical: AppSpacing.kSpacing16,
          ),
          decoration: BoxDecoration(
            color: AppColors.kColorSurface,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
            border: Border.all(color: AppColors.kColorBorder),
          ),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_outlined,
                size: AppSpacing.kIconMedium,
                color: AppColors.kColorPrimary,
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Expanded(
                child: Text('Dates', style: AppTextStyles.kTextBodyMedium),
              ),
              Text(
                value ?? 'Any dates',
                style: AppTextStyles.kTextBodyMedium.copyWith(
                  color: value == null
                      ? AppColors.kColorTextSecondary
                      : AppColors.kColorPrimary,
                  fontWeight: value == null ? FontWeight.w400 : FontWeight.w700,
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing4),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.kColorTextSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
