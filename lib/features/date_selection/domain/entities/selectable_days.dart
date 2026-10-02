import 'date_range_selection.dart';
import 'day_availability.dart';

/// The days a renter may pick: today onwards, minus anything [availability]
/// rules out.
class SelectableDays {
  SelectableDays({
    required DateTime today,
    this.availability = const AllDaysAvailable(),
  }) : today = DateRangeSelection.dateOnly(today);

  final DateTime today;
  final DayAvailability availability;

  bool isSelectable(DateTime day) {
    final date = DateRangeSelection.dateOnly(day);
    return !date.isBefore(today) && !availability.isDisabled(date);
  }
}
