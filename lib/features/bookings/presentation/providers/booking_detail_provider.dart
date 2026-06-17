import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dartz/dartz.dart';

import '../../data/repositories/bookings_repository_impl.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repository.dart';
import '../../domain/usecases/respond_to_booking.dart';

enum BookingActionStatus {
  idle,
  loading,
  success,
  error,
}

class BookingDetailState {
  const BookingDetailState({
    required this.booking,
    this.status = BookingActionStatus.idle,
    this.errorMessage,
  });

  final BookingActionStatus status;
  final String? errorMessage;
  final BookingEntity booking;

  BookingDetailState copyWith({
    BookingActionStatus? status,
    String? errorMessage,
    BookingEntity? booking,
    bool clearError = false,
  }) {
    return BookingDetailState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      booking: booking ?? this.booking,
    );
  }
}

class BookingDetailNotifier extends StateNotifier<BookingDetailState> {
  BookingDetailNotifier(
    BookingEntity initialBooking, {
    required this.repository,
    required this.respondToBooking,
  }) : super(BookingDetailState(booking: initialBooking));

  final BookingsRepository repository;
  final RespondToBooking respondToBooking;

  Future<void> accept() async {
    await _respond(accept: true);
  }

  Future<void> decline() async {
    await _respond(accept: false);
  }

  Future<void> cancel() async {
    await _runAction(
      loadingStatus: BookingActionStatus.loading,
      action: () => repository.cancelBooking(state.booking.id),
      successStatus: BookingActionStatus.success,
    );
  }

  Future<void> markActive() async {
    await _runAction(
      loadingStatus: BookingActionStatus.loading,
      action: () => repository.markAsActive(state.booking.id),
      successStatus: BookingActionStatus.success,
    );
  }

  Future<void> complete() async {
    await _runAction(
      loadingStatus: BookingActionStatus.loading,
      action: () => repository.completeBooking(state.booking.id),
      successStatus: BookingActionStatus.success,
    );
  }

  Future<void> _respond({
    required bool accept,
  }) async {
    state = state.copyWith(
      status: BookingActionStatus.loading,
      clearError: true,
    );

    final result = await respondToBooking.call(
      bookingId: state.booking.id,
      accept: accept,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingActionStatus.error,
        errorMessage: failure.message,
      ),
      (updated) => state = state.copyWith(
        status: BookingActionStatus.success,
        booking: updated,
      ),
    );
  }

  Future<void> _runAction({
    required BookingActionStatus loadingStatus,
    required Future<Either<Failure, BookingEntity>> Function() action,
    required BookingActionStatus successStatus,
  }) async {
    state = state.copyWith(
      status: loadingStatus,
      clearError: true,
    );

    final result = await action();

    result.fold(
      (failure) => state = state.copyWith(
        status: BookingActionStatus.error,
        errorMessage: failure.message,
      ),
      (updated) => state = state.copyWith(
        status: successStatus,
        booking: updated,
      ),
    );
  }
}

final bookingDetailProvider = StateNotifierProvider.autoDispose
    .family<BookingDetailNotifier, BookingDetailState, BookingEntity>(
  (ref, initialBooking) {
    final repository = BookingsRepositoryImpl();
    final respondToBooking = RespondToBooking(repository);
    return BookingDetailNotifier(
      initialBooking,
      repository: repository,
      respondToBooking: respondToBooking,
    );
  },
);

