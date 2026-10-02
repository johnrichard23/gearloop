import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The single search field. Filters the loaded listings by title or category.
class BrowseSearchField extends StatelessWidget {
  const BrowseSearchField({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      style: AppTextStyles.kTextBodyMedium,
      decoration: InputDecoration(
        hintText: 'Search gear near you',
        hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorTextHint,
        ),
        prefixIcon: const Icon(
          Icons.search,
          color: AppColors.kColorTextSecondary,
        ),
        filled: true,
        fillColor: AppColors.kColorSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: 13,
        ),
        border: _pillBorder(AppColors.kColorBorder),
        enabledBorder: _pillBorder(AppColors.kColorBorder),
        focusedBorder: _pillBorder(AppColors.kColorPrimary),
      ),
    );
  }

  static OutlineInputBorder _pillBorder(Color color) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(AppSpacing.kRadiusCircular),
    borderSide: BorderSide(color: color),
  );
}
