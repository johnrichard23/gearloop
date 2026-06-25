import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../listings/domain/entities/listing_entity.dart';
import '../../data/repositories/bookings_repository_impl.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../../domain/usecases/create_booking_request.dart';

enum BookingRequestStatus {
  idle,
  loading,
  success,
  error,
}

class BookingRequestState {
  const BookingRequestState({
    this.status = BookingRequestStatus.idle,
    this.errorMessage,
    this.startDate,
    this.endDate,
    this.createdBooking,
    this.bookedDates = const [],
  });

  final BookingRequestStatus status;
  final String? errorMessage;
  final DateTime? startDate;
  final DateTime? endDate;
  final BookingEntity? createdBooking;
  final List<DateTime> bookedDates;

  BookingRequestState copyWith({
    BookingRequestStatus? status,
    String? errorMessage,
    DateTime? startDate,
    DateTime? endDate,
    BookingEntity? createdBooking,
    List<DateTime>? bookedDates,
    bool clearError = false,
    bool clearBooking = false,
  }) {
    return BookingRequestState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      createdBooking:
          clearBooking ? null : (createdBooking ?? this.createdBooking),
      bookedDates: bookedDates ?? this.bookedDates,
    );
  }
}

class BookingRequestNotifier extends StateNotifier<BookingRequestState> {
  BookingRequestNotifier(this._createBookingRequest, this._repository)
      : super(const BookingRequestState());

  final CreateBookingRequest _createBookingRequest;
  final BookingsRepository _repository;

  void setStartDate(DateTime date) {
    state = state.copyWith(
      startDate: date,
      // Reset end date when start date changes
      endDate: null,
      clearError: true,
      clearBooking: true,
      status: BookingRequestStatus.idle,
    );
  }

  void setEndDate(DateTime date) {
    state = state.copyWith(
      endDate: date,
      clearError: true,
      clearBooking: true,
      status: BookingRequestStatus.idle,
    );
  }

  Future<void> loadBookedDates(String listingId) async {
    final result = await _repository.getBookedDatesForListing(listingId);
    result.fold(
      (_) => state = state.copyWith(bookedDates: const []),
      (dates) => state = state.copyWith(bookedDates: dates),
    );
  }

  Future<void> submitRequest({
    required ListingEntity listing,
    String? notes,
  }) async {
    final start = state.startDate;
    final end = state.endDate;
    if (start == null || end == null) {
      return;
    }

    state = state.copyWith(
      status: BookingRequestStatus.loading,
      clearError: true,
      clearBooking: true,
    );

    final result = await _createBookingRequest(
      listingId: listing.id,
      renterId: 'user-1', // Dummy current user
      hostId: listing.hostId,
      startDate: start,
      endDate: end,
      dailyRate: _parsePrice(listing.pricePerDay),
      depositAmount: _parsePrice(listing.depositAmount),
      notes: notes,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingRequestStatus.error,
        errorMessage: failure.message,
      ),
      (booking) => state = state.copyWith(
        status: BookingRequestStatus.success,
        createdBooking: booking,
      ),
    );
  }
}

double _parsePrice(String value) {
  final digits = value.replaceAll(RegExp(r'[^\d]'), '');
  if (digits.isEmpty) {
    return 0;
  }
  return double.parse(digits);
}

final bookingRequestProvider =
    StateNotifierProvider<BookingRequestNotifier, BookingRequestState>((ref) {
  final repository = BookingsRepositoryImpl();
  final createBooking = CreateBookingRequest(repository);
  return BookingRequestNotifier(createBooking, repository);
});

