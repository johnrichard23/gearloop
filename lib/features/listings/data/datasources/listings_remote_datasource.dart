import '../models/listing_model.dart';

/// Remote listing operations (Supabase implementation later).
abstract interface class ListingsRemoteDatasource {
  Future<ListingModel> createListing(ListingModel listing);

  Future<ListingModel> getListingById(String id);

  Future<List<ListingModel>> getListingsByLocation(
    double lat,
    double lng,
    double radiusKm,
  );

  Future<ListingModel> updateListing(ListingModel listing);

  Future<void> deleteListing(String id);

  Future<void> pauseListing(String id);
}

/// In-memory mock until Supabase is connected.
class ListingsRemoteDatasourceMock implements ListingsRemoteDatasource {
  final Map<String, ListingModel> _listings = {};

  @override
  Future<ListingModel> createListing(ListingModel listing) async {
    final id = listing.id.isEmpty
        ? 'listing-${DateTime.now().millisecondsSinceEpoch}'
        : listing.id;
    final saved = ListingModel(
      id: id,
      hostId: listing.hostId,
      title: listing.title,
      category: listing.category,
      pricePerDay: listing.pricePerDay,
      location: listing.location,
      hostName: listing.hostName,
      rating: listing.rating,
      isVerified: listing.isVerified,
      description: listing.description,
      reviewCount: listing.reviewCount,
      depositAmount: listing.depositAmount,
      minRentalDays: listing.minRentalDays,
      isActive: listing.isActive,
      isPaused: listing.isPaused,
      lat: listing.lat,
      lng: listing.lng,
    );
    _listings[id] = saved;
    return saved;
  }

  @override
  Future<ListingModel> getListingById(String id) async {
    final listing = _listings[id];
    if (listing == null) {
      throw Exception('Listing not found: $id');
    }
    return listing;
  }

  @override
  Future<List<ListingModel>> getListingsByLocation(
    double lat,
    double lng,
    double radiusKm,
  ) async {
    return _listings.values.toList();
  }

  @override
  Future<ListingModel> updateListing(ListingModel listing) async {
    if (!_listings.containsKey(listing.id)) {
      throw Exception('Listing not found: ${listing.id}');
    }
    _listings[listing.id] = listing;
    return listing;
  }

  @override
  Future<void> deleteListing(String id) async {
    if (_listings.remove(id) == null) {
      throw Exception('Listing not found: $id');
    }
  }

  @override
  Future<void> pauseListing(String id) async {
    final existing = _listings[id];
    if (existing == null) {
      throw Exception('Listing not found: $id');
    }
    final paused = ListingModel(
      id: existing.id,
      hostId: existing.hostId,
      title: existing.title,
      category: existing.category,
      pricePerDay: existing.pricePerDay,
      location: existing.location,
      hostName: existing.hostName,
      rating: existing.rating,
      isVerified: existing.isVerified,
      description: existing.description,
      reviewCount: existing.reviewCount,
      depositAmount: existing.depositAmount,
      minRentalDays: existing.minRentalDays,
      isActive: existing.isActive,
      isPaused: true,
      lat: existing.lat,
      lng: existing.lng,
    );
    _listings[id] = paused;
  }
}
