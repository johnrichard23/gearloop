import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../providers/write_review_provider.dart';
import '../widgets/star_rating_widget.dart';

class WriteReviewScreen extends ConsumerStatefulWidget {
  const WriteReviewScreen({required this.booking, super.key});

  final BookingEntity booking;

  @override
  ConsumerState<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends ConsumerState<WriteReviewScreen> {
  final _commentController = TextEditingController();

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  String _initials(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(writeReviewProvider);
    final notifier = ref.read(writeReviewProvider.notifier);
    final booking = widget.booking;
    final currentUserId = Supabase.instance.client.auth.currentUser!.id;

    final isHostView = booking.hostId == currentUserId;
    final revieweeId = isHostView ? booking.renterId : booking.hostId;

    ref.listen<WriteReviewState>(writeReviewProvider, (prev, next) {
      if (next.status == WriteReviewStatus.success) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Review submitted. Thank you!'),
          ),
        );
        context.go('/home');
      } else if (next.status == WriteReviewStatus.error &&
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

    final isLoading = state.status == WriteReviewStatus.loading;
    final canSubmit = state.rating > 0 && !isLoading;

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('Write a Review'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.kSpacing24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.kColorSurfaceVariant,
              child: Text(
                _initials(booking.counterpartyName),
                style: AppTextStyles.kTextHeading4.copyWith(
                  color: AppColors.kColorPrimary,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            Text(
              booking.counterpartyName,
              style: AppTextStyles.kTextHeading4,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.kSpacing4),
            Text(
              booking.listingTitle,
              style: AppTextStyles.kTextBodySmall.copyWith(
                color: AppColors.kColorTextSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.kSpacing24),
            Text(
              'How was your experience?',
              style: AppTextStyles.kTextBodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.kSpacing12),
            StarRatingWidget(
              initialRating: state.rating,
              size: 40,
              onRatingChanged: notifier.setRating,
            ),
            const SizedBox(height: AppSpacing.kSpacing24),
            _MultilineTextField(
              label: 'Share your experience (optional)',
              hint: 'What went well? Anything the other person should know?',
              controller: _commentController,
            ),
            const SizedBox(height: AppSpacing.kSpacing32),
            IgnorePointer(
              ignoring: !canSubmit,
              child: Opacity(
                opacity: canSubmit ? 1 : 0.5,
                child: AppButton(
                  label: 'Submit Review',
                  isLoading: isLoading,
                  onTap: () {
                    final comment = _commentController.text.trim();
                    notifier.submit(
                      bookingId: booking.id,
                      reviewerId: currentUserId,
                      revieweeId: revieweeId,
                      comment: comment.isEmpty ? null : comment,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Multiline field matching [AppTextField] styling (maxLines not on AppTextField yet).
class _MultilineTextField extends StatelessWidget {
  const _MultilineTextField({
    required this.label,
    required this.controller,
    this.hint,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 5,
      style: AppTextStyles.kTextBodyLarge,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: AppTextStyles.kTextLabel,
        hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
          color: AppColors.kColorTextHint,
        ),
        filled: true,
        fillColor: AppColors.kColorSurfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorPrimary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
          borderSide: const BorderSide(color: AppColors.kColorError),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.kSpacing16,
          vertical: AppSpacing.kSpacing12,
        ),
      ),
    );
  }
}
