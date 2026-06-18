import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../listings/domain/entities/listing_entity.dart';
import '../../domain/entities/user_profile_entity.dart';

const UserProfileEntity dummyUser = UserProfileEntity(
  id: 'user-1',
  fullName: 'Chard Dela Cruz',
  email: 'chard@gearloop.ph',
  phone: '+63 912 345 6789',
  avatarUrl: null,
  memberSince: 'May 2026',
  ratingAvg: 4.9,
  ratingCount: 12,
  isEmailVerified: true,
  isPhoneVerified: true,
  isIdVerified: true,
  isHost: true,
  totalListings: 3,
  totalRentals: 8,
);

const List<ListingEntity> _dummyMyListings = [
  ListingEntity(
    id: 'listing-1',
    hostId: 'user-1',
    title: 'Sony A7III Camera Body',
    category: 'Cameras',
    pricePerDay: '₱800',
    location: 'Legazpi, Albay',
    hostName: 'Chard D.',
    rating: 4.8,
    isVerified: true,
    description: 'Sony A7III in excellent condition.',
    reviewCount: 8,
    depositAmount: '₱5,000',
    minRentalDays: '1',
    isActive: true,
    isPaused: false,
    lat: 13.1391,
    lng: 123.7438,
  ),
  ListingEntity(
    id: 'listing-2',
    hostId: 'user-1',
    title: 'DJI Mini 3 Pro Drone',
    category: 'Drones',
    pricePerDay: '₱1,200',
    location: 'Sorsogon City',
    hostName: 'Chard D.',
    rating: 5.0,
    isVerified: true,
    description: 'DJI Mini 3 Pro with RC controller.',
    reviewCount: 4,
    depositAmount: '₱8,000',
    minRentalDays: '1',
    isActive: true,
    isPaused: false,
    lat: 12.9734,
    lng: 124.0067,
  ),
];

class _DummyReview {
  const _DummyReview({
    required this.reviewerName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.gearRented,
  });

  final String reviewerName;
  final int rating;
  final String comment;
  final String date;
  final String gearRented;
}

const List<_DummyReview> _dummyReviews = [
  _DummyReview(
    reviewerName: 'Marco R.',
    rating: 5,
    comment:
        'Chard was amazing! Camera was in perfect condition, very communicative and professional.',
    date: 'May 15, 2026',
    gearRented: 'Sony A7III Camera Body',
  ),
  _DummyReview(
    reviewerName: 'Anna S.',
    rating: 5,
    comment:
        'Super smooth transaction. Drone was clean and fully charged. Highly recommend!',
    date: 'May 10, 2026',
    gearRented: 'DJI Mini 3 Pro Drone',
  ),
  _DummyReview(
    reviewerName: 'Leo M.',
    rating: 4,
    comment:
        'Good experience overall. Gear was as described. Will rent again.',
    date: 'April 28, 2026',
    gearRented: 'Sony A7III Camera Body',
  ),
];

