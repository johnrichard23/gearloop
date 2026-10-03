import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/domain/entities/listing_categories.dart';
import '../../../listings/domain/entities/listing_filter.dart';
import '../../../listings/presentation/providers/browse_providers.dart';
import '../../../listings/presentation/widgets/category_icons.dart';
import 'all_categories_sheet.dart';

/// Scrolling row of categories, each a solid circle with an icon. Tapping one
/// opens Browse on it. It follows [kListingCategories], so a new category only
/// needs an icon in `categoryIcon`. The last tile, "All", opens a sheet with
/// every category at once.
class HomeCategoryRow extends ConsumerWidget {
  const HomeCategoryRow({required this.onBrowseTap, super.key});

  final VoidCallback onBrowseTap;

  void _openAllCategories(BuildContext context, WidgetRef ref) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.kColorBackground,
      builder: (sheetContext) => AllCategoriesSheet(
        onPick: (category) {
          Navigator.of(sheetContext).pop();
          ref.read(browseCategoryProvider.notifier).state = category;
          onBrowseTap();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = kListingCategories.where(
      (category) => category != ListingFilter.allCategories,
    );
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.kSpacing16),
      child: Row(
        children: [
          for (final category in categories)
            _CategoryTile(
              label: category,
              icon: categoryIcon(category),
              onTap: () {
                ref.read(browseCategoryProvider.notifier).state = category;
                onBrowseTap();
              },
            ),
          _CategoryTile(
            label: 'All',
            icon: Icons.grid_view_rounded,
            isSeeAll: true,
            onTap: () => _openAllCategories(context, ref),
          ),
        ],
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isSeeAll = false,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  /// The "All" tile at the end: an outlined circle, so it reads as a way to
  /// see more and not as one more category.
  final bool isSeeAll;

  /// 64 + 8: wide enough for the longest label, and 4.5 tiles fit a phone so
  /// the next one peeks out and shows the row scrolls.
  static const double _kTileWidth =
      AppSpacing.kSpacing64 + AppSpacing.kSpacing8;

  /// 48 + 8: a solid circle big enough to read as the main way in.
  static const double _kCircleSize =
      AppSpacing.kSpacing48 + AppSpacing.kSpacing8;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _kTileWidth,
      child: Semantics(
        button: true,
        label: label,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
            highlightColor: AppColors.kColorPrimaryFaded,
            splashColor: AppColors.kColorPrimaryFaded,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.kSpacing4,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: _kCircleSize,
                    height: _kCircleSize,
                    decoration: BoxDecoration(
                      color: isSeeAll
                          ? AppColors.kColorSurface
                          : AppColors.kColorPrimary,
                      shape: BoxShape.circle,
                      border: isSeeAll
                          ? Border.all(color: AppColors.kColorBorderDark)
                          : null,
                    ),
                    child: Icon(
                      icon,
                      size: AppSpacing.kIconLarge,
                      color: isSeeAll
                          ? AppColors.kColorPrimary
                          : AppColors.kColorOnPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.kSpacing8),
                  Text(
                    label,
                    style: AppTextStyles.kTextLabel.copyWith(
                      color: AppColors.kColorTextPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
