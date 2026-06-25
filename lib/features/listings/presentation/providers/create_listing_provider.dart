import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
    this.photoUploadFailed = false,
  });

  final CreateListingStatus status;
  final String? errorMessage;
  final ListingEntity? createdListing;
  final bool photoUploadFailed;

  CreateListingState copyWith({
    CreateListingStatus? status,
    String? errorMessage,
    ListingEntity? createdListing,
    bool? photoUploadFailed,
    bool clearError = false,
    bool clearListing = false,
  }) {
    return CreateListingState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      createdListing:
          clearListing ? null : (createdListing ?? this.createdListing),
      photoUploadFailed: photoUploadFailed ?? this.photoUploadFailed,
    );
  }
}

class CreateListingNotifier extends StateNotifier<CreateListingState> {
  CreateListingNotifier(this._createListing)
      : super(const CreateListingState());

  final CreateListing _createListing;

  Future<void> submitListing(
    ListingEntity listing, {
    List<XFile> photos = const [],
  }) async {
    state = state.copyWith(
      status: CreateListingStatus.loading,
      clearError: true,
      photoUploadFailed: false,
    );

    final result = await _createListing(listing);

    await result.fold(
      (failure) async {
        state = state.copyWith(
          status: CreateListingStatus.error,
          errorMessage: failure.message,
        );
      },
      (created) async {
        final photoUploadFailed = photos.isNotEmpty
            ? await _uploadPhotos(listingId: created.id, photos: photos)
            : false;

        state = state.copyWith(
          status: CreateListingStatus.success,
          createdListing: created,
          photoUploadFailed: photoUploadFailed,
        );
      },
    );
  }

  Future<bool> _uploadPhotos({
    required String listingId,
    required List<XFile> photos,
  }) async {
    final supabase = Supabase.instance.client;
    final currentUserId = supabase.auth.currentUser?.id;
    if (currentUserId == null) {
      return true;
    }

    var anyFailed = false;

    for (var index = 0; index < photos.length; index++) {
      final file = photos[index];
      try {
        final bytes = await file.readAsBytes();
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_$index.jpg';
        final path = '$currentUserId/$listingId/$fileName';

        await supabase.storage.from('listing-photos').uploadBinary(
              path,
              bytes,
            );

        await supabase.from('listing_photos').insert({
          'listing_id': listingId,
          'storage_path': path,
          'display_order': index,
        });
      } on Exception catch (error, stackTrace) {
        anyFailed = true;
        debugPrint('Photo upload failed for index $index: $error');
        debugPrint('$stackTrace');
      }
    }

    return anyFailed;
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
