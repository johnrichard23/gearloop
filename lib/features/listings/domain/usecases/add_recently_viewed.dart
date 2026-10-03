/// Puts [listingId] at the top of the recently viewed listings. Opening one
/// again moves it up instead of listing it twice, and only the newest
/// [maxListings] are kept.
class AddRecentlyViewed {
  const AddRecentlyViewed();

  static const int maxListings = 3;

  List<String> call(List<String> current, String listingId) {
    if (listingId.isEmpty) {
      return current;
    }
    final others = current.where((id) => id != listingId);
    return [listingId, ...others].take(maxListings).toList();
  }
}
