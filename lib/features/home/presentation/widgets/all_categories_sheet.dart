import 'package:flutter/material.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/domain/entities/listing_categories.dart';
import '../../../listings/domain/entities/listing_filter.dart';
import '../../../listings/presentation/widgets/category_choice_chip.dart';
import '../../../listings/presentation/widgets/category_icons.dart';

/// Bottom sheet listing every category at once, for when the scrolling row
/// on Home is too long to browse. Picking one calls [onPick].
class AllCategoriesSheet extends StatelessWidget {
  const AllCategoriesSheet({required this.onPick, super.key});

  final ValueChanged<String> onPick;

  @override
  Widget build(BuildContext context) {
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
            Text('All categories', style: AppTextStyles.kTextHeading4),
            const SizedBox(height: AppSpacing.kSpacing12),
            Wrap(
              spacing: AppSpacing.kSpacing8,
              runSpacing: AppSpacing.kSpacing8,
              children: [
                for (final category in kListingCategories)
                  if (category != ListingFilter.allCategories)
                    CategoryChoiceChip(
                      label: category,
                      icon: categoryIcon(category),
                      isSelected: false,
                      onTap: () => onPick(category),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
