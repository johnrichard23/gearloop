import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The column headings above the day grid, Sunday first.
class CalendarWeekdayRow extends StatelessWidget {
  const CalendarWeekdayRow({super.key});

  static const List<String> _kWeekdays = [
    'Sun',
    'Mon',
    'Tue',
    'Wed',
    'Thu',
    'Fri',
    'Sat',
  ];

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: Row(
        children: [
          for (final weekday in _kWeekdays)
            Expanded(
              child: Text(
                weekday,
                textAlign: TextAlign.center,
                style: AppTextStyles.kTextCaption.copyWith(
                  color: AppColors.kColorTextSecondary,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
