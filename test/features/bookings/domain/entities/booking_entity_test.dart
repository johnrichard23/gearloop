import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/bookings/domain/entities/booking_entity.dart';

void main() {
  group('BookingEntity computed properties', () {
    test('timeUntilExpiry returns null when status is not pending', () {
      final booking = _bookingFixture(
        status: BookingStatus.accepted,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(booking.timeUntilExpiry, isNull);
    });

    test(
      'timeUntilExpiry returns positive duration when within 24 hours and status is pending',
      () {
        final booking = _bookingFixture(
          status: BookingStatus.pending,
          createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        );

        expect(booking.timeUntilExpiry, isNotNull);
        expect(booking.timeUntilExpiry!.inHours, inInclusiveRange(21, 22));
      },
    );

    test('isExpired returns false when within the 24 hour window', () {
      final booking = _bookingFixture(
        status: BookingStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      );

      expect(booking.isExpired, false);
    });

    test('isExpired returns true when past the 24 hour window', () {
      final booking = _bookingFixture(
        status: BookingStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(hours: 25)),
      );

      expect(booking.isExpired, true);
    });

    test(
      'isExpired returns false when status is not pending, regardless of createdAt age',
      () {
        final booking = _bookingFixture(
          status: BookingStatus.accepted,
          createdAt: DateTime.now().subtract(const Duration(hours: 30)),
        );

        expect(booking.isExpired, false);
      },
    );
  });
}

BookingEntity _bookingFixture({
  required BookingStatus status,
  required DateTime createdAt,
}) {
  final now = DateTime.now();
  return BookingEntity(
    id: 'booking-1',
    listingId: 'listing-1',
    renterId: 'user-1',
    hostId: 'host-1',
    startDate: now.add(const Duration(days: 1)),
    endDate: now.add(const Duration(days: 2)),
    totalDays: 1,
    dailyRate: 1000,
    subtotal: 1000,
    platformFee: 120,
    depositAmount: 5000,
    totalAmount: 6120,
    status: status,
    paymentStatus: PaymentStatus.unpaid,
    notes: null,
    createdAt: createdAt,
    respondedAt: null,
    listingTitle: 'Sony A7III',
    listingCategory: 'Cameras',
    counterpartyName: 'Host User',
    counterpartyVerified: true,
  );
}
