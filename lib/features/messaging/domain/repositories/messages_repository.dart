import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/message_entity.dart';

abstract class MessagesRepository {
  Future<Either<Failure, List<MessageEntity>>> getMessagesForBooking(
    String bookingId,
  );

  Future<Either<Failure, MessageEntity>> sendMessage({
    required String bookingId,
    required String senderId,
    required String senderName,
    required String content,
  });
}
