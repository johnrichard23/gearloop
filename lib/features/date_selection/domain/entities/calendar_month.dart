/// Month arithmetic for the calendar grid. Weeks start on Sunday.
abstract final class CalendarMonth {
  /// The first day of the month containing [day].
  static DateTime firstOf(DateTime day) => DateTime(day.year, day.month);

  /// The first day of the month [delta] months from [month].
  static DateTime shift(DateTime month, int delta) =>
      DateTime(month.year, month.month + delta);

  /// One entry per grid cell for [month]: nulls for the blank cells before the
  /// 1st, then every day of the month.
  static List<DateTime?> cellsOf(DateTime month) {
    final first = firstOf(month);
    final daysInMonth = DateTime(first.year, first.month + 1, 0).day;
    // DateTime.weekday is 1 (Mon) to 7 (Sun); Sunday should be column 0.
    final leadingBlanks = first.weekday % 7;
    return [
      for (var i = 0; i < leadingBlanks; i++) null,
      for (var day = 1; day <= daysInMonth; day++)
        DateTime(first.year, first.month, day),
    ];
  }
}
