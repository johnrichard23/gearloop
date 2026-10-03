/// Remembers which listings this device opened, newest first. Nothing leaves
/// the phone.
abstract interface class RecentlyViewedRepository {
  /// The ids of the viewed listings, newest first. Empty if none or unreadable.
  List<String> load();

  /// Replaces the saved ids. Returns `false` if they could not be saved;
  /// callers carry on, the history just won't survive a restart.
  Future<bool> save(List<String> listingIds);
}
