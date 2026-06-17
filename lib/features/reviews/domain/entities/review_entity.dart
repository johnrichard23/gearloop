import 'package:equatable/equatable.dart';

/// Domain model for reviews.
class ReviewEntity extends Equatable {
  const ReviewEntity({
    required this.id,
    required this.bookingId,
    required this.reviewerId,
    required this.revieweeId,
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.isVisible,
    required this.createdAt,
    required this.listingTitle,
  });

  final String id;
  final String bookingId;
  final String reviewerId;
  final String revieweeId;
  final String reviewerName;
  final int rating;
  final String? comment;
  final bool isVisible;
  final DateTime createdAt;
  final String listingTitle;

  @override
  List<Object?> get props => [
        id,
        bookingId,
        reviewerId,
        revieweeId,
        reviewerName,
        rating,
        comment,
        isVisible,
        createdAt,
        listingTitle,
      ];
}
