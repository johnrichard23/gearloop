import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/date_selection/domain/entities/date_range_selection.dart';

void main() {
  final oct12 = DateTime(2026, 10, 12);
  final oct15 = DateTime(2026, 10, 15);
  final oct10 = DateTime(2026, 10, 10);

  group('DateRangeSelection.tap', () {
    test('the first tap sets the start', () {
      final selection = DateRangeSelection.empty.tap(oct12);
      expect(selection.start, oct12);
      expect(selection.end, isNull);
    });

    test('a later tap sets the end', () {
      final selection = DateRangeSelection.empty.tap(oct12).tap(oct15);
      expect(selection.start, oct12);
      expect(selection.end, oct15);
    });

    test('tapping the start again makes a one-day range', () {
      final selection = DateRangeSelection.empty.tap(oct12).tap(oct12);
      expect(selection.start, oct12);
      expect(selection.end, oct12);
      expect(selection.dayCount, 1);
    });

    test('a tap before the start starts over', () {
      final selection = DateRangeSelection.empty.tap(oct12).tap(oct10);
      expect(selection.start, oct10);
      expect(selection.end, isNull);
    });

    test('a tap once the range is complete starts over', () {
      final selection = DateRangeSelection.empty
          .tap(oct12)
          .tap(oct15)
          .tap(oct10);
      expect(selection.start, oct10);
      expect(selection.end, isNull);
    });

    test('ignores the time of day', () {
      final selection = DateRangeSelection.empty.tap(
        DateTime(2026, 10, 12, 18, 30),
      );
      expect(selection.start, oct12);
    });
  });

  group('DateRangeSelection queries', () {
    final range = DateRangeSelection(start: oct12, end: oct15);

    test('counts the days covered', () {
      expect(range.dayCount, 4);
      expect(DateRangeSelection.empty.dayCount, 0);
      expect(DateRangeSelection(start: oct12).dayCount, 1);
    });

    test('knows its two end days', () {
      expect(range.isEdge(oct12), isTrue);
      expect(range.isEdge(oct15), isTrue);
      expect(range.isEdge(DateTime(2026, 10, 13)), isFalse);
    });

    test('knows the days between the ends', () {
      expect(range.isInside(DateTime(2026, 10, 13)), isTrue);
      expect(range.isInside(oct12), isFalse);
      expect(range.isInside(oct15), isFalse);
      expect(range.isInside(DateTime(2026, 10, 20)), isFalse);
    });

    test('has nothing inside while only a start is picked', () {
      expect(DateRangeSelection(start: oct12).isInside(oct15), isFalse);
    });
  });
}
