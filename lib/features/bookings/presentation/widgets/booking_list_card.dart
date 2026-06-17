import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/booking_entity.dart';
import 'booking_countdown_timer.dart';
import 'booking_status_badge.dart';

class BookingListCard extends StatelessWidget {
  const BookingListCard({
    required this.booking,
    required this.onTap,
    required this.isHostView,
    super.key,
  });

  final BookingEntity booking;
  final VoidCallback onTap;
  final bool isHostView;

  String get _dateRange {
    final fmt = DateFormat('MMM d');
    final start = fmt.format(booking.startDate);
    final end = fmt.format(booking.endDate);
    return '$start - $end';
  }

  @override
  Widget build(BuildContext context) {
    final personPrefix = isHostView ? 'Renter: ' : 'Host: ';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.kSpacing12),
        decoration: BoxDecoration(
          color: AppColors.kColorSurface,
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
          border: Border.all(color: AppColors.kColorBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    booking.listingTitle,
                    style: AppTextStyles.kTextHeading4,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: AppSpacing.kSpacing8),
                BookingStatusBadge(status: booking.status),
              ],
            ),
            const SizedBox(height: AppSpacing.kSpacing8),
            Row(
              children: [
                const Icon(
                  Icons.person_outline,
                  size: AppSpacing.kIconSmall,
                  color: AppColors.kColorTextSecondary,
                ),
                const SizedBox(width: AppSpacing.kSpacing8),
                Expanded(
                  child: Text(
                    '$personPrefix${booking.counterpartyName}',
                    style: AppTextStyles.kTextBodySmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.kSpacing8),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_outlined,
                  size: AppSpacing.kIconSmall,
                  color: AppColors.kColorTextSecondary,
                ),
                const SizedBox(width: AppSpacing.kSpacing8),
                Text(_dateRange, style: AppTextStyles.kTextBodySmall),
              ],
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            Text(_formatPeso(booking.totalAmount), style: AppTextStyles.kTextPrice),
            if (booking.status == BookingStatus.pending && isHostView) ...[
              const SizedBox(height: AppSpacing.kSpacing8),
              BookingCountdownTimer(createdAt: booking.createdAt),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatPeso(double amount) {
  final rounded = amount.round();
  final buffer = StringBuffer('₱');
  final text = rounded.toString();
  for (var i = 0; i < text.length; i++) {
    if (i > 0 && (text.length - i) % 3 == 0) {
      buffer.write(',');
    }
    buffer.write(text[i]);
  }
  return buffer.toString();
}

