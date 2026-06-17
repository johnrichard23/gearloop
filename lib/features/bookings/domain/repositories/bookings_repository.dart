import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';

abstract interface class BookingsRepository {
  Future<Either<Failure, BookingEntity>> createBookingRequest(
    BookingEntity booking,
  );

  Future<Either<Failure, BookingEntity>> acceptBooking(String bookingId);

  Future<Either<Failure, BookingEntity>> declineBooking(String bookingId);

  Future<Either<Failure, BookingEntity>> cancelBooking(String bookingId);

  Future<Either<Failure, BookingEntity>> markAsActive(String bookingId);

  Future<Either<Failure, BookingEntity>> completeBooking(String bookingId);

  Future<Either<Failure, List<BookingEntity>>> getBookingsAsRenter(
    String renterId,
  );

  Future<Either<Failure, List<BookingEntity>>> getBookingsAsHost(
    String hostId,
  );

  Future<Either<Failure, BookingEntity>> getBookingById(String id);
}
