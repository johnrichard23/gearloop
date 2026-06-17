import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  static final List<ReviewEntity> _store = _seedReviews();

  static List<ReviewEntity> _seedReviews() {
    return [
      ReviewEntity(
        id: 'review-1',
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        reviewerName: 'Leo M.',
        rating: 5,
        comment:
            'Chard was amazing! Camera was in perfect condition, very communicative and professional.',
        isVisible: true,
        createdAt: DateTime(2026, 4, 28),
        listingTitle: 'Sony A7III Camera Body',
      ),
      ReviewEntity(
        id: 'review-2',
        bookingId: 'booking-6',
        reviewerId: 'user-2',
        revieweeId: 'user-1',
        reviewerName: 'Marco R.',
        rating: 5,
        comment:
            'Chard was amazing! Camera was in perfect condition, very communicative and professional.',
        isVisible: true,
        createdAt: DateTime(2026, 5, 15),
        listingTitle: 'Sony A7III Camera Body',
      ),
      ReviewEntity(
        id: 'review-3',
        bookingId: 'booking-7',
        reviewerId: 'user-3',
        revieweeId: 'user-1',
        reviewerName: 'Anna S.',
        rating: 5,
        comment:
            'Super smooth transaction. Drone was clean and fully charged. Highly recommend!',
        isVisible: true,
        createdAt: DateTime(2026, 5, 10),
        listingTitle: 'DJI Mini 3 Pro Drone',
      ),
    ];
  }

  static const Map<String, String> _reviewerNames = {
    'user-1': 'Chard D.',
    'user-2': 'Marco R.',
    'user-3': 'Anna S.',
    'user-4': 'Leo M.',
  };

  static const Map<String, String> _bookingListingTitles = {
    'booking-4': 'Sony A7III Camera Body',
    'booking-6': 'Sony A7III Camera Body',
    'booking-7': 'DJI Mini 3 Pro Drone',
  };

  Future<void> _simulateDelay() {
    return Future<void>.delayed(const Duration(milliseconds: 400));
  }

  String _reviewerNameFor(String reviewerId) {
    return _reviewerNames[reviewerId] ?? 'User';
  }

  String _listingTitleFor(String bookingId) {
    return _bookingListingTitles[bookingId] ?? 'Gear rental';
  }

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required int rating,
    String? comment,
  }) async {
    try {
      await _simulateDelay();

      final alreadyReviewed = _store.any(
        (review) =>
            review.bookingId == bookingId &&
            review.reviewerId == reviewerId,
      );
      if (alreadyReviewed) {
        throw Exception('Review already submitted for this booking');
      }

      final review = ReviewEntity(
        id: 'review-${DateTime.now().microsecondsSinceEpoch}',
        bookingId: bookingId,
        reviewerId: reviewerId,
        revieweeId: revieweeId,
        reviewerName: _reviewerNameFor(reviewerId),
        rating: rating,
        comment: comment,
        isVisible: true,
        createdAt: DateTime.now(),
        listingTitle: _listingTitleFor(bookingId),
      );
      _store.add(review);
      return Right(review);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForUser(
    String userId,
  ) async {
    try {
      await _simulateDelay();
      final reviews = _store
          .where((review) => review.revieweeId == userId && review.isVisible)
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(reviews);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> hasReviewed({
    required String bookingId,
    required String reviewerId,
  }) async {
    try {
      await _simulateDelay();
      final reviewed = _store.any(
        (review) =>
            review.bookingId == bookingId &&
            review.reviewerId == reviewerId,
      );
      return Right(reviewed);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
