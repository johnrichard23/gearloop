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
    super.key,
  });

  /// A grid of placeholders for the loading state.
  const ListingsGrid.skeleton({required this.bottomPadding, super.key})
    : listings = null;

  final List<ListingEntity>? listings;

  /// Space kept clear at the bottom for the floating bars.
  final double bottomPadding;

  static const int _kSkeletonCount = 6;

  @override
  Widget build(BuildContext context) {
    final items = listings;
    return GridView.builder(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing8,
        AppSpacing.kSpacing16,
        AppSpacing.kSpacing16 + bottomPadding,
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppSpacing.kSpacing12,
        mainAxisSpacing: AppSpacing.kSpacing12,
        mainAxisExtent: 290,
      ),
      itemCount: items?.length ?? _kSkeletonCount,
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
