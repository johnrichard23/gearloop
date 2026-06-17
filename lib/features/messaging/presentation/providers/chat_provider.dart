import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/messages_repository_impl.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/messages_repository.dart';

enum ChatStatus {
  idle,
  loading,
  loaded,
  sending,
  error,
}

class ChatState {
  const ChatState({
    this.status = ChatStatus.idle,
    this.messages = const [],
    this.errorMessage,
  });

  final ChatStatus status;
  final List<MessageEntity> messages;
  final String? errorMessage;

  ChatState copyWith({
    ChatStatus? status,
    List<MessageEntity>? messages,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier(this._repository) : super(const ChatState());

  final MessagesRepository _repository;

  Future<void> loadMessages(String bookingId) async {
    state = state.copyWith(
      status: ChatStatus.loading,
      clearError: true,
    );

    final result = await _repository.getMessagesForBooking(bookingId);

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (messages) => state = state.copyWith(
        status: ChatStatus.loaded,
        messages: messages,
      ),
    );
  }

  Future<void> sendMessage({
    required String bookingId,
    required String content,
  }) async {
    final trimmed = content.trim();
    if (trimmed.isEmpty) {
      return;
    }

    state = state.copyWith(
      status: ChatStatus.sending,
      clearError: true,
    );

    final result = await _repository.sendMessage(
      bookingId: bookingId,
      senderId: 'user-1',
      senderName: 'Chard D.',
      content: trimmed,
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: ChatStatus.error,
        errorMessage: failure.message,
      ),
      (message) => state = state.copyWith(
        status: ChatStatus.loaded,
        messages: [...state.messages, message],
      ),
    );
  }
}

final chatProvider = StateNotifierProvider.autoDispose
    .family<ChatNotifier, ChatState, String>((ref, bookingId) {
  final repository = MessagesRepositoryImpl();
  return ChatNotifier(repository);
});
