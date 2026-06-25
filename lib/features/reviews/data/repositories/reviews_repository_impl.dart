import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/review_entity.dart';
import '../../domain/repositories/reviews_repository.dart';

/// [ReviewsRepository] backed by Supabase `reviews`.
class ReviewsRepositoryImpl implements ReviewsRepository {
  ReviewsRepositoryImpl([Object? unused, SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const _reviewListSelect =
      '*, bookings(listing_id, gear_listings(title)), reviewer:users!reviewer_id(full_name)';

  @override
  Future<Either<Failure, ReviewEntity>> submitReview({
    required String bookingId,
    required String reviewerId,
    required String revieweeId,
    required int rating,
    String? comment,
  }) async {
    try {
      final effectiveReviewerId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('reviews')
          .insert({
            'booking_id': bookingId,
            'reviewer_id': effectiveReviewerId,
            'reviewee_id': revieweeId,
            'rating': rating,
            'comment': comment,
            'is_visible': false,
          })
          .select()
          .single();
      return Right(_fromJson(data));
    } on PostgrestException catch (e) {
      if (e.code == '23505') {
        return const Left(
          Failure('You have already reviewed this booking'),
        );
      }
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Failed to submit review. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getReviewsForUser(
    String userId,
  ) async {
    try {
      final data = await _supabase
          .from('reviews')
          .select(_reviewListSelect)
          .eq('reviewee_id', userId)
          .eq('is_visible', true)
          .order('created_at', ascending: false);
      final reviews = (data as List)
          .map((row) => _fromJson(row as Map<String, dynamic>))
          .toList();
      return Right(reviews);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Failed to load reviews. Please try again.'),
      );
    }
  }

  @override
  Future<Either<Failure, bool>> hasReviewed({
    required String bookingId,
    required String reviewerId,
  }) async {
    try {
      final effectiveReviewerId =
          _supabase.auth.currentUser?.id ?? reviewerId;
      final data = await _supabase
          .from('reviews')
          .select('id')
          .eq('booking_id', bookingId)
          .eq('reviewer_id', effectiveReviewerId)
          .maybeSingle();
      return Right(data != null);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Failed to check review status. Please try again.'),
      );
    }
  }

  ReviewEntity _fromJson(Map<String, dynamic> json) {
    final reviewer = json['reviewer'] as Map<String, dynamic>?;
    final booking = json['bookings'] as Map<String, dynamic>?;
    final gearListing = booking?['gear_listings'] as Map<String, dynamic>?;

    return ReviewEntity(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      reviewerId: json['reviewer_id'] as String,
      revieweeId: json['reviewee_id'] as String,
      reviewerName: reviewer?['full_name'] as String? ?? 'Unknown User',
      rating: (json['rating'] as num).toInt(),
      comment: json['comment'] as String?,
      isVisible: json['is_visible'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      listingTitle: gearListing?['title'] as String? ?? 'Unknown Listing',
    );
  }
}
