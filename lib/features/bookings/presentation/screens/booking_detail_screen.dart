import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../providers/booking_detail_provider.dart';
import '../widgets/booking_countdown_timer.dart';
import '../widgets/booking_status_badge.dart';
import '../../domain/entities/booking_entity.dart';

class BookingDetailScreen extends ConsumerWidget {
  const BookingDetailScreen({required this.booking, super.key});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final initialBookingKey = booking;
    final state = ref.watch(bookingDetailProvider(initialBookingKey));
    final currentBooking = state.booking;

    final isHostView = currentBooking.hostId == 'user-1';

    final DateFormat fmt = DateFormat('MMM d');
    final formattedDateRange =
        '${fmt.format(currentBooking.startDate)} - ${fmt.format(currentBooking.endDate)}';

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.kSpacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _StatusHeader(booking: currentBooking),
                  if (currentBooking.status == BookingStatus.pending)
                    const SizedBox(height: AppSpacing.kSpacing12),
                  if (currentBooking.status == BookingStatus.pending)
                    BookingCountdownTimer(createdAt: currentBooking.createdAt),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  _GearSummaryCard(booking: currentBooking),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  _BookingInfoSection(
                    booking: currentBooking,
                    isHostView: isHostView,
                    formattedDateRange: formattedDateRange,
                  ),
                  const SizedBox(height: AppSpacing.kSpacing24),
                  _PriceBreakdown(booking: currentBooking),
                  const SizedBox(height: AppSpacing.kSpacing16),
                  _PaymentStatusRow(booking: currentBooking),
                  const SizedBox(height: AppSpacing.kSpacing24),
                ],
              ),
            ),
          ),
          _BottomActionBar(
            isHostView: isHostView,
            booking: currentBooking,
            status: state.status,
            errorMessage: state.errorMessage,
            onAccept: () async => _confirmAndExecute(
              context,
              bookingKey: initialBookingKey,
              onConfirm: () => ref
                  .read(bookingDetailProvider(initialBookingKey).notifier)
                  .accept(),
              successSnack: 'Booking accepted',
              ref: ref,
            ),
            onDecline: () async => _confirmAndExecute(
              context,
              bookingKey: initialBookingKey,
              onConfirm: () => ref
                  .read(bookingDetailProvider(initialBookingKey).notifier)
                  .decline(),
              successSnack: 'Booking declined',
              ref: ref,
            ),
            onCancel: () async => _confirmAndExecute(
              context,
              bookingKey: initialBookingKey,
              onConfirm: () => ref
                  .read(bookingDetailProvider(initialBookingKey).notifier)
                  .cancel(),
              successSnack: 'Booking cancelled',
              ref: ref,
            ),
            onMarkActive: () async => _confirmAndExecute(
              context,
              bookingKey: initialBookingKey,
              onConfirm: () => ref
                  .read(bookingDetailProvider(initialBookingKey).notifier)
                  .markActive(),
              successSnack: 'Marked as active',
              ref: ref,
            ),
            onComplete: () async => _confirmAndExecute(
              context,
              bookingKey: initialBookingKey,
              onConfirm: () => ref
                  .read(bookingDetailProvider(initialBookingKey).notifier)
                  .complete(),
              successSnack: 'Booking completed',
              ref: ref,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmAndExecute(
    BuildContext context, {
    required BookingEntity bookingKey,
    required Future<void> Function() onConfirm,
    required String successSnack,
    required WidgetRef ref,
  }) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm'),
        content: const Text('Are you sure you want to proceed?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Confirm'),
          ),
        ],
      ),
    );

    if (confirmed != true) {
      return;
    }

    await onConfirm();

    final nextState = ref.read(bookingDetailProvider(bookingKey));
    if (nextState.status == BookingActionStatus.success) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(successSnack)),
      );
      context.pop();
    } else if (nextState.status == BookingActionStatus.error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(nextState.errorMessage ?? 'Something went wrong'),
          backgroundColor: AppColors.kColorError,
        ),
      );
    }
  }
}

class _StatusHeader extends StatelessWidget {
  const _StatusHeader({
    required this.booking,
  });

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Transform.scale(
          scale: 1.15,
          child: BookingStatusBadge(status: booking.status),
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Text(
          booking.id,
          style: AppTextStyles.kTextCaption.copyWith(
            color: AppColors.kColorTextHint,
          ),
        ),
      ],
    );
  }
}

