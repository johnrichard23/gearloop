import 'package:equatable/equatable.dart';

/// A start day and an optional end day picked on the calendar. Days are kept
/// as calendar dates (no time of day).
class DateRangeSelection extends Equatable {
  const DateRangeSelection({this.start, this.end});

  /// Nothing picked.
  static const DateRangeSelection empty = DateRangeSelection();

  /// The first day, or null while nothing is picked.
  final DateTime? start;

  /// The last day, or null while only a start is picked.
  final DateTime? end;

  /// Drops the time of day, so days compare by calendar date.
  static DateTime dateOnly(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  bool get isEmpty => start == null;

  /// Number of days covered: 0 when empty, 1 while only a start is picked.
  int get dayCount {
    final first = start;
    if (first == null) {
      return 0;
    }
    final last = end ?? first;
    return last.difference(first).inDays + 1;
  }

  /// The selection after the user taps [day].
  ///
  /// With only a start picked, a tap on or after it sets the end. Any other
  /// tap, whether before the start or once a range is complete, starts over.
  DateRangeSelection tap(DateTime day) {
    final tapped = dateOnly(day);
    final first = start;
    if (first != null && end == null && !tapped.isBefore(first)) {
      return DateRangeSelection(start: first, end: tapped);
    }
    return DateRangeSelection(start: tapped);
  }

  /// Whether [day] is the first or last day of the selection.
  bool isEdge(DateTime day) {
    final tapped = dateOnly(day);
    return tapped == start || tapped == end;
  }

  /// Whether [day] falls strictly between the two ends.
  bool isInside(DateTime day) {
    final first = start;
    final last = end;
    if (first == null || last == null) {
      return false;
    }
    final tapped = dateOnly(day);
    return tapped.isAfter(first) && tapped.isBefore(last);
  }

  @override
  List<Object?> get props => [start, end];
}