/// User profile tab (dummy data until Supabase is wired).
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Coming soon!')),
    );
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(
              'Log Out',
              style: AppTextStyles.kTextBodyMedium.copyWith(
                color: AppColors.kColorError,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(user: dummyUser),
            _VerificationsSection(user: dummyUser),
            if (dummyUser.isHost)
              _MyListingsSection(
                onSeeAll: () => _showComingSoon(context),
              ),
            _ReviewsSection(reviews: _dummyReviews),
            _SettingsSection(
              onEditProfile: () =>
                  context.push('/edit-profile', extra: dummyUser),
              onNotifications: () => _showComingSoon(context),
              onPrivacy: () => _showComingSoon(context),
              onHelp: () => _showComingSoon(context),
              onLogout: () => _showLogoutDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});

  final UserProfileEntity user;

  String get _initials {
    final trimmed = user.fullName.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.kSpacing24),
      color: AppColors.kColorPrimary,
      child: Column(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundColor: AppColors.kColorPrimaryLight,
            backgroundImage:
                user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : null,
            child: user.avatarUrl == null
                ? Text(
                    _initials,
                    style: AppTextStyles.kTextHeading2.copyWith(
                      color: Colors.white,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: AppSpacing.kSpacing12),
          Text(
            user.fullName,
            style: AppTextStyles.kTextHeading3.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing4),
          Text(
            user.email,
            style: AppTextStyles.kTextBodySmall.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.kSpacing24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatBox(
                value: '${user.totalRentals}',
                label: 'Rentals',
              ),
              _VerticalDivider(),
              _StatBox(
                value: '${user.ratingAvg.toStringAsFixed(1)} ⭐',
                label: 'Rating',
              ),
              _VerticalDivider(),
              _StatBox(
                value: '${user.totalListings}',
                label: 'Listings',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: AppTextStyles.kTextHeading4.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.kSpacing4),
          Text(
            label,
            style: AppTextStyles.kTextCaption.copyWith(
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withValues(alpha: 0.4),
    );
  }
}

class _VerificationsSection extends StatelessWidget {
  const _VerificationsSection({required this.user});

  final UserProfileEntity user;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.kColorSurface,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.kSpacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Verifications', style: AppTextStyles.kTextHeading4),
            const SizedBox(height: AppSpacing.kSpacing12),
            _VerificationRow(
              icon: Icons.email_outlined,
              label: 'Email',
              isVerified: user.isEmailVerified,
            ),
            const Divider(color: AppColors.kColorBorder),
            _VerificationRow(
              icon: Icons.phone_outlined,
              label: 'Phone',
              isVerified: user.isPhoneVerified,
            ),
            const Divider(color: AppColors.kColorBorder),
            _VerificationRow(
              icon: Icons.badge_outlined,
              label: 'ID',
              isVerified: user.isIdVerified,
            ),
          ],
        ),
      ),
    );
  }
}

class _VerificationRow extends StatelessWidget {
  const _VerificationRow({
    required this.icon,
    required this.label,
    required this.isVerified,
  });

  final IconData icon;
  final String label;
  final bool isVerified;

  @override
  Widget build(BuildContext context) {
    final color =
        isVerified ? AppColors.kColorSuccess : AppColors.kColorTextHint;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.kSpacing8),
      child: Row(
        children: [
          Icon(icon, color: color, size: AppSpacing.kIconMedium),
          const SizedBox(width: AppSpacing.kSpacing12),
          Text(
            label,
            style: AppTextStyles.kTextBodyMedium.copyWith(color: color),
          ),
          const Spacer(),
          Icon(
            isVerified ? Icons.check_circle : Icons.cancel_outlined,
            color: color,
            size: AppSpacing.kIconMedium,
          ),
        ],
      ),
    );
  }
}

class _MyListingsSection extends StatelessWidget {
  const _MyListingsSection({required this.onSeeAll});

