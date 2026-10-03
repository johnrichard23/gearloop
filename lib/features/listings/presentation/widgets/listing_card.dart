import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/listing_entity.dart';
import 'favorite_heart_button.dart';
import 'photo_overlay_style.dart';

/// Card for a single gear listing in browse grids: photo with a heart, then
/// title with a verified tick, place, and the price with the rating.
class ListingCard extends StatelessWidget {
  const ListingCard({
    required this.listing,
    required this.onTap,
    super.key,
  });

  final ListingEntity listing;
  final VoidCallback onTap;

  static const double _kPhotoHeight = 128;

  /// Room the text block needs at normal text size: padding, title, place and
  /// the price row.
  static const double _kDetailsHeight = 100;

  /// Height a grid should give each card; the text part grows with the
  /// reader's text size so large type never overflows.
  static double heightFor(BuildContext context) {
    final textScale = MediaQuery.textScalerOf(context).scale(1);
    return _kPhotoHeight + _kDetailsHeight * textScale.clamp(1, 2);
  }

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
            _buildPhoto(),
            Expanded(child: _buildDetails()),
          ],
        ),
      ),
    );
  }

  /// "Rented" wins over "New": a rented listing is the more useful thing to
  /// know. Listings with no reviews yet are "New".
  Widget? get _statusPill {
    if (listing.isCurrentlyRented) {
      return const _StatusPill(
        label: 'Rented',
        background: AppColors.kColorWarningLight,
        foreground: AppColors.kColorWarning,
      );
    }
    if (listing.reviewCount == 0) {
      return const _StatusPill(
        label: 'New',
        background: AppColors.kColorSurface,
        foreground: AppColors.kColorPrimary,
      );
    }
    return null;
  }

  Widget _buildPhoto() {
    return SizedBox(
      height: _kPhotoHeight,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColoredBox(
            color: AppColors.kColorSurfaceVariant,
            child: listing.photoUrls.isNotEmpty
                ? _ListingNetworkImage(imageUrl: listing.photoUrls.first)
                : const Center(
                    child: Icon(
                      Icons.camera_alt_outlined,
                      color: AppColors.kColorTextHint,
                      size: AppSpacing.kIconLarge,
                    ),
                  ),
          ),
          const PhotoTopScrim(),
          if (_statusPill != null)
            Positioned(
              top: AppSpacing.kSpacing8,
              left: AppSpacing.kSpacing8,
              child: _statusPill!,
            ),
          const Positioned(top: 0, right: 0, child: FavoriteHeartButton()),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(height: AppSpacing.kSpacing4),
          Text(
            listing.location,
            style: AppTextStyles.kTextBodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          _buildPriceRow(),
        ],
      ),
    );
  }

  /// One-line title with a verified tick.
  Widget _buildTitle() {
    return Row(
      children: [
        Flexible(
          child: Text(
            listing.title,
            style: AppTextStyles.kTextHeading4,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (listing.isVerified) ...[
          const SizedBox(width: AppSpacing.kSpacing4),
          const Icon(
            Icons.verified,
            size: AppSpacing.kIconSmall,
            color: AppColors.kColorPrimary,
            semanticLabel: 'Verified host',
          ),
        ],
      ],
    );
  }

  /// Price on the left, rating on the right once there are reviews.
  Widget _buildPriceRow() {
    return Row(
      children: [
        Text.rich(
          TextSpan(
            text: listing.pricePerDay,
            style: AppTextStyles.kTextPriceSmall,
            children: [
              TextSpan(text: '/day', style: AppTextStyles.kTextBodySmall),
            ],
          ),
        ),
        if (listing.reviewCount > 0) ...[
          const SizedBox(width: AppSpacing.kSpacing8),
          Expanded(child: _buildRating()),
        ],
      ],
    );
  }

  Widget _buildRating() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(
          Icons.star,
          size: AppSpacing.kIconSmall,
          color: AppColors.kColorWarning,
        ),
        const SizedBox(width: AppSpacing.kSpacing4),
        Flexible(
          child: Text(
            '${listing.rating.toStringAsFixed(1)} (${listing.reviewCount})',
            style: AppTextStyles.kTextBodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

/// Small label on the photo's top left, such as "New" or "Rented".
class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
        boxShadow: kPhotoChipShadow,
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(color: foreground),
      ),
    );
  }
}

class _ListingNetworkImage extends StatelessWidget {
  const _ListingNetworkImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      width: double.infinity,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return Container(
          color: AppColors.kColorSurfaceVariant,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          color: AppColors.kColorSurfaceVariant,
          child: const Center(
            child: Icon(
              Icons.broken_image_outlined,
              color: AppColors.kColorTextHint,
            ),
          ),
        );
      },
    );
  }
}
