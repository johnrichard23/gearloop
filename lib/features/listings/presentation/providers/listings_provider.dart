import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/listings_repository_impl.dart';
import '../../domain/entities/listing_entity.dart';

/// Default search origin: Sorsogon City (until device location is wired).
const double kDefaultListingsLat = 12.9734;
const double kDefaultListingsLng = 124.0067;
const double kDefaultListingsRadiusKm = 25;

class ListingsNotifier extends AsyncNotifier<List<ListingEntity>> {
  @override
  Future<List<ListingEntity>> build() => _fetchListings();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_fetchListings);
  }

  Future<List<ListingEntity>> _fetchListings() async {
    final repository = ListingsRepositoryImpl();
    final result = await repository.getListingsByLocation(
      lat: kDefaultListingsLat,
      lng: kDefaultListingsLng,
      radiusKm: kDefaultListingsRadiusKm,
    );

    return result.fold(
      (failure) => throw failure,
      (listings) => listings,
    );
  }
}

final listingsProvider =
    AsyncNotifierProvider<ListingsNotifier, List<ListingEntity>>(
  ListingsNotifier.new,
);
