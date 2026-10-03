import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Search field that looks like a text field but only opens the search screen
/// when tapped. Shows the current [query] with a clear button, so it is
/// always clear why results are filtered.
class SearchEntryField extends StatelessWidget {
  const SearchEntryField({
    required this.onTap,
    this.query = '',
    this.onClear,
    super.key,
  });

  final VoidCallback onTap;
  final String query;

  /// Called by the clear button, which only shows while [query] is not empty.
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final hasQuery = query.isNotEmpty;
    return Semantics(
      button: true,
      label: hasQuery ? 'Search: $query' : 'Search gear near you',
      child: Material(
        color: AppColors.kColorSurface,
        shape: const StadiumBorder(
          side: BorderSide(color: AppColors.kColorBorder),
        ),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: onTap,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
            child: Row(
              children: [
                const SizedBox(width: AppSpacing.kSpacing16),
                const Icon(
                  Icons.search,
                  size: AppSpacing.kIconMedium,
                  color: AppColors.kColorTextSecondary,
                ),
                const SizedBox(width: AppSpacing.kSpacing12),
                Expanded(
                  child: Text(
                    hasQuery ? query : 'Search gear near you',
                    style: AppTextStyles.kTextBodyMedium.copyWith(
                      color: hasQuery
                          ? AppColors.kColorTextPrimary
                          : AppColors.kColorTextHint,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasQuery && onClear != null)
                  IconButton(
                    tooltip: 'Clear search',
                    onPressed: onClear,
                    icon: const Icon(
                      Icons.close,
                      size: AppSpacing.kIconMedium,
                      color: AppColors.kColorTextSecondary,
                    ),
                  )
                else
                  const SizedBox(width: AppSpacing.kSpacing16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
