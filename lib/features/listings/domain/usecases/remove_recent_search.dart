/// Takes one search out of the recent searches.
class RemoveRecentSearch {
  const RemoveRecentSearch();

  List<String> call(List<String> current, String query) =>
      current.where((search) => search != query).toList();
}
