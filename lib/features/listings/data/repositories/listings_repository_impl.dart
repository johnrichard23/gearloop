import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/listing_entity.dart';
import '../../domain/repositories/listings_repository.dart';
import '../models/listing_model.dart';

/// [ListingsRepository] backed by Supabase `gear_listings`.
class ListingsRepositoryImpl implements ListingsRepository {
  ListingsRepositoryImpl([Object? unused, SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  @override
  Future<Either<Failure, ListingEntity>> createListing(
    ListingEntity listing,
  ) async {
    try {
      // RLS requires host_id to match auth.uid().
      final hostId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('gear_listings')
          .insert(_toRow(listing, hostId: hostId))
          .select()
          .single();
      return Right(ListingModel.fromJson(data));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to create listing. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> updateListing(
    ListingEntity listing,
  ) async {
    try {
      final data = await _supabase
          .from('gear_listings')
          .update(_toRow(listing))
          .eq('id', listing.id)
          .select()
          .single();
      return Right(ListingModel.fromJson(data));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to update listing. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ListingEntity>>> getListingsByLocation({
    required double lat,
    required double lng,
    required double radiusKm,
  }) async {
    try {
      // TODO: Add PostGIS distance filtering via RPC function once ST_DWithin query is set up
      final response = await _supabase
          .from('gear_listings')
          .select()
          .eq('is_active', true)
          .eq('is_paused', false);
      debugPrint('RAW LISTINGS RESPONSE: $response');
      final listings = (response as List)
          .map((row) => ListingModel.fromJson(row as Map<String, dynamic>))
          .toList();
      return Right(listings);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to load listings. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, ListingEntity>> getListingById(String id) async {
    try {
      final data = await _supabase
          .from('gear_listings')
          .select()
          .eq('id', id)
          .single();
      return Right(ListingModel.fromJson(data));
    } on PostgrestException {
      return const Left(Failure('Listing not found'));
    } on Exception {
      return const Left(Failure('Listing not found'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteListing(String id) async {
    try {
      await _supabase.from('gear_listings').delete().eq('id', id);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to delete listing. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> pauseListing(String id) async {
    try {
      await _supabase
          .from('gear_listings')
          .update({'is_paused': true})
          .eq('id', id);
      return const Right(null);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return Left(
        const Failure('Failed to pause listing. Please try again.'),
      );
    }
  }

  Map<String, dynamic> _toRow(ListingEntity listing, {String? hostId}) {
    final row = <String, dynamic>{
      'title': listing.title,
      'description': listing.description,
      'category': listing.category,
      'price_per_day': _parsePesoAmount(listing.pricePerDay),
      'deposit_amount': _parsePesoAmount(listing.depositAmount),
      'min_rental_days': int.tryParse(listing.minRentalDays) ?? 1,
      'location_label': listing.location,
      'location':
          'SRID=4326;POINT(${listing.lng} ${listing.lat})',
    };
    if (hostId != null) {
      row['host_id'] = hostId;
    }
    return row;
  }

  double _parsePesoAmount(String value) {
    final cleaned = value.replaceAll(RegExp(r'[₱,\s]'), '');
    if (cleaned.isEmpty) {
      return 0;
    }
    return double.parse(cleaned);
  }
}
