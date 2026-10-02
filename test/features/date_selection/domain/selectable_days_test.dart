import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/date_selection/domain/entities/day_availability.dart';
import 'package:rentra/features/date_selection/domain/entities/selectable_days.dart';

class _BookedOnThe20th implements DayAvailability {
  @override
  bool isDisabled(DateTime day) => day.day == 20;
}

void main() {
  final today = DateTime(2026, 10, 12, 9, 30);

  test('today and later days can be picked', () {
    final days = SelectableDays(today: today);
    expect(days.isSelectable(DateTime(2026, 10, 12)), isTrue);
    expect(days.isSelectable(DateTime(2026, 11, 3)), isTrue);
  });

  test('past days cannot be picked', () {
    final days = SelectableDays(today: today);
    expect(days.isSelectable(DateTime(2026, 10, 11)), isFalse);
  });

  test('days the availability rules out cannot be picked', () {
    final days = SelectableDays(today: today, availability: _BookedOnThe20th());
    expect(days.isSelectable(DateTime(2026, 10, 20)), isFalse);
    expect(days.isSelectable(DateTime(2026, 10, 21)), isTrue);
  });
}
