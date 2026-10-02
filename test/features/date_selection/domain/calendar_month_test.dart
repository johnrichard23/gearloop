import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/date_selection/domain/entities/calendar_month.dart';

void main() {
  group('CalendarMonth.cellsOf', () {
    test('pads the first week so Sunday is the first column', () {
      // October 2026 starts on a Thursday: four blanks (Sun-Wed).
      final cells = CalendarMonth.cellsOf(DateTime(2026, 10, 18));
      expect(cells.take(4), everyElement(isNull));
      expect(cells[4], DateTime(2026, 10, 1));
    });

    test('has no blanks when the month starts on a Sunday', () {
      // November 2026 starts on a Sunday.
      final cells = CalendarMonth.cellsOf(DateTime(2026, 11, 5));
      expect(cells.first, DateTime(2026, 11, 1));
    });

    test('lists every day of the month', () {
      final cells = CalendarMonth.cellsOf(DateTime(2026, 2, 10));
      expect(cells.whereType<DateTime>().length, 28);
      expect(cells.last, DateTime(2026, 2, 28));
    });

    test('knows leap-year February', () {
      final cells = CalendarMonth.cellsOf(DateTime(2028, 2, 1));
      expect(cells.whereType<DateTime>().length, 29);
    });
  });

  group('CalendarMonth.shift', () {
    test('moves forward across a year boundary', () {
      expect(CalendarMonth.shift(DateTime(2026, 12), 1), DateTime(2027, 1));
    });

    test('moves back across a year boundary', () {
      expect(CalendarMonth.shift(DateTime(2026, 1), -1), DateTime(2025, 12));
    });
  });
}
