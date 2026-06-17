import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/repositories/listings_repository.dart';
import '../datasources/listings_remote_datasource.dart';
import '../models/listing_model.dart';

/// [ListingsRepository] backed by [ListingsRemoteDatasource].
class ListingsRepositoryImpl implements ListingsRepository {
  ListingsRepositoryImpl(this._remoteDatasource);

  final ListingsRemoteDatasource _remoteDatasource;

  @override
  Future<Either<Failure, ListingEntity>> createListing(
    ListingEntity listing,
  ) async {
    try {
      final model = ListingModel.fromEntity(listing);
      final result = await _remoteDatasource.createListing(model);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> updateListing(
    ListingEntity listing,
  ) async {
    try {
      final model = ListingModel.fromEntity(listing);
      final result = await _remoteDatasource.updateListing(model);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getListingsByLocation({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    try {
      final results = await _remoteDatasource.getListingsByLocation(
        lat,
        lng,
        radiusKm,
      );
      return Right(results);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> getListingById(String id) async {
    try {
      final result = await _remoteDatasource.getListingById(id);
      return Right(result);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String id) async {
    try {
      await _remoteDatasource.deleteListing(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> pauseListing(String id) async {
    try {
      await _remoteDatasource.pauseListing(id);
      return const Right(null);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
