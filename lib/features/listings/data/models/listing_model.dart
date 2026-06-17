import '../../domain/entities/listing_entity.dart';

/// Data model for gear listings; maps to Supabase `gear_listings` JSON shape.
class ListingModel extends ListingEntity {
  const ListingModel({
    required super.id,
    required super.hostId,
    required super.title,
    required super.category,
    required super.pricePerDay,
    required super.location,
    required super.hostName,
    required super.rating,
    required super.isVerified,
    required super.description,
    required super.reviewCount,
    required super.depositAmount,
    required super.minRentalDays,
    required super.isActive,
    required super.isPaused,
    required super.lat,
    required super.lng,
  });

  factory ListingModel.fromEntity(ListingEntity entity) {
    return ListingModel(
      id: entity.id,
      hostId: entity.hostId,
      title: entity.title,
      category: entity.category,
      pricePerDay: entity.pricePerDay,
      location: entity.location,
      hostName: entity.hostName,
      rating: entity.rating,
      isVerified: entity.isVerified,
      description: entity.description,
      reviewCount: entity.reviewCount,
      depositAmount: entity.depositAmount,
      minRentalDays: entity.minRentalDays,
      isActive: entity.isActive,
      isPaused: entity.isPaused,
      lat: entity.lat,
      lng: entity.lng,
    );
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    return ListingModel(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      pricePerDay: json['price_per_day'] as String,
      location: json['location_label'] as String,
      hostName: json['host_name'] as String,
      rating: (json['rating'] as num).toDouble(),
      isVerified: json['is_verified'] as bool,
      description: json['description'] as String,
      reviewCount: json['review_count'] as int,
      depositAmount: json['deposit_amount'] as String,
      minRentalDays: json['min_rental_days'].toString(),
      isActive: json['is_active'] as bool,
      isPaused: json['is_paused'] as bool,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'host_id': hostId,
      'title': title,
      'category': category,
      'price_per_day': pricePerDay,
      'location_label': location,
      'host_name': hostName,
      'rating': rating,
      'is_verified': isVerified,
      'description': description,
      'review_count': reviewCount,
      'deposit_amount': depositAmount,
      'min_rental_days': minRentalDays,
      'is_active': isActive,
      'is_paused': isPaused,
      'lat': lat,
      'lng': lng,
    };
  }
}
