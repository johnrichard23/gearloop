import 'package:equatable/equatable.dart';

/// Domain model for in-app notifications.
class NotificationEntity extends Equatable {
  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.isRead,
    required this.createdAt,
    this.relatedBookingId,
  });

  final String id;
  final String title;
  final String body;
  final String type;
  final bool isRead;
  final DateTime createdAt;
  final String? relatedBookingId;

  @override
  List<Object?> get props => [
        id,
        title,
        body,
        type,
        isRead,
        createdAt,
        relatedBookingId,
      ];
}
