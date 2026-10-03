import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/domain/entities/listing_categories.dart';
import '../../../listings/domain/entities/listing_filter.dart';
import '../../../listings/presentation/providers/browse_providers.dart';

/// Scrolling row of categories, each a solid circle with an icon. Tapping one
/// opens Browse on it. It follows [kListingCategories], so a new category only
/// needs an icon here.
class HomeCategoryRow extends ConsumerWidget {
  const HomeCategoryRow({required this.onBrowseTap, super.key});

  final VoidCallback onBrowseTap;

  static const Map<String, IconData> _icons = {
    'Cameras': Icons.camera_alt_outlined,
    'Drones': Icons.flight_outlined,
    'Audio': Icons.mic_outlined,
    'Lighting': Icons.lightbulb_outline,
    'Camping': Icons.cabin_outlined,
    'Sports': Icons.pedal_bike_outlined,
    'Adventure': Icons.surfing,
    'Tools': Icons.handyman_outlined,
    'Fashion': Icons.checkroom_outlined,
    'Utility': Icons.local_shipping_outlined,
    'Instruments': Icons.music_note_outlined,
    'Events': Icons.celebration_outlined,
  };

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
              icon: _icons[category] ?? Icons.category_outlined,
              onTap: () {
                ref.read(browseCategoryProvider.notifier).state = category;
                onBrowseTap();
              },
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
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

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
                    decoration: const BoxDecoration(
                      color: AppColors.kColorPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: AppSpacing.kIconLarge,
                      color: AppColors.kColorOnPrimary,
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
