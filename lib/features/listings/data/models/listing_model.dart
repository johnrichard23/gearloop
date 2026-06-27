import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

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
    super.photoUrls,
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
      photoUrls: entity.photoUrls,
    );
  }

  factory ListingModel.fromJson(Map<String, dynamic> json) {
    final coordinates = _parseCoordinates(json['location']);

    return ListingModel(
      id: json['id'] as String,
      hostId: json['host_id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      pricePerDay: _formatPrice(json['price_per_day']),
      location: json['location_label'] as String,
      hostName: json['host_name'] as String? ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0,
      isVerified: json['is_verified'] as bool? ?? false,
      description: json['description'] as String,
      reviewCount: json['review_count'] as int? ?? 0,
      depositAmount: _formatPrice(json['deposit_amount']),
      minRentalDays: json['min_rental_days'].toString(),
      isActive: json['is_active'] as bool? ?? true,
      isPaused: json['is_paused'] as bool? ?? false,
      lat: coordinates.$1,
      lng: coordinates.$2,
      photoUrls: _parsePhotoUrls(json),
    );
  }

  static List<String> _parsePhotoUrls(Map<String, dynamic> json) {
    final photosRaw = json['listing_photos'];
    if (photosRaw is! List || photosRaw.isEmpty) {
      return const [];
    }

    final sorted = photosRaw
        .map((photo) => photo as Map<String, dynamic>)
        .toList()
      ..sort(
        (a, b) => ((a['display_order'] as num?) ?? 0)
            .compareTo((b['display_order'] as num?) ?? 0),
      );

    return sorted
        .map((photo) {
          final path = photo['storage_path'] as String?;
          if (path == null || path.isEmpty) {
            return null;
          }
          return Supabase.instance.client.storage
              .from('listing-photos')
              .getPublicUrl(path);
        })
        .whereType<String>()
        .toList();
  }

  static (double, double) _parseCoordinates(dynamic location) {
    if (location is Map<String, dynamic>) {
      try {
        final coords = location['coordinates'];
        if (coords is List && coords.length >= 2) {
          return (
            (coords[1] as num).toDouble(),
            (coords[0] as num).toDouble(),
          );
        }
      } on Exception {
        // Fall through to default.
      }
    } else if (location is String && location.length >= 50) {
      try {
        // Skip the 18-character header
        // (byte order + type + SRID), then read 16 hex chars for X
        // (lng), then 16 hex chars for Y (lat)
        final xHex = location.substring(18, 34);
        final yHex = location.substring(34, 50);

        final lng = _hexToDouble(xHex);
        final lat = _hexToDouble(yHex);

        return (lat, lng);
      } on Exception {
        // Fall through to default.
      }
    }
    return (0.0, 0.0);
  }

  static double _hexToDouble(String hex) {
    // Convert little-endian hex string to a double using ByteData
    final bytes = <int>[];
    for (var i = 0; i < hex.length; i += 2) {
      bytes.add(int.parse(hex.substring(i, i + 2), radix: 16));
    }
    final byteData = ByteData.sublistView(Uint8List.fromList(bytes));
    return byteData.getFloat64(0, Endian.little);
  }

  static String _formatPrice(dynamic value) {
    if (value == null) {
      return '₱0';
    }
    if (value is String) {
      return value.startsWith('₱') ? value : '₱$value';
    }
    if (value is num) {
      final amount =
          value == value.roundToDouble() ? value.toInt() : value.toDouble();
      return '₱$amount';
    }
    return '₱$value';
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
      'photo_urls': photoUrls,
    };
  }
}
