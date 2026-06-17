import 'package:equatable/equatable.dart';

/// Domain model for booking-scoped chat messages.
class MessageEntity extends Equatable {
  const MessageEntity({
    required this.id,
    required this.bookingId,
    required this.senderId,
    required this.senderName,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  final String id;
  final String bookingId;
  final String senderId;
  final String senderName;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  bool isFromMe(String currentUserId) => senderId == currentUserId;

  @override
  List<Object?> get props => [
        id,
        bookingId,
        senderId,
        senderName,
        content,
        isRead,
        createdAt,
      ];
}
