import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text_styles.dart';

/// One day on the calendar: a rounded tile that is filled when it is an end of
/// the range, tinted when inside it, and dimmed when it cannot be picked.
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    required this.day,
    required this.isEdge,
    required this.isInside,
    required this.isToday,
    required this.isEnabled,
    required this.onTap,
    super.key,
  });

  final DateTime day;
  final bool isEdge;
  final bool isInside;
  final bool isToday;
  final bool isEnabled;
  final VoidCallback onTap;

  static const double _kRadius = 12;

  Color get _fill {
    if (isEdge) {
      return AppColors.kColorPrimary;
    }
    if (isInside) {
      return AppColors.kColorPrimaryFaded;
    }
    return isEnabled ? AppColors.kColorBackground : Colors.transparent;
  }

  Color get _textColor {
    if (isEdge) {
      return AppColors.kColorOnPrimary;
    }
    return isEnabled ? AppColors.kColorTextPrimary : AppColors.kColorTextHint;
  }

  String get _semanticLabel {
    final parts = ['${day.day}'];
    if (isEdge) {
      parts.add('selected');
    } else if (isInside) {
      parts.add('in your dates');
    }
    if (!isEnabled) {
      parts.add('unavailable');
    }
    return parts.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: isEnabled,
      label: _semanticLabel,
      child: GestureDetector(
        onTap: isEnabled ? onTap : null,
        behavior: HitTestBehavior.opaque,
        child: ExcludeSemantics(
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: _fill,
              borderRadius: BorderRadius.circular(_kRadius),
              border: isToday && !isEdge
                  ? Border.all(color: AppColors.kColorAccent, width: 1.5)
                  : null,
            ),
            child: Text(
              '${day.day}',
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: _textColor,
                fontWeight: isEdge ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
