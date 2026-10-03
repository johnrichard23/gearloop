import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../data/repositories/recently_viewed_repository_impl.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/repositories/recently_viewed_repository.dart';
import '../../domain/usecases/add_recently_viewed.dart';
import 'listings_provider.dart';

final recentlyViewedRepositoryProvider = Provider<RecentlyViewedRepository>(
  (ref) => RecentlyViewedRepositoryImpl(ref.watch(sharedPreferencesProvider)),
);

/// Ids of the listings the renter opened, newest first. Changes show at once;
/// saving to the phone happens behind them.
class RecentlyViewedNotifier extends StateNotifier<List<String>> {
  RecentlyViewedNotifier(
    this._repository, {
    this.addListing = const AddRecentlyViewed(),
  }) : super(_repository.load().take(AddRecentlyViewed.maxListings).toList());

  final RecentlyViewedRepository _repository;
  final AddRecentlyViewed addListing;

  void add(String listingId) {
    state = addListing(state, listingId);
    unawaited(_repository.save(state));
  }
}

final recentlyViewedProvider =
    StateNotifierProvider<RecentlyViewedNotifier, List<String>>(
      (ref) =>
          RecentlyViewedNotifier(ref.watch(recentlyViewedRepositoryProvider)),
    );

/// The recently viewed listings that are still in the loaded results, in the
/// order they were viewed. A listing that is gone or out of range is skipped.
final recentlyViewedListingsProvider = Provider<List<ListingEntity>>((ref) {
  final ids = ref.watch(recentlyViewedProvider);
  final listings = ref.watch(listingsProvider).valueOrNull ?? const [];
  final byId = {for (final listing in listings) listing.id: listing};
  return [
    for (final id in ids)
      if (byId[id] != null) byId[id]!,
  ];
});
