import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/core/errors/failures.dart';
import 'package:rentra/features/reviews/domain/entities/review_entity.dart';
import 'package:rentra/features/reviews/domain/repositories/reviews_repository.dart';
import 'package:rentra/features/reviews/domain/usecases/submit_review.dart';
import 'package:mocktail/mocktail.dart';

class MockReviewsRepository extends Mock implements ReviewsRepository {}

void main() {
  late MockReviewsRepository mockRepository;
  late SubmitReview useCase;

  setUp(() {
    mockRepository = MockReviewsRepository();
    useCase = SubmitReview(mockRepository);
  });

  group('SubmitReview', () {
    test('returns ReviewEntity when rating is valid (1-5) and submission succeeds',
        () async {
      final review = _reviewFixture(rating: 5);

      when(
        () => mockRepository.submitReview(
          bookingId: any(named: 'bookingId'),
          reviewerId: any(named: 'reviewerId'),
          revieweeId: any(named: 'revieweeId'),
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      ).thenAnswer((_) async => Right(review));

      final result = await useCase(
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        rating: 5,
        comment: 'Great experience',
      );

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Expected Right(ReviewEntity)'),
        (value) => expect(value, review),
      );
    });

    test('returns Failure when rating is 0', () async {
      final result = await useCase(
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        rating: 0,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure.message,
          'Rating must be between 1 and 5 stars',
        ),
        (_) => fail('Expected Left(Failure)'),
      );
      verifyNever(
        () => mockRepository.submitReview(
          bookingId: any(named: 'bookingId'),
          reviewerId: any(named: 'reviewerId'),
          revieweeId: any(named: 'revieweeId'),
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      );
    });

    test('returns Failure when rating is above 5', () async {
      final result = await useCase(
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        rating: 6,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure.message,
          'Rating must be between 1 and 5 stars',
        ),
        (_) => fail('Expected Left(Failure)'),
      );
      verifyNever(
        () => mockRepository.submitReview(
          bookingId: any(named: 'bookingId'),
          reviewerId: any(named: 'reviewerId'),
          revieweeId: any(named: 'revieweeId'),
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      );
    });

    test('accepts a null comment as valid', () async {
      final review = _reviewFixture(rating: 4, comment: null);

      when(
        () => mockRepository.submitReview(
          bookingId: any(named: 'bookingId'),
          reviewerId: any(named: 'reviewerId'),
          revieweeId: any(named: 'revieweeId'),
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      ).thenAnswer((_) async => Right(review));

      final result = await useCase(
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        rating: 4,
        comment: null,
      );

      expect(result.isRight(), true);
    });

    test('returns Failure when repository fails', () async {
      when(
        () => mockRepository.submitReview(
          bookingId: any(named: 'bookingId'),
          reviewerId: any(named: 'reviewerId'),
          revieweeId: any(named: 'revieweeId'),
          rating: any(named: 'rating'),
          comment: any(named: 'comment'),
        ),
      ).thenAnswer((_) async => const Left(Failure('Server error')));

      final result = await useCase(
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        rating: 5,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Server error'),
        (_) => fail('Expected Left(Failure)'),
      );
    });
  });
}

ReviewEntity _reviewFixture({
  int rating = 5,
  String? comment = 'Great experience',
}) {
  return ReviewEntity(
    id: 'review-1',
    bookingId: 'booking-4',
    reviewerId: 'user-4',
    revieweeId: 'user-1',
    reviewerName: 'Leo M.',
    rating: rating,
    comment: comment,
    isVisible: true,
    createdAt: DateTime(2026, 4, 28),
    listingTitle: 'Sony A7III Camera Body',
  );
}
