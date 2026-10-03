import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/data/repositories/recently_viewed_repository_impl.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<RecentlyViewedRepositoryImpl> build([
    Map<String, Object> values = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(values);
    return RecentlyViewedRepositoryImpl(await SharedPreferences.getInstance());
  }

  test('load returns an empty list when nothing is saved', () async {
    expect((await build()).load(), isEmpty);
  });

  test('save then load returns the same ids in order', () async {
    final repository = await build();
    expect(await repository.save(['b', 'a']), isTrue);
    expect(repository.load(), ['b', 'a']);
  });
}
