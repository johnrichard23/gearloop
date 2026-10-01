import 'package:flutter_test/flutter_test.dart';
import 'package:rentra/features/messaging/domain/entities/message_entity.dart';

void main() {
  group('MessageEntity', () {
    test('isFromMe returns true when senderId matches the given userId', () {
      final message = _messageFixture(senderId: 'user-1');

      expect(message.isFromMe('user-1'), true);
    });

    test('isFromMe returns false when senderId does not match the given userId',
        () {
      final message = _messageFixture(senderId: 'user-3');

      expect(message.isFromMe('user-1'), false);
    });

    test('two messages with identical fields are equal via Equatable', () {
      final createdAt = DateTime(2026, 5, 15, 14, 30);
      final first = _messageFixture(createdAt: createdAt);
      final second = _messageFixture(createdAt: createdAt);

      expect(first, second);
      expect(first == second, true);
    });

    test('two messages with different content are not equal', () {
      final createdAt = DateTime(2026, 5, 15, 14, 30);
      final first = _messageFixture(
        createdAt: createdAt,
        content: 'Hello there',
      );
      final second = _messageFixture(
        createdAt: createdAt,
        content: 'Different message',
      );

      expect(first == second, false);
      expect(first, isNot(second));
    });
  });
}

MessageEntity _messageFixture({
  String senderId = 'user-1',
  DateTime? createdAt,
  String content = 'Hi! Thanks for booking the drone.',
}) {
  return MessageEntity(
    id: 'message-1',
    bookingId: 'booking-2',
    senderId: senderId,
    senderName: 'Chard D.',
    content: content,
    isRead: false,
    createdAt: createdAt ?? DateTime(2026, 5, 15, 14, 30),
  );
}
