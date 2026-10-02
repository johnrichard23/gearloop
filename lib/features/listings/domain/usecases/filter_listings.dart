import '../entities/listing_entity.dart';
import '../entities/listing_filter.dart';

/// Keeps the listings that meet every criterion of [filter].
class FilterListings {
  const FilterListings();

  List<ListingEntity> call(List<ListingEntity> listings, ListingFilter filter) {
    final criteria = filter.criteria;
    if (criteria.isEmpty) {
      return listings;
    }
    return listings
        .where((listing) => criteria.every((c) => c.matches(listing)))
        .toList();
  }
}
