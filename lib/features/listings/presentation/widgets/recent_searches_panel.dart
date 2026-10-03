import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// Short list of past searches under the search field. Tap a row to search
/// again, the cross removes it, "Clear all" empties the list.
class RecentSearchesPanel extends StatelessWidget {
  const RecentSearchesPanel({
    required this.searches,
    required this.onSelect,
    required this.onRemove,
    required this.onClearAll,
    super.key,
  });

  final List<String> searches;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.kColorSurface,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
        border: Border.all(color: AppColors.kColorBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          for (final search in searches)
            _RecentSearchRow(
              search: search,
              onSelect: () => onSelect(search),
              onRemove: () => onRemove(search),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: AppSpacing.kSpacing16),
      child: Row(
        children: [
          Expanded(
            child: Text('Recent searches', style: AppTextStyles.kTextLabel),
          ),
          TextButton(
            onPressed: onClearAll,
            style: TextButton.styleFrom(
              minimumSize: const Size(
                AppSpacing.kSpacing48,
                AppSpacing.kSpacing48,
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.kSpacing16,
              ),
            ),
            child: Text(
              'Clear all',
              style: AppTextStyles.kTextBodySmall.copyWith(
                color: AppColors.kColorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSearchRow extends StatelessWidget {
  const _RecentSearchRow({
    required this.search,
    required this.onSelect,
    required this.onRemove,
  });

  final String search;
  final VoidCallback onSelect;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onSelect,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: AppSpacing.kSpacing48),
        child: Row(
          children: [
            const SizedBox(width: AppSpacing.kSpacing16),
            const Icon(
              Icons.history,
              size: AppSpacing.kIconMedium,
              color: AppColors.kColorTextSecondary,
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Expanded(
              child: Text(
                search,
                style: AppTextStyles.kTextBodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            IconButton(
              tooltip: 'Remove $search',
              onPressed: onRemove,
              icon: const Icon(
                Icons.close,
                size: AppSpacing.kIconMedium,
                color: AppColors.kColorTextSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
