import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/listing_entity.dart';

/// One recently viewed listing: a small photo, its title and the daily price.
class RecentlyViewedRow extends StatelessWidget {
  const RecentlyViewedRow({
    required this.listing,
    required this.onTap,
    super.key,
  });

  final ListingEntity listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.kSpacing4),
        child: Row(
          children: [
            _Thumbnail(url: listing.photoUrls.firstOrNull),
            const SizedBox(width: AppSpacing.kSpacing12),
            Expanded(
              child: Text(
                listing.title,
                style: AppTextStyles.kTextBodyMedium,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Text.rich(
              TextSpan(
                text: listing.pricePerDay,
                style: AppTextStyles.kTextPriceSmall,
                children: [
                  TextSpan(text: '/day', style: AppTextStyles.kTextBodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({required this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    const placeholder = ColoredBox(
      color: AppColors.kColorSurfaceVariant,
      child: Icon(
        Icons.camera_alt_outlined,
        size: AppSpacing.kIconMedium,
        color: AppColors.kColorTextHint,
      ),
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: SizedBox(
        width: AppSpacing.kSpacing48,
        height: AppSpacing.kSpacing48,
        child: url == null
            ? placeholder
            : Image.network(
                url!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => placeholder,
              ),
      ),
    );
  }
}
