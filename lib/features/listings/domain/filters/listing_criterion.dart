import '../entities/listing_entity.dart';

/// One condition a listing must meet to appear in the results.
abstract interface class ListingCriterion {
  bool matches(ListingEntity listing);
}

/// Listing belongs to [category].
class CategoryCriterion implements ListingCriterion {
  const CategoryCriterion(this.category);

  final String category;

  @override
  bool matches(ListingEntity listing) => listing.category == category;
}

/// Listing title or category contains the search text, ignoring case.
class QueryCriterion implements ListingCriterion {
  QueryCriterion(String query) : _needle = query.trim().toLowerCase();

  final String _needle;

  @override
  bool matches(ListingEntity listing) =>
      listing.title.toLowerCase().contains(_needle) ||
      listing.category.toLowerCase().contains(_needle);
}
