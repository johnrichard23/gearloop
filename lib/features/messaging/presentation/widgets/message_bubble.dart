import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/message_entity.dart';

/// Single chat message bubble with timestamp.
class MessageBubble extends StatelessWidget {
  const MessageBubble({
    required this.message,
    required this.isMe,
    super.key,
  });

  final MessageEntity message;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.sizeOf(context).width * 0.75;
    final timeLabel = DateFormat.jm().format(message.createdAt);

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(maxWidth: maxWidth),
            margin: const EdgeInsets.symmetric(vertical: AppSpacing.kSpacing4),
            padding: const EdgeInsets.all(AppSpacing.kSpacing12),
            decoration: BoxDecoration(
              color: isMe
                  ? AppColors.kColorPrimary
                  : AppColors.kColorSurfaceVariant,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(AppSpacing.kRadiusLarge),
                topRight: const Radius.circular(AppSpacing.kRadiusLarge),
                bottomLeft: Radius.circular(
                  isMe ? AppSpacing.kRadiusLarge : AppSpacing.kSpacing4,
                ),
                bottomRight: Radius.circular(
                  isMe ? AppSpacing.kSpacing4 : AppSpacing.kRadiusLarge,
                ),
              ),
            ),
            child: Text(
              message.content,
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: isMe ? Colors.white : AppColors.kColorTextPrimary,
              ),
            ),
          ),
          Text(
            timeLabel,
            style: AppTextStyles.kTextCaption.copyWith(
              color: AppColors.kColorTextHint,
            ),
          ),
        ],
      ),
    );
  }
}
