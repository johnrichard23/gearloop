/// Puts [query] at the top of the recent searches. A repeat of an earlier
/// search (ignoring case) moves up instead of appearing twice, and only the
/// newest [maxSearches] are kept.
class AddRecentSearch {
  const AddRecentSearch();

  static const int maxSearches = 3;

  List<String> call(List<String> current, String query) {
    final cleaned = query.trim();
    if (cleaned.isEmpty) {
      return current;
    }
    final others = current.where(
      (search) => search.toLowerCase() != cleaned.toLowerCase(),
    );
    return [cleaned, ...others].take(maxSearches).toList();
  }
}
