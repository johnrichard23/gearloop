import '../entities/listing_categories.dart';
import '../entities/listing_entity.dart';
import '../entities/listing_filter.dart';

/// Ideas shown while typing: categories and listing titles that contain what
/// has been typed so far.
class SearchSuggestions {
  const SearchSuggestions({this.categories = const [], this.titles = const []});

  final List<String> categories;
  final List<String> titles;

  bool get isEmpty => categories.isEmpty && titles.isEmpty;
}

/// Works out [SearchSuggestions] from the loaded listings, ignoring case.
class SuggestSearches {
  const SuggestSearches();

  static const int maxTitles = 4;

  SearchSuggestions call(List<ListingEntity> listings, String query) {
    final needle = query.trim().toLowerCase();
    if (needle.isEmpty) {
      return const SearchSuggestions();
    }
    final categories = kListingCategories.where(
      (category) =>
          category != ListingFilter.allCategories &&
          category.toLowerCase().contains(needle),
    );
    final titles = <String>{
      for (final listing in listings)
        if (listing.title.toLowerCase().contains(needle)) listing.title,
    };
    return SearchSuggestions(
      categories: categories.toList(),
      titles: titles.take(maxTitles).toList(),
    );
  }
}
