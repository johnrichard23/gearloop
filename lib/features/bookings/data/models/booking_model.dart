import '../../domain/entities/booking_entity.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.listingId,
    required super.renterId,
    required super.hostId,
    required super.startDate,
    required super.endDate,
    required super.totalDays,
    required super.dailyRate,
    required super.subtotal,
    required super.platformFee,
    required super.depositAmount,
    required super.totalAmount,
    required super.status,
    required super.paymentStatus,
    required super.notes,
    required super.createdAt,
    required super.respondedAt,
    required super.listingTitle,
    required super.listingCategory,
    required super.counterpartyName,
    required super.counterpartyVerified,
  });

  factory BookingModel.fromEntity(BookingEntity entity) {
    return BookingModel(
      id: entity.id,
      listingId: entity.listingId,
      renterId: entity.renterId,
      hostId: entity.hostId,
      startDate: entity.startDate,
      endDate: entity.endDate,
      totalDays: entity.totalDays,
      dailyRate: entity.dailyRate,
      subtotal: entity.subtotal,
      platformFee: entity.platformFee,
      depositAmount: entity.depositAmount,
      totalAmount: entity.totalAmount,
      status: entity.status,
      paymentStatus: entity.paymentStatus,
      notes: entity.notes,
      createdAt: entity.createdAt,
      respondedAt: entity.respondedAt,
      listingTitle: entity.listingTitle,
      listingCategory: entity.listingCategory,
      counterpartyName: entity.counterpartyName,
      counterpartyVerified: entity.counterpartyVerified,
    );
  }

  factory BookingModel.fromJson(
    Map<String, dynamic> json, {
    String? currentUserId,
  }) {
    final listing = json['gear_listings'] as Map<String, dynamic>?;
    final host = json['host'] as Map<String, dynamic>?;
    final renter = json['renter'] as Map<String, dynamic>?;
    final counterparty = _resolveCounterparty(
      json: json,
      host: host,
      renter: renter,
      currentUserId: currentUserId,
    );

    return BookingModel(
      id: json['id'] as String,
      listingId: json['listing_id'] as String,
      renterId: json['renter_id'] as String,
      hostId: json['host_id'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      totalDays: (json['total_days'] as num).toInt(),
      dailyRate: (json['daily_rate'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
      platformFee: (json['platform_fee'] as num).toDouble(),
      depositAmount: (json['deposit_amount'] as num).toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      status: _statusFromString(json['status'] as String),
      paymentStatus: _paymentStatusFromString(json['payment_status'] as String),
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      respondedAt: json['responded_at'] == null
          ? null
          : DateTime.parse(json['responded_at'] as String),
      listingTitle: listing?['title'] as String? ?? 'Unknown Listing',
      listingCategory: listing?['category'] as String? ?? '',
      counterpartyName: counterparty.$1,
      counterpartyVerified: counterparty.$2,
    );
  }

  static (String, bool) _resolveCounterparty({
    required Map<String, dynamic> json,
    required Map<String, dynamic>? host,
    required Map<String, dynamic>? renter,
    required String? currentUserId,
  }) {
    final hostId = json['host_id'] as String?;
    final renterId = json['renter_id'] as String?;

    if (currentUserId != null &&
        currentUserId == hostId &&
        renter != null) {
      return (
        renter['full_name'] as String? ?? 'Unknown User',
        renter['is_id_verified'] as bool? ?? false,
      );
    }
    if (currentUserId != null &&
        currentUserId == renterId &&
        host != null) {
      return (
        host['full_name'] as String? ?? 'Unknown User',
        host['is_id_verified'] as bool? ?? false,
      );
    }
    if (host != null) {
      return (
        host['full_name'] as String? ?? 'Unknown User',
        host['is_id_verified'] as bool? ?? false,
      );
    }
    if (renter != null) {
      return (
        renter['full_name'] as String? ?? 'Unknown User',
        renter['is_id_verified'] as bool? ?? false,
      );
    }
    return ('Unknown User', false);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'listing_id': listingId,
      'renter_id': renterId,
      'host_id': hostId,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'total_days': totalDays,
      'daily_rate': dailyRate,
      'subtotal': subtotal,
      'platform_fee': platformFee,
      'deposit_amount': depositAmount,
      'total_amount': totalAmount,
      'status': status.name,
      'payment_status': paymentStatus.name,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'responded_at': respondedAt?.toIso8601String(),
      'listing_title': listingTitle,
      'listing_category': listingCategory,
      'counterparty_name': counterpartyName,
      'counterparty_verified': counterpartyVerified,
    };
  }

  static BookingStatus _statusFromString(String value) {
    return BookingStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => BookingStatus.pending,
    );
  }

  static PaymentStatus _paymentStatusFromString(String value) {
    return PaymentStatus.values.firstWhere(
      (s) => s.name == value,
      orElse: () => PaymentStatus.unpaid,
    );
  }
}
