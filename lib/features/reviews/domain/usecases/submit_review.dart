import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';
import '../repositories/reviews_repository.dart';

class SubmitReview {
  const SubmitReview(this.repository);

  final ReviewsRepository repository;

  Future<Either<Failure, ReviewEntity>> call({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required int rating,
    String? comment,
  }) async {
    if (rating < 1 || rating > 5) {
      return const Left(Failure('Rating must be between 1 and 5 stars'));
    }

    return repository.submitReview(
      bookingId: bookingId,
      reviewerId: reviewerId,
      revieweeId: revieweeId,
      rating: rating,
      comment: comment,
    );
  }
}
