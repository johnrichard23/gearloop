import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCenterScreen extends StatefulWidget {
  const NotificationCenterScreen({super.key});

  @override
  State<NotificationCenterScreen> createState() =>
      _NotificationCenterScreenState();
}

class _NotificationCenterScreenState extends State<NotificationCenterScreen> {
  late List<NotificationEntity> _notifications;

  @override
  void initState() {
    super.initState();
    _notifications = _dummyNotifications();
  }

  static List<NotificationEntity> _dummyNotifications() {
    final now = DateTime.now();

    return [
      NotificationEntity(
        id: 'notif-1',
        type: 'booking_request',
        title: 'New booking request',
        body: 'Marco R. wants to rent your Sony A7III Camera Body',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 2)),
        relatedBookingId: 'booking-1',
      ),
      NotificationEntity(
        id: 'notif-2',
        type: 'new_message',
        title: 'New message from Marco R.',
        body: 'That works great. I am in Legazpi...',
        isRead: false,
        createdAt: now.subtract(const Duration(hours: 5)),
        relatedBookingId: 'booking-2',
      ),
      NotificationEntity(
        id: 'notif-3',
        type: 'booking_accepted',
        title: 'Booking accepted!',
        body: 'Your DJI Mini 3 Pro Drone booking was accepted',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 1)),
        relatedBookingId: 'booking-2',
      ),
      NotificationEntity(
        id: 'notif-4',
        type: 'review_received',
        title: 'New review',
        body: 'Leo M. left you a 4-star review',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 4)),
      ),
      NotificationEntity(
        id: 'notif-5',
        type: 'payment_received',
        title: 'Payment received',
        body: '₱896 was added to your earnings',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 5)),
      ),
      NotificationEntity(
        id: 'notif-6',
        type: 'booking_declined',
        title: 'Booking declined',
        body: 'Grace P. declined your guitar booking request',
        isRead: true,
        createdAt: now.subtract(const Duration(days: 6)),
        relatedBookingId: 'booking-5',
      ),
    ];
  }

  void _markAllRead() {
    setState(() {
      _notifications = _notifications
          .map(
            (notification) => NotificationEntity(
              id: notification.id,
              title: notification.title,
              body: notification.body,
              type: notification.type,
              isRead: true,
              createdAt: notification.createdAt,
              relatedBookingId: notification.relatedBookingId,
            ),
          )
          .toList();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All marked as read')),
    );
  }

  void _onNotificationTap() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening... (coming soon)')),
    );
  }

  String _formatRelativeTime(DateTime createdAt) {
    final diff = DateTime.now().difference(createdAt);
    if (diff.inHours < 24) {
      final hours = diff.inHours < 1 ? 1 : diff.inHours;
      return '${hours}h ago';
    }
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          TextButton(
            onPressed: _markAllRead,
            child: Text(
              'Mark all read',
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: AppColors.kColorPrimary,
              ),
            ),
          ),
        ],
      ),
      body: ListView.separated(
        itemCount: _notifications.length,
        separatorBuilder: (_, __) =>
            const Divider(height: 1, color: AppColors.kColorBorder),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _NotificationRow(
            notification: notification,
            relativeTime: _formatRelativeTime(notification.createdAt),
            onTap: _onNotificationTap,
          );
        },
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({
    required this.notification,
    required this.relativeTime,
    required this.onTap,
  });

  final NotificationEntity notification;
  final String relativeTime;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final iconStyle = _iconStyleForType(notification.type);

    return Material(
      color: notification.isRead
          ? AppColors.kColorSurface
          : AppColors.kColorPrimaryFaded.withValues(alpha: 0.35),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.kSpacing16,
            vertical: AppSpacing.kSpacing12,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconStyle.backgroundColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconStyle.icon,
                  color: iconStyle.iconColor,
                  size: AppSpacing.kIconMedium,
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTextStyles.kTextBodyMedium.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.w400
                            : FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.kSpacing4),
                    Text(
                      notification.body,
                      style: AppTextStyles.kTextBodySmall.copyWith(
                        color: AppColors.kColorTextSecondary,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (!notification.isRead)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(
                        bottom: AppSpacing.kSpacing4,
                      ),
                      decoration: const BoxDecoration(
                        color: AppColors.kColorPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  Text(
                    relativeTime,
                    style: AppTextStyles.kTextCaption.copyWith(
                      color: AppColors.kColorTextHint,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _NotificationIconStyle _iconStyleForType(String type) {
    switch (type) {
      case 'booking_request':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorWarningLight,
          icon: Icons.calendar_today,
          iconColor: AppColors.kColorWarning,
        );
      case 'booking_accepted':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorSuccessLight,
          icon: Icons.check_circle,
          iconColor: AppColors.kColorSuccess,
        );
      case 'booking_declined':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorErrorLight,
          icon: Icons.cancel,
          iconColor: AppColors.kColorError,
        );
      case 'new_message':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorPrimaryFaded,
          icon: Icons.chat_bubble,
          iconColor: AppColors.kColorPrimary,
        );
      case 'review_received':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorAccentLight,
          icon: Icons.star,
          iconColor: AppColors.kColorAccent,
        );
      case 'payment_received':
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorSuccessLight,
          icon: Icons.payments,
          iconColor: AppColors.kColorSuccess,
        );
      default:
        return const _NotificationIconStyle(
          backgroundColor: AppColors.kColorSurfaceVariant,
          icon: Icons.notifications,
          iconColor: AppColors.kColorTextSecondary,
        );
    }
  }
}

class _NotificationIconStyle {
  const _NotificationIconStyle({
    required this.backgroundColor,
    required this.icon,
    required this.iconColor,
  });

  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;
}
