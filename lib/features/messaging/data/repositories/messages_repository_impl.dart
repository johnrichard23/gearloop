import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messages_repository.dart';

/// [MessagesRepository] backed by Supabase `messages`.
class MessagesRepositoryImpl implements MessagesRepository {
  MessagesRepositoryImpl([Object? unused, SupabaseClient? client])
      : _supabase = client ?? Supabase.instance.client;

  final SupabaseClient _supabase;

  static const _messageSelect =
      '*, sender:users!sender_id(full_name)';

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessagesForBooking(
    String bookingId,
  ) async {
    try {
      final data = await _supabase
          .from('messages')
          .select(_messageSelect)
          .eq('booking_id', bookingId)
          .order('created_at', ascending: true);
      final messages = (data as List)
          .map((row) => _fromJson(row as Map<String, dynamic>))
          .toList();
      return Right(messages);
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Failed to load messages. Please try again.'),
      );
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
      final trimmed = content.trim();
      if (trimmed.isEmpty) {
        return const Left(Failure('Message cannot be empty'));
      }

      final effectiveSenderId = _supabase.auth.currentUser!.id;
      final data = await _supabase
          .from('messages')
          .insert({
            'booking_id': bookingId,
            'sender_id': effectiveSenderId,
            'content': trimmed,
            'is_read': false,
          })
          .select(_messageSelect)
          .single();
      return Right(_fromJson(data));
    } on PostgrestException catch (e) {
      return Left(Failure(e.message));
    } on Exception {
      return const Left(
        Failure('Failed to send message. Please try again.'),
      );
    }
  }

  MessageEntity _fromJson(Map<String, dynamic> json) {
    final sender = json['sender'] as Map<String, dynamic>?;

    return MessageEntity(
      id: json['id'] as String,
      bookingId: json['booking_id'] as String,
      senderId: json['sender_id'] as String,
      senderName: sender?['full_name'] as String? ?? 'Unknown User',
      content: json['content'] as String,
      isRead: json['is_read'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
