import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../date_selection/domain/entities/date_range_selection.dart';
import '../../../date_selection/presentation/date_range_label.dart';
import '../../domain/entities/listing_categories.dart';
import '../providers/browse_providers.dart';
import 'browse_dates_row.dart';
import 'category_choice_chip.dart';

/// Bottom sheet with the category choices and a row that opens the dates
/// screen. Price and distance will get their own screens too, so this sheet
/// stays short.
class BrowseFiltersSheet extends ConsumerWidget {
  const BrowseFiltersSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(browseCategoryProvider);
    final dates = ref.watch(browseDatesProvider);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.kSpacing20,
          0,
          AppSpacing.kSpacing20,
          AppSpacing.kSpacing16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category', style: AppTextStyles.kTextHeading4),
            const SizedBox(height: AppSpacing.kSpacing12),
            Wrap(
              spacing: AppSpacing.kSpacing8,
              runSpacing: AppSpacing.kSpacing8,
              children: [
                for (final category in kListingCategories)
                  CategoryChoiceChip(
                    label: category,
                    isSelected: category == selected,
                    onTap: () {
                      ref.read(browseCategoryProvider.notifier).state =
                          category;
                      Navigator.of(context).pop();
                    },
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.kSpacing24),
            BrowseDatesRow(
              value: dateRangeLabel(dates),
              onTap: () => _pickDates(context, ref, dates),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDates(
    BuildContext context,
    WidgetRef ref,
    DateRangeSelection current,
  ) async {
    final picked = await context.push<DateRangeSelection>(
      '/dates',
      extra: current,
    );
    if (picked != null) {
      ref.read(browseDatesProvider.notifier).state = picked;
    }
  }
}
