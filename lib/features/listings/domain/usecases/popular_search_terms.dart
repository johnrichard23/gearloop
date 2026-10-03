import '../entities/listing_entity.dart';

/// The categories renters near them are most likely to want, worked out from
/// the loaded listings: most reviews first, then most listings, then A to Z.
/// Categories with no listings are left out, so a tap always finds something.
class PopularSearchTerms {
  const PopularSearchTerms();

  static const int maxTerms = 6;

  List<String> call(List<ListingEntity> listings) {
    final reviews = <String, int>{};
    final counts = <String, int>{};
    for (final listing in listings) {
      reviews.update(
        listing.category,
        (total) => total + listing.reviewCount,
        ifAbsent: () => listing.reviewCount,
      );
      counts.update(listing.category, (n) => n + 1, ifAbsent: () => 1);
    }
    final categories = counts.keys.toList()
      ..sort((a, b) {
        final byReviews = reviews[b]!.compareTo(reviews[a]!);
        if (byReviews != 0) {
          return byReviews;
        }
        final byCount = counts[b]!.compareTo(counts[a]!);
        return byCount != 0 ? byCount : a.compareTo(b);
      });
    return categories.take(maxTerms).toList();
  }
}
