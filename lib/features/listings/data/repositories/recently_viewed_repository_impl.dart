import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/recently_viewed_repository.dart';

/// [RecentlyViewedRepository] backed by [SharedPreferences].
class RecentlyViewedRepositoryImpl implements RecentlyViewedRepository {
  RecentlyViewedRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String idsKey = 'recently_viewed_listing_ids';

  @override
  List<String> load() {
    try {
      return _prefs.getStringList(idsKey) ?? const [];
    } on Exception {
      return const [];
    }
  }

  @override
  Future<bool> save(List<String> listingIds) async {
    try {
      return await _prefs.setStringList(idsKey, listingIds);
    } on Exception {
      return false;
    }
  }
}
