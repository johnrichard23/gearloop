import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/booking_entity.dart';
import '../repositories/bookings_repository.dart';

class CreateBookingRequest {
  const CreateBookingRequest(this.repository);

  final BookingsRepository repository;

  Future<Either<Failure, BookingEntity>> call({
    required String listingId,
    required String renterId,
    required String hostId,
    required DateTime startDate,
    required DateTime endDate,
    required double dailyRate,
    required double depositAmount,
    String? notes,
  }) async {
    if (!endDate.isAfter(startDate)) {
      return const Left(Failure('End date must be after start date'));
    }

    final now = DateTime.now();
    final startDay = DateTime(startDate.year, startDate.month, startDate.day);
    final today = DateTime(now.year, now.month, now.day);
    if (startDay.isBefore(today)) {
      return const Left(Failure('Start date cannot be in the past'));
    }

    final rawDays = endDate.difference(startDate).inDays;
    final totalDays = rawDays < 1 ? 1 : rawDays;
    final subtotal = dailyRate * totalDays;
    final platformFee = subtotal * 0.12;
    final totalAmount = subtotal + platformFee + depositAmount;

    final booking = BookingEntity(
      id: '',
      listingId: listingId,
      renterId: renterId,
      hostId: hostId,
      startDate: startDate,
      endDate: endDate,
      totalDays: totalDays,
      dailyRate: dailyRate,
      subtotal: subtotal,
      platformFee: platformFee,
      depositAmount: depositAmount,
      totalAmount: totalAmount,
      status: BookingStatus.pending,
      paymentStatus: PaymentStatus.unpaid,
      notes: notes,
      createdAt: DateTime.now(),
      respondedAt: null,
      listingTitle: '',
      listingCategory: '',
      counterpartyName: '',
      counterpartyVerified: false,
    );

    return repository.createBookingRequest(booking);
  }
}
