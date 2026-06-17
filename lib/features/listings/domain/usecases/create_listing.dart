import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/listing_entity.dart';
import '../repositories/listings_repository.dart';

/// Creates a new gear listing after validating required fields.
class CreateListing {
  const CreateListing(this.repository);

  final ListingsRepository repository;

  Future<Either<Failure, ListingEntity>> call(ListingEntity listing) async {
    if (listing.title.trim().isEmpty) {
      return const Left(Failure('Title is required'));
    }
    if (listing.pricePerDay.trim().isEmpty) {
      return const Left(Failure('Price is required'));
    }
    if (listing.location.trim().isEmpty) {
      return const Left(Failure('Location is required'));
    }
    if (listing.category.trim().isEmpty) {
      return const Left(Failure('Category is required'));
    }

    return repository.createListing(listing);
  }
}
