import 'package:flutter_test/flutter_test.dart';
import 'package:gearloop/features/reviews/domain/entities/review_entity.dart';

void main() {
  group('ReviewEntity', () {
    test('two reviews with identical field values are equal', () {
      final createdAt = DateTime(2026, 4, 28);
      final first = ReviewEntity(
        id: 'review-1',
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        reviewerName: 'Leo M.',
        rating: 5,
        comment: 'Great experience',
        isVisible: true,
        createdAt: createdAt,
        listingTitle: 'Sony A7III Camera Body',
      );
      final second = ReviewEntity(
        id: 'review-1',
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        reviewerName: 'Leo M.',
        rating: 5,
        comment: 'Great experience',
        isVisible: true,
        createdAt: createdAt,
        listingTitle: 'Sony A7III Camera Body',
      );

      expect(first, second);
      expect(first == second, true);
    });

    test('two reviews with different ratings are not equal', () {
      final createdAt = DateTime(2026, 4, 28);
      final first = ReviewEntity(
        id: 'review-1',
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        reviewerName: 'Leo M.',
        rating: 5,
        comment: 'Great experience',
        isVisible: true,
        createdAt: createdAt,
        listingTitle: 'Sony A7III Camera Body',
      );
      final second = ReviewEntity(
        id: 'review-1',
        bookingId: 'booking-4',
        reviewerId: 'user-4',
        revieweeId: 'user-1',
        reviewerName: 'Leo M.',
        rating: 4,
        comment: 'Great experience',
        isVisible: true,
        createdAt: createdAt,
        listingTitle: 'Sony A7III Camera Body',
      );

      expect(first == second, false);
      expect(first, isNot(second));
    });
  });
}
