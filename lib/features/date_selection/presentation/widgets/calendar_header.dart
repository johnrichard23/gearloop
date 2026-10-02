import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';

/// The month and year with previous and next arrows.
class CalendarHeader extends StatelessWidget {
  const CalendarHeader({
    required this.month,
    required this.canGoBack,
    required this.onPrevious,
    required this.onNext,
    super.key,
  });

  final DateTime month;
  final bool canGoBack;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            DateFormat('MMMM yyyy').format(month),
            style: AppTextStyles.kTextHeading4,
          ),
        ),
        _ArrowButton(
          icon: Icons.chevron_left_rounded,
          label: 'Previous month',
          onTap: canGoBack ? onPrevious : null,
        ),
        _ArrowButton(
          icon: Icons.chevron_right_rounded,
          label: 'Next month',
          onTap: onNext,
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  const _ArrowButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: label,
      onPressed: onTap,
      icon: Icon(icon, size: AppSpacing.kIconLarge),
      color: AppColors.kColorTextPrimary,
      disabledColor: AppColors.kColorTextHint.withValues(alpha: 0.5),
    );
  }
}
