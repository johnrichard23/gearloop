import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/recent_searches_repository.dart';

/// [RecentSearchesRepository] backed by [SharedPreferences].
class RecentSearchesRepositoryImpl implements RecentSearchesRepository {
  RecentSearchesRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  static const String searchesKey = 'recent_searches';

  @override
  List<String> load() {
    try {
      return _prefs.getStringList(searchesKey) ?? const [];
    } on Exception {
      return const [];
    }
  }

  @override
  Future<bool> save(List<String> searches) async {
    try {
      return await _prefs.setStringList(searchesKey, searches);
    } on Exception {
      return false;
    }
  }
}
