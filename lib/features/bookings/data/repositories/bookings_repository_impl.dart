import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../models/booking_model.dart';

/// [BookingsRepository] backed by Supabase `bookings`.
class BookingsRepositoryImpl implements BookingsRepository {
  BookingsRepositoryImpl([Object? unused, SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const _renterJoinSelect =
      '*, gear_listings(title, category), host:users!host_id(full_name, is_id_verified)';

  static const _hostJoinSelect =
      '*, gear_listings(title, category), renter:users!renter_id(full_name, is_id_verified)';

  static const _detailJoinSelect =
      '*, gear_listings(title, category), host:users!host_id(full_name, is_id_verified), renter:users!renter_id(full_name, is_id_verified)';

  String? get _currentUserId => _supabase.auth.currentUser?.id;

  @override
  Future<Either<Failure, BookingEntity>> createBookingRequest(
    BookingEntity booking,
  ) async {
    try {
      final renterId = _supabase.auth.currentUser!.id;
      final inserted = await _supabase
          .from('bookings')
          .insert(_toInsertRow(booking, renterId: renterId))
          .select('id')
          .single();
      final newBookingId = inserted['id'] as String;
      final data = await _supabase
          .from('bookings')
          .select(_renterJoinSelect)
          .eq('id', newBookingId)
          .single();
      return Right(
        BookingModel.fromJson(data, currentUserId: renterId),
      );
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to create booking request. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> acceptBooking(String bookingId) async {
    return _updateStatus(
      bookingId,
      'accepted',
      setRespondedAt: true,
    );
  }

  @override
  Future<Either<Failure, BookingEntity>> declineBooking(String bookingId) async {
    return _updateStatus(
      bookingId,
      'declined',
      setRespondedAt: true,
    );
  }

  @override
  Future<Either<Failure, BookingEntity>> cancelBooking(String bookingId) async {
    return _updateStatus(
      bookingId,
      'cancelled',
      setRespondedAt: true,
    );
  }

  @override
  Future<Either<Failure, BookingEntity>> markAsActive(String bookingId) async {
    return _updateStatus(bookingId, 'active');
  }

  @override
  Future<Either<Failure, BookingEntity>> completeBooking(String bookingId) async {
    return _updateStatus(bookingId, 'completed');
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsAsRenter(
    String renterId,
  ) async {
    try {
      final effectiveRenterId = _supabase.auth.currentUser?.id ?? renterId;
      final data = await _supabase
          .from('bookings')
          .select(_renterJoinSelect)
          .eq('renter_id', effectiveRenterId)
          .order('created_at', ascending: false);
      final bookings = (data as List)
          .map(
            (row) => BookingModel.fromJson(
              row as Map<String, dynamic>,
              currentUserId: effectiveRenterId,
            ),
          )
          .toList();
      return Right(bookings);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to load bookings. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BookingEntity>>> getBookingsAsHost(
    String hostId,
  ) async {
    try {
      final effectiveHostId = _supabase.auth.currentUser?.id ?? hostId;
      final data = await _supabase
          .from('bookings')
          .select(_hostJoinSelect)
          .eq('host_id', effectiveHostId)
          .order('created_at', ascending: false);
      final bookings = (data as List)
          .map(
            (row) => BookingModel.fromJson(
              row as Map<String, dynamic>,
              currentUserId: effectiveHostId,
            ),
          )
          .toList();
      return Right(bookings);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to load bookings. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, BookingEntity>> getBookingById(String id) async {
    try {
      final data = await _supabase
          .from('bookings')
          .select(_detailJoinSelect)
          .eq('id', id)
          .single();
      return Right(
        BookingModel.fromJson(
          data,
          currentUserId: _currentUserId,
        ),
      );
    } on PostgrestException {
      return const Left(Failure('Booking not found'));
    } on Exception {
      return const Left(Failure('Booking not found'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasOverlappingBooking({
    required String listingId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final data = await _supabase
          .from('bookings')
          .select('id')
          .eq('listing_id', listingId)
          .inFilter('status', ['accepted', 'active'])
          .lt('start_date', endDate.toIso8601String())
          .gt('end_date', startDate.toIso8601String());
      return Right((data as List).isNotEmpty);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to check booking availability. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<DateTime>>> getBookedDatesForListing(
    String listingId,
  ) async {
    try {
      final data = await _supabase
          .from('bookings')
          .select('start_date, end_date')
          .eq('listing_id', listingId)
          .inFilter('status', ['accepted', 'active']);

      final bookedDates = <DateTime>[];
      for (final row in data as List) {
        final map = row as Map<String, dynamic>;
        final start = _parseBookingDate(map['start_date'] as String);
        final end = _parseBookingDate(map['end_date'] as String);
        bookedDates.addAll(_expandDateRange(start, end));
      }
      return Right(bookedDates);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to load booked dates. Please try again.'),
      );
    }
  }

  Future<Either<Failure, BookingEntity>> _updateStatus(
    String bookingId,
    String status, {
    bool setRespondedAt = false,
  }) async {
    try {
      final updates = <String, dynamic>{'status': status};
      if (setRespondedAt) {
        updates['responded_at'] = DateTime.now().toIso8601String();
      }
      final data = await _supabase
          .from('bookings')
          .update(updates)
          .eq('id', bookingId)
          .select(_detailJoinSelect)
          .single();
      return Right(
        BookingModel.fromJson(
          data,
          currentUserId: _currentUserId,
        ),
      );
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to update booking. Please try again.'),
      );
    }
  }

  Map<String, dynamic> _toInsertRow(
    BookingEntity booking, {
    required String renterId,
  }) {
    return {
      'listing_id': booking.listingId,
      'renter_id': renterId,
      'host_id': booking.hostId,
      'start_date': _formatDate(booking.startDate),
      'end_date': _formatDate(booking.endDate),
      'total_days': booking.totalDays,
      'daily_rate': booking.dailyRate,
      'subtotal': booking.subtotal,
      'platform_fee': booking.platformFee,
      'deposit_amount': booking.depositAmount,
      'total_amount': booking.totalAmount,
      'status': 'pending',
      'payment_status': 'unpaid',
      'notes': booking.notes,
    };
  }

  String _formatDate(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  DateTime _parseBookingDate(String value) {
    final parsed = DateTime.parse(value);
    return DateTime(parsed.year, parsed.month, parsed.day);
  }

  List<DateTime> _expandDateRange(DateTime start, DateTime end) {
    final days = <DateTime>[];
    var current = DateTime(start.year, start.month, start.day);
    final endDay = DateTime(end.year, end.month, end.day);
    while (!current.isAfter(endDay)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }
}
