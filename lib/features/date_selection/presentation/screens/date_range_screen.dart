import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/date_range_selection.dart';
import '../../domain/entities/selectable_days.dart';
import '../date_range_label.dart';
import '../widgets/date_range_footer.dart';
import '../widgets/range_calendar.dart';

/// Pick a start and an end day. Taps change a draft; Apply hands it back to the
/// caller, and closing the screen any other way keeps what was applied before.
class DateRangeScreen extends StatefulWidget {
  const DateRangeScreen({
    required this.initial,
    this.selectableDays,
    this.onMonthChanged,
    this.isLoading = false,
    super.key,
  });

  /// The selection already applied, shown as the starting draft.
  final DateRangeSelection initial;

  /// Which days can be picked. Defaults to today onwards.
  final SelectableDays? selectableDays;

  /// Called as months are shown, so availability can be loaded for them.
  final ValueChanged<DateTime>? onMonthChanged;

  /// Shows the calendar skeleton while availability loads.
  final bool isLoading;

  @override
  State<DateRangeScreen> createState() => _DateRangeScreenState();
}

class _DateRangeScreenState extends State<DateRangeScreen> {
  late DateRangeSelection _draft = widget.initial;
  late final SelectableDays _selectableDays =
      widget.selectableDays ?? SelectableDays(today: DateTime.now());

  String get _summary {
    final label = dateRangeLabel(_draft);
    if (label == null) {
      return 'Pick a start day, then an end day.';
    }
    final days = _draft.dayCount;
    return '$label · $days ${days == 1 ? 'day' : 'days'}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.kColorBackground,
        foregroundColor: AppColors.kColorTextPrimary,
        surfaceTintColor: Colors.transparent,
        title: const Text('Select dates'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.kSpacing16),
              child: Column(
                children: [
                  RangeCalendar(
                    selection: _draft,
                    selectableDays: _selectableDays,
                    onChanged: (value) => setState(() => _draft = value),
                    onMonthChanged: widget.onMonthChanged,
                    isLoading: widget.isLoading,
                  ),
                  const SizedBox(height: AppSpacing.kSpacing16),
                  Text(
                    _summary,
                    style: AppTextStyles.kTextBodyMedium,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          DateRangeFooter(
            canClear: !_draft.isEmpty,
            canApply: _draft != widget.initial,
            onClear: () => setState(() => _draft = DateRangeSelection.empty),
            onApply: () => context.pop(_draft),
          ),
        ],
      ),
    );
  }
}
