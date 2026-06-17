import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messages_repository.dart';

class MessagesRepositoryImpl implements MessagesRepository {
  static final List<MessageEntity> _store = _seedMessages();

  static List<MessageEntity> _seedMessages() {
    final now = DateTime.now();

    return [
      MessageEntity(
        id: 'message-1',
        bookingId: 'booking-2',
        senderId: 'user-3',
        senderName: 'Marco R.',
        content:
            'Hi! Thanks for booking the drone. What time works for pickup?',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      MessageEntity(
        id: 'message-2',
        bookingId: 'booking-2',
        senderId: 'user-1',
        senderName: 'Chard D.',
        content: 'Hi Marco! Would tomorrow around 2pm work for you?',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 23)),
      ),
      MessageEntity(
        id: 'message-3',
        bookingId: 'booking-2',
        senderId: 'user-3',
        senderName: 'Marco R.',
        content:
            'That works great. I am in Legazpi, near the public market. I will send the exact pin once you confirm.',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 22)),
      ),
      MessageEntity(
        id: 'message-4',
        bookingId: 'booking-2',
        senderId: 'user-1',
        senderName: 'Chard D.',
        content: 'Perfect, see you then!',
        isRead: true,
        createdAt: now.subtract(const Duration(hours: 21)),
      ),
    ];
  }

  Future<void> _simulateDelay() {
    return Future<void>.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessagesForBooking(
    String bookingId,
  ) async {
    try {
      await _simulateDelay();
      final messages = _store
          .where((message) => message.bookingId == bookingId)
          .toList()
        ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
      return Right(messages);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MessageEntity>> sendMessage({
    required String bookingId,
    required String senderId,
    required String senderName,
    required String content,
  }) async {
    try {
      await _simulateDelay();

      final trimmed = content.trim();
      if (trimmed.isEmpty) {
        throw Exception('Message cannot be empty');
      }

      final message = MessageEntity(
        id: 'message-${DateTime.now().microsecondsSinceEpoch}',
        bookingId: bookingId,
        senderId: senderId,
        senderName: senderName,
        content: trimmed,
        isRead: false,
        createdAt: DateTime.now(),
      );
      _store.add(message);
      return Right(message);
    } on Exception catch (e) {
      return Left(Failure(e.toString()));
    }
  }
}
