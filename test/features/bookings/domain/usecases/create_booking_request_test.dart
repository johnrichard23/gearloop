import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/core/errors/failures.dart';
import 'package:rentra/features/bookings/domain/entities/booking_entity.dart';
import 'package:rentra/features/bookings/domain/repositories/bookings_repository.dart';
import 'package:rentra/features/bookings/domain/usecases/create_booking_request.dart';
import 'package:mocktail/mocktail.dart';

class MockBookingsRepository extends Mock implements BookingsRepository {}

void main() {
  late MockBookingsRepository mockRepository;
  late CreateBookingRequest useCase;

  setUpAll(() {
    registerFallbackValue(_bookingFixture());
  });

  setUp(() {
    mockRepository = MockBookingsRepository();
    useCase = CreateBookingRequest(mockRepository);
  });

  group('CreateBookingRequest', () {
    test('returns BookingEntity when all inputs are valid', () async {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 3));
      final booking = _bookingFixture();

      when(() => mockRepository.createBookingRequest(any()))
          .thenAnswer((_) async => Right(booking));

      final result = await useCase(
        listingId: 'listing-1',
        renterId: 'user-1',
        hostId: 'host-1',
        startDate: startDate,
        endDate: endDate,
        dailyRate: 800,
        depositAmount: 5000,
      );

      expect(result.isRight(), true);
      verify(() => mockRepository.createBookingRequest(any())).called(1);
    });

    test('returns Failure when endDate is before startDate', () async {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 1));
      final endDate = now;

      final result = await useCase(
        listingId: 'listing-1',
        renterId: 'user-1',
        hostId: 'host-1',
        startDate: startDate,
        endDate: endDate,
        dailyRate: 800,
        depositAmount: 5000,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure.message,
          'End date must be after start date',
        ),
        (_) => fail('Expected Left(Failure)'),
      );
      verifyNever(() => mockRepository.createBookingRequest(any()));
    });

    test('returns Failure when startDate is in the past', () async {
      final now = DateTime.now();
      final startDate = now.subtract(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 1));

      final result = await useCase(
        listingId: 'listing-1',
        renterId: 'user-1',
        hostId: 'host-1',
        startDate: startDate,
        endDate: endDate,
        dailyRate: 800,
        depositAmount: 5000,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(
          failure.message,
          'Start date cannot be in the past',
        ),
        (_) => fail('Expected Left(Failure)'),
      );
      verifyNever(() => mockRepository.createBookingRequest(any()));
    });

    test('correctly applies 12% platform fee when creating the booking', () async {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 2));

      late BookingEntity captured;
      when(() => mockRepository.createBookingRequest(any()))
          .thenAnswer((invocation) async {
        captured = invocation.positionalArguments.first as BookingEntity;
        return Right(captured);
      });

      await useCase(
        listingId: 'listing-1',
        renterId: 'user-1',
        hostId: 'host-1',
        startDate: startDate,
        endDate: endDate,
        dailyRate: 1000,
        depositAmount: 5000,
      );

      expect(captured.platformFee, 120);
      expect(captured.subtotal, 1000);
    });

    test('returns Failure when repository fails', () async {
      final now = DateTime.now();
      final startDate = now.add(const Duration(days: 1));
      final endDate = now.add(const Duration(days: 3));

      when(() => mockRepository.createBookingRequest(any())).thenAnswer(
        (_) async => const Left(Failure('Network error')),
      );

      final result = await useCase(
        listingId: 'listing-1',
        renterId: 'user-1',
        hostId: 'host-1',
        startDate: startDate,
        endDate: endDate,
        dailyRate: 800,
        depositAmount: 5000,
      );

      expect(result.isLeft(), true);
      result.fold(
        (failure) => expect(failure.message, 'Network error'),
        (_) => fail('Expected Left(Failure)'),
      );
    });
  });
}

BookingEntity _bookingFixture({
  BookingStatus status = BookingStatus.pending,
  DateTime? createdAt,
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
    createdAt: createdAt ?? now,
    respondedAt: null,
    listingTitle: 'Sony A7III',
    listingCategory: 'Cameras',
    counterpartyName: 'Host User',
    counterpartyVerified: true,
  );
}
