import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../models/booking_model.dart';

class BookingsRepositoryImpl implements BookingsRepository {
  static final List<BookingModel> _store = _seedBookings();

  static List<BookingModel> _seedBookings() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    BookingModel build({
      required String id,
      required String listingId,
      required String listingTitle,
      required String listingCategory,
      required String renterId,
      required String hostId,
      required String counterpartyName,
      required bool counterpartyVerified,
      required DateTime startDate,
      required DateTime endDate,
      required double dailyRate,
      required double depositAmount,
      required BookingStatus status,
      required PaymentStatus paymentStatus,
      required DateTime createdAt,
      DateTime? respondedAt,
      String? notes,
    }) {
      final rawDays = endDate.difference(startDate).inDays;
      final totalDays = rawDays < 1 ? 1 : rawDays;
      final subtotal = dailyRate * totalDays;
      final platformFee = subtotal * 0.12;
      final totalAmount = subtotal + platformFee + depositAmount;
      return BookingModel(
        id: id,
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
        status: status,
        paymentStatus: paymentStatus,
        notes: notes,
        createdAt: createdAt,
        respondedAt: respondedAt,
        listingTitle: listingTitle,
        listingCategory: listingCategory,
        counterpartyName: counterpartyName,
        counterpartyVerified: counterpartyVerified,
      );
    }

