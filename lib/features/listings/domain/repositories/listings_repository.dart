import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/listing_entity.dart';

/// Contract for gear listing persistence and queries.
abstract interface class ListingsRepository {
  Future<Either<Failure, ListingEntity>> createListing(ListingEntity listing);

  Future<Either<Failure, ListingEntity>> updateListing(ListingEntity listing);

  Future<Either<Failure, List<ListingEntity>>> getListingsByLocation({
    required double lat,
    required double lng,
    required double radiusKm,
  });

  Future<Either<Failure, ListingEntity>> getListingById(String id);

  Future<Either<Failure, void>> deleteListing(String id);

  Future<Either<Failure, void>> pauseListing(String id);
}
