import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/booking_entity.dart';

class BookingStatusBadge extends StatelessWidget {
  const BookingStatusBadge({required this.status, super.key});

  final BookingStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, bg, fg) = _map(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(color: fg),
      ),
    );
  }

  (String, Color, Color) _map(BookingStatus status) {
    switch (status) {
      case BookingStatus.pending:
        return ('Pending', AppColors.kColorWarningLight, AppColors.kColorWarning);
      case BookingStatus.accepted:
        return (
          'Accepted',
          AppColors.kColorPrimaryFaded,
          AppColors.kColorPrimary
        );
      case BookingStatus.active:
        return ('Active', AppColors.kColorSuccessLight, AppColors.kColorSuccess);
      case BookingStatus.completed:
        return (
          'Completed',
          AppColors.kColorSurfaceVariant,
          AppColors.kColorTextSecondary
        );
      case BookingStatus.declined:
        return ('Declined', AppColors.kColorErrorLight, AppColors.kColorError);
      case BookingStatus.cancelled:
        return (
          'Cancelled',
          AppColors.kColorSurfaceVariant,
          AppColors.kColorTextHint
        );
      case BookingStatus.disputed:
        return ('Disputed', AppColors.kColorErrorLight, AppColors.kColorError);
    }
  }
}
