import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/listing_entity.dart';

/// Card for a single gear listing in browse grids.
class ListingCard extends StatelessWidget {
  const ListingCard({
    required this.listing,
    required this.onTap,
    super.key,
  });

  final ListingEntity listing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppColors.kColorSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          side: const BorderSide(color: AppColors.kColorBorder),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 140,
              color: AppColors.kColorSurfaceVariant,
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.kColorTextHint,
                  size: AppSpacing.kIconLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.kSpacing12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    listing.title,
                    style: AppTextStyles.kTextHeading4,
                    maxLines: 2,
                  ),
                  const SizedBox(height: AppSpacing.kSpacing8),
                  Row(
                    children: [
                      _CategoryChip(label: listing.category),
                      const SizedBox(width: AppSpacing.kSpacing8),
                      Expanded(
                        child: Text(
                          listing.location,
                          style: AppTextStyles.kTextCaption,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.kSpacing4),
                  Text(listing.hostName, style: AppTextStyles.kTextCaption),
                  const SizedBox(height: AppSpacing.kSpacing8),
                  Row(
                    children: [
                      Text(
                        '${listing.pricePerDay}/day',
                        style: AppTextStyles.kTextPrice,
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.star,
                        size: AppSpacing.kIconSmall,
                        color: AppColors.kColorWarning,
                      ),
                      const SizedBox(width: AppSpacing.kSpacing4),
                      Text(
                        listing.rating.toStringAsFixed(1),
                        style: AppTextStyles.kTextBodySmall,
                      ),
                    ],
                  ),
                  if (listing.isVerified) ...[
                    const SizedBox(height: AppSpacing.kSpacing8),
                    const _VerifiedChip(),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorSurfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(label, style: AppTextStyles.kTextLabel),
    );
  }
}

class _VerifiedChip extends StatelessWidget {
  const _VerifiedChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimaryFaded,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(
        'Verified ✓',
        style: AppTextStyles.kTextLabel.copyWith(
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}
