/// Remembers what this device searched for, newest first. Nothing leaves the
/// phone.
abstract interface class RecentSearchesRepository {
  /// The saved searches, newest first. Empty if none or unreadable.
  List<String> load();

  /// Replaces the saved searches. Returns `false` if they could not be saved;
  /// callers carry on, the history just won't survive a restart.
  Future<bool> save(List<String> searches);
}
