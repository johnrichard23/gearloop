import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/listings_remote_datasource.dart';
import '../../data/repositories/listings_repository_impl.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/usecases/create_listing.dart';

enum CreateListingStatus {
  idle,
  loading,
  success,
  error,
}

class CreateListingState {
  const CreateListingState({
    this.status = CreateListingStatus.idle,
    this.errorMessage,
    this.createdListing,
  });

  final CreateListingStatus status;
  final String? errorMessage;
  final ListingEntity? createdListing;

  CreateListingState copyWith({
    CreateListingStatus? status,
    String? errorMessage,
    ListingEntity? createdListing,
    bool clearError = false,
    bool clearListing = false,
  }) {
    return CreateListingState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdListing:
          clearListing ? null : (createdListing ?? this.createdListing),
    );
  }
}

class CreateListingNotifier extends StateNotifier<CreateListingState> {
  CreateListingNotifier(this._createListing)
      : super(const CreateListingState());

  final CreateListing _createListing;

  Future<void> submitListing(ListingEntity listing) async {
    state = state.copyWith(
      status: CreateListingStatus.loading,
      clearError: true,
    );

    final result = await _createListing(listing);

    result.fold(
      (failure) => state = state.copyWith(
        status: CreateListingStatus.error,
        errorMessage: failure.message,
      ),
      (created) => state = state.copyWith(
        status: CreateListingStatus.success,
        createdListing: created,
      ),
    );
  }

  void reset() {
    state = const CreateListingState();
  }
}

final createListingProvider =
    StateNotifierProvider<CreateListingNotifier, CreateListingState>((ref) {
  final repository =
      ListingsRepositoryImpl(ListingsRemoteDatasourceMock());
  final createListing = CreateListing(repository);
  return CreateListingNotifier(createListing);
});
