import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_spacing.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../domain/entities/listing_entity.dart';
import 'listing_card.dart';

/// Two-column grid of listing cards, or of skeletons while [listings] is null.
class ListingsGrid extends StatelessWidget {
  const ListingsGrid({
    required this.listings,
    required this.bottomPadding,
    this.isEmbedded = false,
    super.key,
  }) : skeletonCount = 0;

  /// A grid of placeholders for the loading state.
  const ListingsGrid.skeleton({
    required this.bottomPadding,
    this.isEmbedded = false,
    this.skeletonCount = 6,
    super.key,
  }) : listings = null;

  final List<ListingEntity>? listings;

  /// Space kept clear at the bottom for the floating bars.
  final double bottomPadding;

  /// Sizes the grid to its cards and leaves scrolling to the parent, for use
  /// inside another scroll view such as Home.
  final bool isEmbedded;

  /// How many placeholders the skeleton grid shows.
  final int skeletonCount;

  @override
  Widget build(BuildContext context) {
    final items = listings;
    return GridView.builder(
      shrinkWrap: isEmbedded,
      physics: isEmbedded ? const NeverScrollableScrollPhysics() : null,
      padding: EdgeInsets.fromLTRB(
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing16 + bottomPadding,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.kSpacing12,
        mainAxisSpacing: AppSpacing.kSpacing12,
        mainAxisExtent: ListingCard.heightFor(context),
      ),
      itemCount: items?.length ?? skeletonCount,
      itemBuilder: (context, index) {
        if (items == null) {
          return const LoadingSkeleton(
            width: double.infinity,
            height: double.infinity,
          );
        }
        final listing = items[index];
        return ListingCard(
          listing: listing,
          onTap: () => context.push('/listing/${listing.id}', extra: listing),
        );
      },
    );
  }
}
