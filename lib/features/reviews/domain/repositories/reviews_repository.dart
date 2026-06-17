import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/review_entity.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required int rating,
    String? comment,
  });

  Future<Either<Failure, List<ReviewEntity>>> getReviewsForUser(
    String userId,
  );

  Future<Either<Failure, bool>> hasReviewed({
    required String bookingId,
    required String reviewerId,
  });
}