class _GearSummaryCard extends StatelessWidget {
  const _GearSummaryCard({required this.booking});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing12),
      decoration: BoxDecoration(
        color: AppColors.kColorSurfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.kColorSurface,
              borderRadius:
                  BorderRadius.circular(AppSpacing.kRadiusSmall),
            ),
            child: const Center(
              child: Icon(
                Icons.camera_alt_outlined,
                color: AppColors.kColorTextHint,
                size: AppSpacing.kIconLarge,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  booking.listingTitle,
                  style: AppTextStyles.kTextHeading4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.kSpacing8),
                _CategoryChip(label: booking.listingCategory),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.kSpacing8,
        vertical: AppSpacing.kSpacing4,
      ),
      decoration: BoxDecoration(
        color: AppColors.kColorPrimaryFaded,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
      ),
      child: Text(
        label,
        style: AppTextStyles.kTextLabel.copyWith(
          color: AppColors.kColorPrimary,
        ),
      ),
    );
  }
}

class _BookingInfoSection extends StatelessWidget {
  const _BookingInfoSection({
    required this.booking,
    required this.isHostView,
    required this.formattedDateRange,
  });

  final BookingEntity booking;
  final bool isHostView;
  final String formattedDateRange;

  @override
  Widget build(BuildContext context) {
    final roleLabel = isHostView ? 'Renter' : 'Host';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Booking Details',
          style: AppTextStyles.kTextHeading4,
        ),
        const SizedBox(height: AppSpacing.kSpacing12),
        _InfoRow(
          icon: Icons.calendar_today_outlined,
          label: 'Dates',
          value: formattedDateRange,
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        _InfoRow(
          icon: Icons.schedule_outlined,
          label: 'Duration',
          value: '${booking.totalDays} days',
        ),
        const SizedBox(height: AppSpacing.kSpacing8),
        _PersonRow(
          label: roleLabel,
          name: booking.counterpartyName,
          isVerified: booking.counterpartyVerified,
        ),
        if (booking.notes != null && booking.notes!.trim().isNotEmpty) ...[
          const SizedBox(height: AppSpacing.kSpacing8),
          _InfoRow(
            icon: Icons.notes_outlined,
            label: 'Notes',
            value: booking.notes!,
          ),
        ],
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: AppSpacing.kIconSmall,
          color: AppColors.kColorTextSecondary,
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Text(
          label,
          style: AppTextStyles.kTextBodyMedium,
        ),
        const Spacer(),
        Flexible(
          child: Text(
            value,
            style: AppTextStyles.kTextBodyMedium,
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _PersonRow extends StatelessWidget {
  const _PersonRow({
    required this.label,
    required this.name,
    required this.isVerified,
  });

  final String label;
  final String name;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.person_outline,
          size: AppSpacing.kIconSmall,
          color: AppColors.kColorTextSecondary,
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Text(label, style: AppTextStyles.kTextBodyMedium),
        const Spacer(),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: AppTextStyles.kTextBodyMedium,
                textAlign: TextAlign.end,
              ),
              if (isVerified) ...[
                const SizedBox(width: AppSpacing.kSpacing8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.kSpacing8,
                    vertical: AppSpacing.kSpacing2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.kColorPrimaryFaded,
                    borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
                  ),
                  child: Text(
                    'Verified ✓',
                    style: AppTextStyles.kTextLabel.copyWith(
                      color: AppColors.kColorPrimary,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _PriceBreakdown extends StatelessWidget {
  const _PriceBreakdown({required this.booking});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      decoration: BoxDecoration(
        color: AppColors.kColorSurfaceVariant,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusLarge),
      ),
      child: Column(
        children: [
          _PricingRow(
            label: 'Daily rate',
            value: _formatPeso(booking.dailyRate),
          ),
          _PricingRow(
            label: 'Total days',
            value: '${booking.totalDays}',
          ),
          _PricingRow(
            label: 'Subtotal',
            value: _formatPeso(booking.subtotal),
          ),
          _PricingRow(
            label: 'Platform fee (12%)',
            value: _formatPeso(booking.platformFee),
          ),
          _PricingRow(
            label: 'Security deposit',
            value: _formatPeso(booking.depositAmount),
          ),
          const Divider(color: AppColors.kColorBorder),
          _PricingRow(
            label: 'Total',
            value: _formatPeso(booking.totalAmount),
            valueStyle: AppTextStyles.kTextHeading3.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingRow extends StatelessWidget {
  const _PricingRow({
    required this.label,
    required this.value,
    this.valueStyle,
  });

  final String label;
  final String value;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.kSpacing4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.kTextBodyMedium),
          Text(
            value,
            style: valueStyle ?? AppTextStyles.kTextBodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PaymentStatusRow extends StatelessWidget {
  const _PaymentStatusRow({required this.booking});

  final BookingEntity booking;

  @override
  Widget build(BuildContext context) {
    final (label, color) = _paymentMapping(booking.paymentStatus);

    return Row(
      children: [
        const Icon(
          Icons.payments_outlined,
          size: AppSpacing.kIconSmall,
          color: AppColors.kColorTextSecondary,
        ),
        const SizedBox(width: AppSpacing.kSpacing12),
        Text('Payment Status', style: AppTextStyles.kTextBodyMedium),
        const Spacer(),
        Text(
          label,
          style: AppTextStyles.kTextBodyMedium.copyWith(color: color),
        ),
      ],
    );
  }

  (String, Color) _paymentMapping(PaymentStatus status) {
    switch (status) {
      case PaymentStatus.unpaid:
        return ('Not yet charged', AppColors.kColorTextSecondary);
      case PaymentStatus.held:
        return ('Payment held', AppColors.kColorWarning);
      case PaymentStatus.released:
        return ('Released to host', AppColors.kColorSuccess);
      case PaymentStatus.refunded:
        return ('Refunded', AppColors.kColorTextSecondary);
    }
  }
}

class _BottomActionBar extends StatelessWidget {
  const _BottomActionBar({
    required this.isHostView,
    required this.booking,
    required this.status,
    required this.errorMessage,
    required this.onAccept,
    required this.onDecline,
    required this.onCancel,
    required this.onMarkActive,
    required this.onComplete,
  });

  final bool isHostView;
  final BookingEntity booking;
  final BookingActionStatus status;
  final String? errorMessage;
  final Future<void> Function() onAccept;
  final Future<void> Function() onDecline;
  final Future<void> Function() onCancel;
  final Future<void> Function() onMarkActive;
  final Future<void> Function() onComplete;

  @override
  Widget build(BuildContext context) {
    final isLoading = status == BookingActionStatus.loading;

    final bottom = <Widget>[];

    final pending = booking.status == BookingStatus.pending;
    final accepted = booking.status == BookingStatus.accepted;
    final active = booking.status == BookingStatus.active;
    final completed = booking.status == BookingStatus.completed;
    final declinedLike =
        booking.status == BookingStatus.declined ||
            booking.status == BookingStatus.cancelled ||
            booking.status == BookingStatus.disputed;

    if (isHostView && pending) {
      bottom.add(Row(
        children: [
          Expanded(
            child: AppButton(
              label: 'Decline',
              isLoading: isLoading,
              isOutlined: true,
              color: AppColors.kColorError,
              onTap: onDecline,
            ),
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          Expanded(
            child: AppButton(
              label: 'Accept',
              isLoading: isLoading,
              color: AppColors.kColorPrimary,
              onTap: onAccept,
            ),
          ),
        ],
      ));
    } else if (!isHostView && pending) {
      bottom.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppButton(
            label: 'Cancel Request',
            isLoading: isLoading,
            isOutlined: true,
            color: AppColors.kColorError,
            onTap: onCancel,
          ),
          const SizedBox(height: AppSpacing.kSpacing12),
          Text(
            'Waiting for host to respond',
            style: AppTextStyles.kTextBodySmall.copyWith(
              color: AppColors.kColorTextSecondary,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ));
    } else if (isHostView && accepted) {
      bottom.add(AppButton(
        label: 'Mark as Handed Over',
        isLoading: isLoading,
        onTap: onMarkActive,
      ));
    } else if (!isHostView && accepted) {
      bottom.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Booking confirmed! Coordinate pickup with the host via message.',
            style: AppTextStyles.kTextBodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing12),
          AppButton(
            label: 'Message Host',
            isLoading: false,
            isOutlined: true,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Coming soon!')),
              );
            },
          ),
        ],
      ));
    } else if (active) {
      if (isHostView) {
        bottom.add(Text(
          'Gear is currently with renter',
          style: AppTextStyles.kTextBodyMedium,
          textAlign: TextAlign.center,
        ));
      } else {
        bottom.add(AppButton(
          label: 'Confirm Return',
          isLoading: isLoading,
          onTap: onComplete,
        ));
      }
    } else if (completed) {
      bottom.add(AppButton(
        label: 'Leave a Review',
        isLoading: isLoading,
        onTap: () {
          context.push('/write-review', extra: booking);
        },
      ));
    } else if (declinedLike) {
      final text = _declinedExplanation(booking.status);
      bottom.add(Text(
        text,
        style: AppTextStyles.kTextBodyMedium,
        textAlign: TextAlign.center,
      ));
    }

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kColorSurface,
        border: Border(
          top: BorderSide(color: AppColors.kColorBorder),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: bottom,
        ),
      ),
    );
  }

  String _declinedExplanation(BookingStatus status) {
    switch (status) {
      case BookingStatus.declined:
        return 'This booking request was declined.';
      case BookingStatus.cancelled:
        return 'This booking was cancelled.';
      case BookingStatus.disputed:
        return 'This booking is under review by our support team.';
      default:
        return '';
    }
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

