import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/reviews_repository_impl.dart';
import '../../domain/usecases/submit_review.dart';

enum WriteReviewStatus {
  idle,
  loading,
  success,
  error,
}

class WriteReviewState {
  const WriteReviewState({
    this.status = WriteReviewStatus.idle,
    this.errorMessage,
    this.rating = 0,
  });

  final WriteReviewStatus status;
  final String? errorMessage;
  final int rating;

  WriteReviewState copyWith({
    WriteReviewStatus? status,
    String? errorMessage,
    int? rating,
    bool clearError = false,
  }) {
    return WriteReviewState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      rating: rating ?? this.rating,
    );
  }
}

class WriteReviewNotifier extends StateNotifier<WriteReviewState> {
  WriteReviewNotifier(this._submitReview) : super(const WriteReviewState());

  final SubmitReview _submitReview;

  void setRating(int rating) {
    state = state.copyWith(
      rating: rating,
      clearError: true,
      status: WriteReviewStatus.idle,
    );
  }

  Future<void> submit({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    String? comment,
  }) async {
    if (state.rating == 0) {
      return;
    }

    state = state.copyWith(
      status: WriteReviewStatus.loading,
      clearError: true,
    );

    final result = await _submitReview(
      bookingId: bookingId,
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rating: state.rating,
      comment: comment,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: WriteReviewStatus.error,
        errorMessage: failure.message,
      ),
      (_) => state = state.copyWith(
        status: WriteReviewStatus.success,
      ),
    );
  }
}

final writeReviewProvider =
    StateNotifierProvider.autoDispose<WriteReviewNotifier, WriteReviewState>(
  (ref) {
    final repository = ReviewsRepositoryImpl();
    final submitReview = SubmitReview(repository);
    return WriteReviewNotifier(submitReview);
  },
);
