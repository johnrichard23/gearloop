import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/domain/usecases/add_recent_search.dart';
import 'package:rentra/features/listings/domain/usecases/remove_recent_search.dart';

void main() {
  const addSearch = AddRecentSearch();
  const removeSearch = RemoveRecentSearch();

  group('AddRecentSearch', () {
    test('puts the newest search first', () {
      expect(addSearch(['tent'], 'drone'), ['drone', 'tent']);
    });

    test('trims the query', () {
      expect(addSearch([], '  drone  '), ['drone']);
    });

    test('ignores an empty query', () {
      expect(addSearch(['tent'], '   '), ['tent']);
    });

    test('moves a repeat to the top, ignoring case, without a duplicate', () {
      expect(addSearch(['tent', 'drone'], 'DRONE'), ['DRONE', 'tent']);
    });

    test('keeps only the newest three', () {
      final result = addSearch(['a', 'b', 'c'], 'd');
      expect(result, ['d', 'a', 'b']);
    });
  });

  group('RemoveRecentSearch', () {
    test('removes only that search', () {
      expect(removeSearch(['tent', 'drone'], 'tent'), ['drone']);
    });

    test('leaves the list alone when the search is not there', () {
      expect(removeSearch(['tent'], 'drone'), ['tent']);
    });
  });
}