  final VoidCallback onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('My Listings', style: AppTextStyles.kTextHeading4),
              TextButton(onPressed: onSeeAll, child: const Text('See All')),
            ],
          ),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _dummyMyListings.length,
            separatorBuilder: (_, __) =>
                const SizedBox(height: AppSpacing.kSpacing12),
            itemBuilder: (context, index) {
              return _MyListingCard(listing: _dummyMyListings[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _MyListingCard extends StatelessWidget {
  const _MyListingCard({required this.listing});

  final ListingEntity listing;

  @override
  Widget build(BuildContext context) {
    final statusLabel = listing.isPaused ? 'Paused' : 'Active';
    final statusColor = listing.isPaused
        ? AppColors.kColorWarning
        : AppColors.kColorSuccess;
    final statusBg = listing.isPaused
        ? AppColors.kColorWarningLight
        : AppColors.kColorSuccessLight;

    return Card(
      color: AppColors.kColorSurface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSpacing.kRadiusMedium),
        side: const BorderSide(color: AppColors.kColorBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.kSpacing12),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.kColorSurfaceVariant,
                borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
              ),
              child: const Icon(
                Icons.camera_alt_outlined,
                color: AppColors.kColorTextHint,
              ),
            ),
            const SizedBox(width: AppSpacing.kSpacing12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(listing.title, style: AppTextStyles.kTextHeading4),
                  const SizedBox(height: AppSpacing.kSpacing4),
                  Text(listing.category, style: AppTextStyles.kTextBodySmall),
                  const SizedBox(height: AppSpacing.kSpacing4),
                  Text(
                    '${listing.pricePerDay}/day',
                    style: AppTextStyles.kTextPriceSmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.kSpacing8,
                vertical: AppSpacing.kSpacing4,
              ),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(AppSpacing.kRadiusSmall),
              ),
              child: Text(
                statusLabel,
                style: AppTextStyles.kTextLabel.copyWith(color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReviewsSection extends StatelessWidget {
  const _ReviewsSection({required this.reviews});

  final List<_DummyReview> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reviews', style: AppTextStyles.kTextHeading4),
          const SizedBox(height: AppSpacing.kSpacing12),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: reviews.length,
            separatorBuilder: (_, __) =>
                const Divider(color: AppColors.kColorBorder),
            itemBuilder: (context, index) {
              return _ReviewCard(review: reviews[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.review});

  final _DummyReview review;

  String get _initials {
    final trimmed = review.reviewerName.trim();
    if (trimmed.isEmpty) {
      return '?';
    }
    return trimmed[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.kSpacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.kColorSurfaceVariant,
                child: Text(
                  _initials,
                  style: AppTextStyles.kTextLabel.copyWith(
                    color: AppColors.kColorTextPrimary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.kSpacing12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.reviewerName,
                      style: AppTextStyles.kTextBodyMedium,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: AppSpacing.kIconSmall,
                          color: AppColors.kColorWarning,
                        ),
                        const SizedBox(width: AppSpacing.kSpacing4),
                        Text(
                          '${review.rating}',
                          style: AppTextStyles.kTextBodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Text(review.date, style: AppTextStyles.kTextCaption),
            ],
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          Text(
            review.gearRented,
            style: AppTextStyles.kTextBodySmall.copyWith(
              color: AppColors.kColorTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.kSpacing8),
          Text(review.comment, style: AppTextStyles.kTextBodyMedium),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({
    required this.onEditProfile,
    required this.onNotifications,
    required this.onPrivacy,
    required this.onHelp,
    required this.onLogout,
  });

  final VoidCallback onEditProfile;
  final VoidCallback onNotifications;
  final VoidCallback onPrivacy;
  final VoidCallback onHelp;
  final VoidCallback onLogout;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.kSpacing16),
      child: Column(
        children: [
          _SettingsTile(
            icon: Icons.edit_outlined,
            title: 'Edit Profile',
            onTap: onEditProfile,
          ),
          const Divider(color: AppColors.kColorBorder),
          _SettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Notification Preferences',
            onTap: onNotifications,
          ),
          const Divider(color: AppColors.kColorBorder),
          _SettingsTile(
            icon: Icons.security_outlined,
            title: 'Privacy & Security',
            onTap: onPrivacy,
          ),
          const Divider(color: AppColors.kColorBorder),
          _SettingsTile(
            icon: Icons.help_outline,
            title: 'Help & Support',
            onTap: onHelp,
          ),
          const Divider(color: AppColors.kColorBorder),
          _SettingsTile(
            icon: Icons.logout,
            title: 'Log Out',
            iconColor: AppColors.kColorError,
            textColor: AppColors.kColorError,
            onTap: onLogout,
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
    this.textColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.kColorTextSecondary),
      title: Text(
        title,
        style: AppTextStyles.kTextBodyMedium.copyWith(
          color: textColor ?? AppColors.kColorTextPrimary,
        ),
      ),
      onTap: onTap,
    );
  }
}
