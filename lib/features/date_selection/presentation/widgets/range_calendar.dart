import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../domain/entities/calendar_month.dart';
import '../../domain/entities/date_range_selection.dart';
import '../../domain/entities/selectable_days.dart';
import 'calendar_day_cell.dart';
import 'calendar_header.dart';
import 'calendar_metrics.dart';
import 'calendar_skeleton.dart';
import 'calendar_weekday_row.dart';

/// A month calendar for picking a range of days. It shows the selection it is
/// given and reports every tap; the caller owns the state.
///
/// [onMonthChanged] fires for the month first shown and each time the renter
/// pages, so a caller can load that month's availability. While [isLoading] is
/// true a skeleton replaces the days.
class RangeCalendar extends StatefulWidget {
  const RangeCalendar({
    required this.selection,
    required this.onChanged,
    required this.selectableDays,
    this.onMonthChanged,
    this.isLoading = false,
    super.key,
  });

  final DateRangeSelection selection;
  final ValueChanged<DateRangeSelection> onChanged;
  final SelectableDays selectableDays;
  final ValueChanged<DateTime>? onMonthChanged;
  final bool isLoading;

  @override
  State<RangeCalendar> createState() => _RangeCalendarState();
}

class _RangeCalendarState extends State<RangeCalendar> {
  late DateTime _month = CalendarMonth.firstOf(
    widget.selection.start ?? widget.selectableDays.today,
  );

  bool get _canGoBack =>
      _month.isAfter(CalendarMonth.firstOf(widget.selectableDays.today));

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        widget.onMonthChanged?.call(_month);
      }
    });
  }

  void _changeMonth(int delta) {
    setState(() => _month = CalendarMonth.shift(_month, delta));
    widget.onMonthChanged?.call(_month);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      decoration: BoxDecoration(
        color: AppColors.kColorSurface,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
        border: Border.all(color: AppColors.kColorBorder),
      ),
      child: Column(
        children: [
          CalendarHeader(
            month: _month,
            canGoBack: _canGoBack,
            onPrevious: () => _changeMonth(-1),
            onNext: () => _changeMonth(1),
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          const CalendarWeekdayRow(),
          const SizedBox(height: AppSpacing.kSpacing12),
          if (widget.isLoading) const CalendarSkeleton() else _buildDays(),
        ],
      ),
    );
  }

  Widget _buildDays() {
    final selection = widget.selection;
    final selectable = widget.selectableDays;
    return GridView.count(
      crossAxisCount: CalendarMetrics.columns,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: CalendarMetrics.cellGap,
      crossAxisSpacing: CalendarMetrics.cellGap,
      children: [
        for (final day in CalendarMonth.cellsOf(_month))
          if (day == null)
            const SizedBox.shrink()
          else
            CalendarDayCell(
              day: day,
              isEdge: selection.isEdge(day),
              isInside: selection.isInside(day),
              isToday: day == selectable.today,
              isEnabled: selectable.isSelectable(day),
              onTap: () => widget.onChanged(selection.tap(day)),
            ),
      ],
    );
  }
}
