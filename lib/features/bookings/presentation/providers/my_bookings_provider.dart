import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/bookings_repository_impl.dart';
import '../../domain/entities/booking_entity.dart';

enum MyBookingsStatus {
  idle,
  loading,
  loaded,
  error,
}

class MyBookingsState {
  const MyBookingsState({
    this.status = MyBookingsStatus.idle,
    this.asRenter = const [],
    this.asHost = const [],
    this.errorMessage,
  });

  final MyBookingsStatus status;
  final List<BookingEntity> asRenter;
  final List<BookingEntity> asHost;
  final String? errorMessage;

  MyBookingsState copyWith({
    MyBookingsStatus? status,
    List<BookingEntity>? asRenter,
    List<BookingEntity>? asHost,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MyBookingsState(
      status: status ?? this.status,
      asRenter: asRenter ?? this.asRenter,
      asHost: asHost ?? this.asHost,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class MyBookingsNotifier extends StateNotifier<MyBookingsState> {
  MyBookingsNotifier() : super(const MyBookingsState());

  final _repository = BookingsRepositoryImpl();

  Future<void> loadBookings() async {
    state = state.copyWith(status: MyBookingsStatus.loading, clearError: true);

    final renterResult = await _repository.getBookingsAsRenter('user-1');
    final hostResult = await _repository.getBookingsAsHost('user-1');

    renterResult.fold(
      (failure) => state = state.copyWith(
        status: MyBookingsStatus.error,
        errorMessage: failure.message,
      ),
      (renterBookings) {
        hostResult.fold(
          (failure) => state = state.copyWith(
            status: MyBookingsStatus.error,
            errorMessage: failure.message,
          ),
          (hostBookings) => state = state.copyWith(
            status: MyBookingsStatus.loaded,
            asRenter: renterBookings,
            asHost: hostBookings,
          ),
        );
      },
    );
  }
}

final myBookingsProvider =
    StateNotifierProvider<MyBookingsNotifier, MyBookingsState>((ref) {
  return MyBookingsNotifier();
});

