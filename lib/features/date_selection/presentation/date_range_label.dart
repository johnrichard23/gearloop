import 'package:intl/intl.dart';

import '../domain/entities/date_range_selection.dart';

/// Short text for a selection: "Oct 12", "Oct 12-15" or "Oct 30 - Nov 2".
/// Null when nothing is picked.
String? dateRangeLabel(DateRangeSelection selection) {
  final start = selection.start;
  if (start == null) {
    return null;
  }
  final monthDay = DateFormat('MMM d');
  final startLabel = monthDay.format(start);
  final end = selection.end;
  if (end == null || end == start) {
    return startLabel;
  }
  if (end.year == start.year && end.month == start.month) {
    return '$startLabel-${end.day}';
  }
  return '$startLabel - ${monthDay.format(end)}';
}
