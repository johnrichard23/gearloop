import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/listings/domain/usecases/add_recently_viewed.dart';

void main() {
  const addListing = AddRecentlyViewed();

  test('puts the newest listing first', () {
    expect(addListing(['a'], 'b'), ['b', 'a']);
  });

  test('moves a repeat to the top without a duplicate', () {
    expect(addListing(['a', 'b', 'c'], 'c'), ['c', 'a', 'b']);
  });

  test('keeps only the newest three', () {
    expect(addListing(['a', 'b', 'c'], 'd'), ['d', 'a', 'b']);
  });

  test('ignores an empty id', () {
    expect(addListing(['a'], ''), ['a']);
  });
}
