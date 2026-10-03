import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/data/repositories/recent_searches_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<RecentSearchesRepositoryImpl> build([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return RecentSearchesRepositoryImpl(await SharedPreferences.getInstance());
  }

  test('load returns an empty list when nothing is saved', () async {
    final repository = await build();
    expect(repository.load(), isEmpty);
  });

  test('save then load returns the same searches in order', () async {
    final repository = await build();
    expect(await repository.save(['drone', 'tent']), isTrue);
    expect(repository.load(), ['drone', 'tent']);
  });

  test('load reads what an earlier run saved', () async {
    final repository = await build({
      RecentSearchesRepositoryImpl.searchesKey: ['camera'],
    });
    expect(repository.load(), ['camera']);
  });
}
