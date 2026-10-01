import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/core/errors/failures.dart';
import 'package:rentra/features/bookings/domain/entities/booking_entity.dart';
import 'package:rentra/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:rentra/features/bookings/domain/usecases/respond_to_booking.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingsRepository extends Mock implements BookingsRepository {}

void main() {
  late MockBookingsRepository mockRepository;
  late RespondToBooking useCase;

  setUp(() {
    mockRepository = MockBookingsRepository();
    useCase = RespondToBooking(mockRepository);
  });

  group('RespondToBooking', () {
    test('calls acceptBooking when accept is true', () async {
      final booking = _bookingFixture();
      when(() => mockRepository.acceptBooking('booking-1'))
          .thenAnswer((_) async => Right(booking));

      final result = await useCase.call(
        bookingId: 'booking-1',
        accept: true,
      );

      verify(() => mockRepository.acceptBooking('booking-1')).called(1);
      verifyNever(() => mockRepository.declineBooking(any()));
      expect(result.isRight(), true);
    });

    test('calls declineBooking when accept is false', () async {
      final booking = _bookingFixture(status: BookingStatus.declined);
      when(() => mockRepository.declineBooking('booking-1'))
          .thenAnswer((_) async => Right(booking));

      final result = await useCase.call(
        bookingId: 'booking-1',
        accept: false,
      );

      verify(() => mockRepository.declineBooking('booking-1')).called(1);
      verifyNever(() => mockRepository.acceptBooking(any()));
      expect(result.isRight(), true);
    });

    test('returns Failure when repository fails on accept', () async {
      when(() => mockRepository.acceptBooking('booking-1')).thenAnswer(
        (_) async => const Left(Failure('Booking already responded to')),
      );

      final result = await useCase.call(
        bookingId: 'booking-1',
        accept: true,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Booking already responded to'),
        (_) => fail('Expected Left(Failure)'),
      );
    });
  });
}

BookingEntity _bookingFixture({
  BookingStatus status = BookingStatus.pending,
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
    createdAt: now,
    respondedAt: null,
    listingTitle: 'Sony A7III',
    listingCategory: 'Cameras',
    counterpartyName: 'Host User',
    counterpartyVerified: true,
  );
}
