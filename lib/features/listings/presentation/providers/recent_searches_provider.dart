import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../onboarding/presentation/providers/onboarding_provider.dart';
import '../../data/repositories/recent_searches_repository_impl.dart';
import '../../domain/repositories/recent_searches_repository.dart';
import '../../domain/usecases/add_recent_search.dart';
import '../../domain/usecases/remove_recent_search.dart';

final recentSearchesRepositoryProvider = Provider<RecentSearchesRepository>(
  (ref) => RecentSearchesRepositoryImpl(ref.watch(sharedPreferencesProvider)),
);

/// The recent searches, newest first. Changes show at once; saving to the
/// phone happens behind them.
class RecentSearchesNotifier extends StateNotifier<List<String>> {
  RecentSearchesNotifier(
    this._repository, {
    this.addSearch = const AddRecentSearch(),
    this.removeSearch = const RemoveRecentSearch(),
  }) : super(_repository.load().take(AddRecentSearch.maxSearches).toList());

  final RecentSearchesRepository _repository;
  final AddRecentSearch addSearch;
  final RemoveRecentSearch removeSearch;

  void add(String query) => _update(addSearch(state, query));

  void remove(String query) => _update(removeSearch(state, query));

  void clear() => _update(const []);

  void _update(List<String> searches) {
    state = searches;
    unawaited(_repository.save(searches));
  }
}

final recentSearchesProvider =
    StateNotifierProvider<RecentSearchesNotifier, List<String>>(
      (ref) =>
          RecentSearchesNotifier(ref.watch(recentSearchesRepositoryProvider)),
    );
