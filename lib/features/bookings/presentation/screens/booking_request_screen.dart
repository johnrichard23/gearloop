import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../listings/domain/entities/listing_entity.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../domain/usecases/calculate_booking_price.dart';
import '../../domain/usecases/create_booking_request.dart';
import '../providers/booking_request_provider.dart';

class BookingRequestScreen extends ConsumerStatefulWidget {
  const BookingRequestScreen({required this.listing, super.key});

  final ListingEntity listing;

  @override
  ConsumerState<BookingRequestScreen> createState() =>
      _BookingRequestScreenState();
}

class _BookingRequestScreenState extends ConsumerState<BookingRequestScreen> {
  final _notesController = TextEditingController();
  final _priceCalculator = const CalculateBookingPrice();
  final _createBookingRequest = CreateBookingRequest(BookingsRepositoryImpl());
  bool _isSubmitting = false;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final state = ref.read(bookingRequestProvider);

    final picked = await showDatePicker(
      context: context,
      initialDate: state.startDate ?? today,
      firstDate: today,
      lastDate: today.add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(bookingRequestProvider.notifier).setStartDate(picked);
    }
  }

  Future<void> _pickEndDate() async {
    final state = ref.read(bookingRequestProvider);
    final start = state.startDate;
    if (start == null) return;

    final minEnd = DateTime(start.year, start.month, start.day)
        .add(const Duration(days: 1));
    final picked = await showDatePicker(
      context: context,
      initialDate: state.endDate ?? minEnd,
      firstDate: minEnd,
      lastDate: minEnd.add(const Duration(days: 365)),
    );
    if (picked != null) {
      ref.read(bookingRequestProvider.notifier).setEndDate(picked);
    }
  }

  Future<void> _submitRequest() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please log in to request a booking.'),
          backgroundColor: AppColors.kColorError,
        ),
      );
      return;
    }

    final startDate = ref.read(bookingRequestProvider).startDate;
    final endDate = ref.read(bookingRequestProvider).endDate;
    if (startDate == null || endDate == null) {
      return;
    }

    setState(() => _isSubmitting = true);

    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final result = await _createBookingRequest(
      listingId: widget.listing.id,
      renterId: user.id,
      hostId: widget.listing.hostId,
      startDate: startDate,
      endDate: endDate,
      dailyRate: _parsePrice(widget.listing.pricePerDay),
      depositAmount: _parsePrice(widget.listing.depositAmount),
      notes: notes,
    );

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    result.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            backgroundColor: AppColors.kColorError,
          ),
        );
      },
      (_) async {
        await showDialog<void>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Request Sent! 🎉'),
            content: const Text(
              "Your booking request has been sent to the host. "
              "You'll be notified once they respond.",
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context.go('/home');
                },
                child: const Text('View My Bookings'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingRequestProvider);
    final startDate = bookingState.startDate;
    final endDate = bookingState.endDate;

    BookingPriceCalculation? price;
    if (startDate != null && endDate != null) {
      price = _priceCalculator(
        startDate: startDate,
        endDate: endDate,
        dailyRate: _parsePrice(widget.listing.pricePerDay),
        depositAmount: _parsePrice(widget.listing.depositAmount),
      );
    }

    ref.listen<BookingRequestState>(bookingRequestProvider, (prev, next) async {
      if (next.status == BookingRequestStatus.error &&
          next.errorMessage != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: AppColors.kColorError,
          ),
        );
      }
    });

    final isLoading = _isSubmitting;
    final canSubmit = startDate != null && endDate != null && !isLoading;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('Request Booking'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ListingSummaryCard(listing: widget.listing),
                    const SizedBox(height: AppSpacing.kSpacing24),
                    Text('Select Dates', style: AppTextStyles.kTextHeading4),
                    const SizedBox(height: AppSpacing.kSpacing12),
                    _DateRow(
                      label: 'Start Date',
                      date: startDate,
                      onTap: _pickStartDate,
                    ),
                    const SizedBox(height: AppSpacing.kSpacing12),
                    _DateRow(
                      label: 'End Date',
                      date: endDate,
                      onTap: startDate != null ? _pickEndDate : null,
                      disabled: startDate == null,
                    ),
                    const SizedBox(height: AppSpacing.kSpacing24),
                    if (price != null)
                      _PriceBreakdownCard(
                        listing: widget.listing,
                        price: price,
                      ),
                    const SizedBox(height: AppSpacing.kSpacing24),
                    Text(
                      'Notes',
                      style: AppTextStyles.kTextHeading4,
                    ),
                    const SizedBox(height: AppSpacing.kSpacing8),
                    AppTextField(
                      label: 'Notes for host (optional)',
                      controller: _notesController,
                      hint: 'e.g. What will you use this for?',
                    ),
                    const SizedBox(height: AppSpacing.kSpacing24),
                    _InfoBanner(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppSpacing.kSpacing16),
              child: AppButton(
                label: 'Send Booking Request',
                isLoading: isLoading,
                onTap: canSubmit ? _submitRequest : () {},
                color: canSubmit
                    ? AppColors.kColorPrimary
                    : AppColors.kColorTextHint,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListingSummaryCard extends StatelessWidget {
  const _ListingSummaryCard({required this.listing});

  final ListingEntity listing;

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
              borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
            ),
            child: const Icon(
              Icons.camera_alt_outlined,
              color: AppColors.kColorTextHint,
            ),
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  listing.title,
                  style: AppTextStyles.kTextHeading4,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.kSpacing4),
                Text(
                  '${listing.pricePerDay}/day',
                  style: AppTextStyles.kTextBodyMedium.copyWith(
                    color: AppColors.kColorTextSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DateRow extends StatelessWidget {
  const _DateRow({
    required this.label,
    required this.date,
    required this.onTap,
    this.disabled = false,
  });

  final String label;
  final DateTime? date;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final text = date != null
        ? '${date!.year}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}'
        : 'Select date';

    final color = disabled
        ? AppColors.kColorTextHint
        : AppColors.kColorTextPrimary;

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
        decoration: BoxDecoration(
          color: AppColors.kColorSurface,
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          border: Border.all(color: AppColors.kColorBorder),
        ),
        child: Row(
          children: [
            Icon(
              Icons.calendar_today_outlined,
              color: color,
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Text(
              label,
              style: AppTextStyles.kTextBodyMedium.copyWith(color: color),
            ),
            const Spacer(),
            Text(
              text,
              style: AppTextStyles.kTextBodySmall.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _PriceBreakdownCard extends StatelessWidget {
  const _PriceBreakdownCard({
    required this.listing,
    required this.price,
  });

  final ListingEntity listing;
  final BookingPriceCalculation price;

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
          _row('Daily rate', listing.pricePerDay),
          _row('Total days', '${price.totalDays}'),
          _row('Subtotal', _formatPeso(price.subtotal)),
          _row('Platform fee (12%)', _formatPeso(price.platformFee)),
          _row('Security deposit', _formatPeso(price.depositAmount)),
          const Divider(color: AppColors.kColorBorder),
          _row(
            'Total',
            _formatPeso(price.totalAmount),
            valueStyle: AppTextStyles.kTextHeading3.copyWith(
              color: AppColors.kColorPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {TextStyle? valueStyle}) {
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

class _InfoBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.kSpacing12),
      decoration: BoxDecoration(
        color: AppColors.kColorWarningLight,
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.info_outline,
            color: AppColors.kColorWarning,
          ),
          const SizedBox(width: AppSpacing.kSpacing12),
          Expanded(
            child: Text(
              'Your card will only be charged if the host accepts within 24 hours.',
              style: AppTextStyles.kTextBodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

double _parsePrice(String value) {
  final digits = value.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) {
    return 0;
  }
  return double.parse(digits);
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

// TODO: implement booking_request_screen
