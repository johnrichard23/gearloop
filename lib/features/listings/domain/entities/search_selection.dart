import 'listing_filter.dart';

/// What the renter picked on the search screen: words to search for, or one
/// category to browse, which Browse then applies as its filter.
class SearchSelection {
  const SearchSelection({
    this.query = '',
    this.category = ListingFilter.allCategories,
  });

  final String query;
  final String category;
}
