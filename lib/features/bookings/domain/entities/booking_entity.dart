import 'package:equatable/equatable.dart';

enum BookingStatus {
  pending,
  accepted,
  active,
  completed,
  declined,
  cancelled,
  disputed,
}

enum PaymentStatus {
  unpaid,
  held,
  released,
  refunded,
}

/// Domain model for bookings.
class BookingEntity extends Equatable {
  const BookingEntity({
    required this.id,
    required this.listingId,
    required this.renterId,
    required this.hostId,
    required this.startDate,
    required this.endDate,
    required this.totalDays,
    required this.dailyRate,
    required this.subtotal,
    required this.platformFee,
    required this.depositAmount,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.notes,
    required this.createdAt,
    required this.respondedAt,
    required this.listingTitle,
    required this.listingCategory,
    required this.counterpartyName,
    required this.counterpartyVerified,
  });

  final String id;
  final String listingId;
  final String renterId;
  final String hostId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalDays;
  final double dailyRate;
  final double subtotal;
  final double platformFee;
  final double depositAmount;
  final double totalAmount;
  final BookingStatus status;
  final PaymentStatus paymentStatus;
  final String? notes;
  final DateTime createdAt;
  final DateTime? respondedAt;

  // Joined/UI fields
  final String listingTitle;
  final String listingCategory;
  final String counterpartyName;
  final bool counterpartyVerified;

  Duration? get timeUntilExpiry {
    if (status != BookingStatus.pending) {
      return null;
    }
    final expiry = createdAt.add(const Duration(hours: 24));
    return expiry.difference(DateTime.now());
  }

  bool get isExpired {
    if (status != BookingStatus.pending) {
      return false;
    }
    final remaining = timeUntilExpiry;
    if (remaining == null) {
      return false;
    }
    return remaining <= Duration.zero;
  }

  @override
  List<Object?> get props => [
        id,
        listingId,
        renterId,
        hostId,
        startDate,
        endDate,
        totalDays,
        dailyRate,
        subtotal,
        platformFee,
        depositAmount,
        totalAmount,
        status,
        paymentStatus,
        notes,
        createdAt,
        respondedAt,
        listingTitle,
        listingCategory,
        counterpartyName,
        counterpartyVerified,
      ];
}
