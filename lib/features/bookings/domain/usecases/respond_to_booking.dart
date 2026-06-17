import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/bookings_repository.dart';

class RespondToBooking {
  const RespondToBooking(this.repository);

  final BookingsRepository repository;

  Future<Either<Failure, BookingEntity>> call({
    required String bookingId,
    required bool accept,
  }) {
    if (accept) {
      return repository.acceptBooking(bookingId);
    }
    return repository.declineBooking(bookingId);
  }
}
