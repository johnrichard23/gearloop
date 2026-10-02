import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/date_selection/domain/entities/date_range_selection.dart';
import 'package:rentra/features/date_selection/presentation/date_range_label.dart';

void main() {
  test('is null when nothing is picked', () {
    expect(dateRangeLabel(DateRangeSelection.empty), isNull);
  });

  test('shows one day when only a start is picked', () {
    final selection = DateRangeSelection(start: DateTime(2026, 10, 12));
    expect(dateRangeLabel(selection), 'Oct 12');
  });

  test('shows one day for a one-day range', () {
    final day = DateTime(2026, 10, 12);
    expect(dateRangeLabel(DateRangeSelection(start: day, end: day)), 'Oct 12');
  });

  test('joins days in the same month with a dash', () {
    final selection = DateRangeSelection(
      start: DateTime(2026, 10, 12),
      end: DateTime(2026, 10, 15),
    );
    expect(dateRangeLabel(selection), 'Oct 12-15');
  });

  test('names both months across a month boundary', () {
    final selection = DateRangeSelection(
      start: DateTime(2026, 10, 30),
      end: DateTime(2026, 11, 2),
    );
    expect(dateRangeLabel(selection), 'Oct 30 - Nov 2');
  });
}
