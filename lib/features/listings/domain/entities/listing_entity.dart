import 'package:equatable/equatable.dart';

/// Domain model for a gear listing (not yet mapped from Supabase).
class ListingEntity extends Equatable {
  const ListingEntity({
    required this.id,
    required this.hostId,
    required this.title,
    required this.category,
    required this.pricePerDay,
    required this.location,
    required this.hostName,
    required this.rating,
    required this.isVerified,
    required this.description,
    required this.reviewCount,
    required this.depositAmount,
    required this.minRentalDays,
    required this.isActive,
    required this.isPaused,
    required this.lat,
    required this.lng,
  });

  final String id;
  final String hostId;
  final String title;
  final String category;
  final String pricePerDay;
  final String location;
  final String hostName;
  final double rating;
  final bool isVerified;
  final String description;
  final int reviewCount;
  final String depositAmount;
  final String minRentalDays;
  final bool isActive;
  final bool isPaused;
  final double lat;
  final double lng;

  @override
  List<Object?> get props => [
        id,
        hostId,
        title,
        category,
        pricePerDay,
        location,
        hostName,
        rating,
        isVerified,
        description,
        reviewCount,
        depositAmount,
        minRentalDays,
        isActive,
        isPaused,
        lat,
        lng,
      ];
}
