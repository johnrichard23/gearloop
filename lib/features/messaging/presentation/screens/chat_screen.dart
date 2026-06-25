import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/empty_state_widget.dart';
import '../../../../core/widgets/loading_skeleton.dart';
import '../../../bookings/domain/entities/booking_entity.dart';
import '../providers/chat_provider.dart';
import '../widgets/message_bubble.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({required this.booking, super.key});

  final BookingEntity booking;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  StreamSubscription<List<Map<String, dynamic>>>? _messagesSubscription;
  late final String _currentUserId;

  @override
  void initState() {
    super.initState();
    _currentUserId = Supabase.instance.client.auth.currentUser!.id;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialMessages();
      _subscribeToMessages();
    });
  }

  Future<void> _loadInitialMessages() async {
    await ref
        .read(chatProvider(widget.booking.id).notifier)
        .loadMessages(widget.booking.id);
  }

  void _subscribeToMessages() {
    _messagesSubscription = Supabase.instance.client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('booking_id', widget.booking.id)
        .listen((_) {
      if (!mounted) return;
      ref
          .read(chatProvider(widget.booking.id).notifier)
          .loadMessages(widget.booking.id);
    });
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) {
        return;
      }
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text;
    if (text.trim().isEmpty) {
      return;
    }

    await ref.read(chatProvider(widget.booking.id).notifier).sendMessage(
          bookingId: widget.booking.id,
          content: text,
        );

    _messageController.clear();
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final booking = widget.booking;
    final chatState = ref.watch(chatProvider(booking.id));

    ref.listen<ChatState>(chatProvider(booking.id), (previous, next) {
      if (next.status == ChatStatus.loaded &&
          next.messages.isNotEmpty &&
          previous?.messages.length != next.messages.length) {
        _scrollToBottom();
      }
    });

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        backgroundColor: AppColors.kColorPrimary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              booking.counterpartyName,
              style: AppTextStyles.kTextHeading4.copyWith(
                color: Colors.white,
              ),
            ),
            Text(
              booking.listingTitle,
              style: AppTextStyles.kTextCaption.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: _buildMessageList(chatState),
          ),
          _buildInputBar(chatState),
        ],
      ),
    );
  }

  Widget _buildMessageList(ChatState chatState) {
    if (chatState.status == ChatStatus.loading) {
      return ListView.builder(
        padding: const EdgeInsets.all(AppSpacing.kSpacing16),
        itemCount: 6,
        itemBuilder: (context, index) {
          final alignRight = index.isOdd;
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.kSpacing12),
            child: Align(
              alignment:
                  alignRight ? Alignment.centerRight : Alignment.centerLeft,
              child: LoadingSkeleton(
                width: alignRight ? 180 : 220,
                height: 48,
                radius: AppSpacing.kRadiusLarge,
              ),
            ),
          );
        },
      );
    }

    if (chatState.messages.isEmpty) {
      return const Center(
        child: EmptyStateWidget(
          icon: Icons.chat_bubble_outline,
          title: 'No messages yet',
          subtitle: 'Send a message to coordinate pickup',
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      itemCount: chatState.messages.length,
      itemBuilder: (context, index) {
        final message = chatState.messages[index];
        return MessageBubble(
          message: message,
          isMe: message.senderId == _currentUserId,
        );
      },
    );
  }

  Widget _buildInputBar(ChatState chatState) {
    final isSending = chatState.status == ChatStatus.sending;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.kColorSurface,
        border: Border(
          top: BorderSide(color: AppColors.kColorBorder),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.kSpacing12),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                enabled: !isSending,
                style: AppTextStyles.kTextBodyLarge,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                decoration: InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: AppTextStyles.kTextBodyMedium.copyWith(
                    color: AppColors.kColorTextHint,
                  ),
                  filled: true,
                  fillColor: AppColors.kColorSurfaceVariant,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.kSpacing16,
                    vertical: AppSpacing.kSpacing12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusXLarge),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusXLarge),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppSpacing.kRadiusXLarge),
                    borderSide: const BorderSide(
                      color: AppColors.kColorPrimary,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.kSpacing8),
            SizedBox(
              width: 44,
              height: 44,
              child: Material(
                color: AppColors.kColorPrimary,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: isSending ? null : _sendMessage,
                  customBorder: const CircleBorder(),
                  child: Center(
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(
                            Icons.send,
                            color: Colors.white,
                            size: 20,
                          ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