    return [
      build(
        id: 'booking-1',
        listingId: 'listing-1',
        listingTitle: 'Sony A7III Camera Body',
        listingCategory: 'Cameras',
        renterId: 'user-2',
        hostId: 'user-1',
        counterpartyName: 'Marco R.',
        counterpartyVerified: true,
        startDate: now.add(const Duration(days: 2)),
        endDate: now.add(const Duration(days: 4)),
        dailyRate: 800,
        depositAmount: 5000,
        status: BookingStatus.pending,
        paymentStatus: PaymentStatus.unpaid,
        createdAt: now.subtract(const Duration(hours: 6)),
        notes: 'Need it for a wedding shoot',
      ),
      build(
        id: 'booking-2',
        listingId: 'listing-2',
        listingTitle: 'DJI Mini 3 Pro Drone',
        listingCategory: 'Drones',
        renterId: 'user-1',
        hostId: 'user-3',
        counterpartyName: 'Chard D.',
        counterpartyVerified: true,
        startDate: now.add(const Duration(days: 1)),
        endDate: now.add(const Duration(days: 3)),
        dailyRate: 1200,
        depositAmount: 8000,
        status: BookingStatus.accepted,
        paymentStatus: PaymentStatus.held,
        createdAt: now.subtract(const Duration(days: 1)),
        respondedAt: now.subtract(const Duration(hours: 18)),
      ),
      build(
        id: 'booking-3',
        listingId: 'listing-4',
        listingTitle: 'Godox SL-60W LED Light',
        listingCategory: 'Lighting',
        renterId: 'user-2',
        hostId: 'user-1',
        counterpartyName: 'Anna S.',
        counterpartyVerified: false,
        startDate: today,
        endDate: today.add(const Duration(days: 2)),
        dailyRate: 400,
        depositAmount: 2500,
        status: BookingStatus.active,
        paymentStatus: PaymentStatus.held,
        createdAt: now.subtract(const Duration(days: 2)),
        respondedAt: now.subtract(const Duration(days: 2)),
      ),
      build(
        id: 'booking-4',
        listingId: 'listing-1',
        listingTitle: 'Sony A7III Camera Body',
        listingCategory: 'Cameras',
        renterId: 'user-4',
        hostId: 'user-1',
        counterpartyName: 'Leo M.',
        counterpartyVerified: true,
        startDate: now.subtract(const Duration(days: 10)),
        endDate: now.subtract(const Duration(days: 8)),
        dailyRate: 800,
        depositAmount: 5000,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.released,
        createdAt: now.subtract(const Duration(days: 11)),
        respondedAt: now.subtract(const Duration(days: 11)),
      ),
      build(
        id: 'booking-5',
        listingId: 'listing-6',
        listingTitle: 'Yamaha Acoustic Guitar',
        listingCategory: 'Instruments',
        renterId: 'user-1',
        hostId: 'user-5',
        counterpartyName: 'Grace P.',
        counterpartyVerified: true,
        startDate: now.subtract(const Duration(days: 5)),
        endDate: now.subtract(const Duration(days: 4)),
        dailyRate: 200,
        depositAmount: 1200,
        status: BookingStatus.declined,
        paymentStatus: PaymentStatus.refunded,
        createdAt: now.subtract(const Duration(days: 6)),
        respondedAt: now.subtract(const Duration(days: 5)),
      ),
    ];
  }

  Future<void> _simulateDelay() {
    return Future<void>.delayed(const Duration(milliseconds: 400));
  }

  BookingModel _findById(String bookingId) {
    final index = _store.indexWhere((b) => b.id == bookingId);
    if (index == -1) {
      throw Exception('Booking not found: $bookingId');
    }
    return _store[index];
  }

  BookingModel _copyWith(
    BookingModel booking, {
    BookingStatus? status,
    PaymentStatus? paymentStatus,
    DateTime? respondedAt,
  }) {
    return BookingModel(
      id: booking.id,
      listingId: booking.listingId,
      renterId: booking.renterId,
      hostId: booking.hostId,
      startDate: booking.startDate,
      endDate: booking.endDate,
      totalDays: booking.totalDays,
      dailyRate: booking.dailyRate,
      subtotal: booking.subtotal,
      platformFee: booking.platformFee,
      depositAmount: booking.depositAmount,
      totalAmount: booking.totalAmount,
      status: status ?? booking.status,
      paymentStatus: paymentStatus ?? booking.paymentStatus,
      notes: booking.notes,
      createdAt: booking.createdAt,
      respondedAt: respondedAt ?? booking.respondedAt,
      listingTitle: booking.listingTitle,
      listingCategory: booking.listingCategory,
      counterpartyName: booking.counterpartyName,
      counterpartyVerified: booking.counterpartyVerified,
    );
  }

  @override
  Future<Either<Failure, BookingEntity>> createBookingRequest(
    BookingEntity booking,
  ) async {
    try {
      await _simulateDelay();
      final model = BookingModel.fromEntity(booking);
      final id = model.id.isEmpty
          ? 'booking-${DateTime.now().microsecondsSinceEpoch}'
          : model.id;
      final saved = BookingModel(
        id: id,
        listingId: model.listingId,
        renterId: model.renterId,
        hostId: model.hostId,
        startDate: model.startDate,
        endDate: model.endDate,
        totalDays: model.totalDays,
        dailyRate: model.dailyRate,
        subtotal: model.subtotal,
        platformFee: model.platformFee,
        depositAmount: model.depositAmount,
        totalAmount: model.totalAmount,
        status: model.status,
        paymentStatus: model.paymentStatus,
        notes: model.notes,
        createdAt: model.createdAt,
        respondedAt: model.respondedAt,
        listingTitle: model.listingTitle,
        listingCategory: model.listingCategory,
        counterpartyName: model.counterpartyName,
        counterpartyVerified: model.counterpartyVerified,
      );
      _store.add(saved);
      return Right(saved);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> acceptBooking(String bookingId) async {
    try {
      await _simulateDelay();
      final current = _findById(bookingId);
      final updated = _copyWith(
        current,
        status: BookingStatus.accepted,
        paymentStatus: PaymentStatus.held,
        respondedAt: DateTime.now(),
      );
      final idx = _store.indexWhere((b) => b.id == bookingId);
      _store[idx] = updated;
      return Right(updated);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> declineBooking(String bookingId) async {
    try {
      await _simulateDelay();
      final current = _findById(bookingId);
      final updated = _copyWith(
        current,
        status: BookingStatus.declined,
        paymentStatus: PaymentStatus.refunded,
        respondedAt: DateTime.now(),
      );
      final idx = _store.indexWhere((b) => b.id == bookingId);
      _store[idx] = updated;
      return Right(updated);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String bookingId) async {
    try {
      await _simulateDelay();
      final current = _findById(bookingId);
      final updated = _copyWith(
        current,
        status: BookingStatus.cancelled,
        paymentStatus: PaymentStatus.refunded,
        respondedAt: DateTime.now(),
      );
      final idx = _store.indexWhere((b) => b.id == bookingId);
      _store[idx] = updated;
      return Right(updated);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> markAsActive(String bookingId) async {
    try {
      await _simulateDelay();
      final current = _findById(bookingId);
      final updated = _copyWith(
        current,
        status: BookingStatus.active,
        paymentStatus: PaymentStatus.held,
      );
      final idx = _store.indexWhere((b) => b.id == bookingId);
      _store[idx] = updated;
      return Right(updated);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> completeBooking(String bookingId) async {
    try {
      await _simulateDelay();
      final current = _findById(bookingId);
      final updated = _copyWith(
        current,
        status: BookingStatus.completed,
        paymentStatus: PaymentStatus.released,
      );
      final idx = _store.indexWhere((b) => b.id == bookingId);
      _store[idx] = updated;
      return Right(updated);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsAsRenter(
    String renterId,
  ) async {
    try {
      await _simulateDelay();
      final items = _store.where((b) => b.renterId == renterId).toList();
      return Right(items);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsAsHost(
    String hostId,
  ) async {
    try {
      await _simulateDelay();
      final items = _store.where((b) => b.hostId == hostId).toList();
      return Right(items);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(String id) async {
    try {
      await _simulateDelay();
      final booking = _findById(id);
      return Right(booking);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
