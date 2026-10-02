import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/constants/app_text_styles.dart';
import '../../../../core/widgets/sign_in_prompt.dart';
import '../../../auth/presentation/providers/session_provider.dart';
import '../../../auth/data/repositories/auth_repository_impl.dart';
import '../../../listings/domain/entities/listing_entity.dart';
import '../../../listings/presentation/providers/listings_provider.dart';
import '../../domain/entities/user_profile_entity.dart';

const UserProfileEntity dummyUser = UserProfileEntity(
  id: 'user-1',
  fullName: 'Chard Dela Cruz',
  email: 'chard@rentra.ph',
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
    comment: 'Good experience overall. Gear was as described. Will rent again.',
    date: 'April 28, 2026',
    gearRented: 'Sony A7III Camera Body',
  ),
];

/// User profile tab (dummy data until Supabase is wired).
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  Future<void> _showLogoutDialog(BuildContext context, WidgetRef ref) async {
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
    if (confirmed != true) {
      return;
    }
    final signedOut = await ref.read(authProvider.notifier).signOut();
    if (!context.mounted) {
      return;
    }
    if (signedOut) {
      context.go('/login');
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(authProvider).errorMessage ??
              'Could not log out. Please try again.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!ref.watch(isSignedInProvider)) {
      return _GuestProfile(onHelp: () => _showComingSoon(context));
    }
    final listingsAsync = ref.watch(listingsProvider);
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final myListings = listingsAsync.maybeWhen(
      data: (listings) => currentUserId == null
          ? <ListingEntity>[]
          : listings.where((l) => l.hostId == currentUserId).toList(),
      orElse: () => <ListingEntity>[],
    );

    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.paddingOf(context).bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ProfileHeader(user: dummyUser),
            _VerificationsSection(user: dummyUser),
            if (dummyUser.isHost)
              _MyListingsSection(
                listingsAsync: listingsAsync,
                myListings: myListings,
                onSeeAll: () => _showComingSoon(context),
                onRetry: () => ref.invalidate(listingsProvider),
              ),
            _ReviewsSection(reviews: _dummyReviews),
            _SettingsSection(
              onEditProfile: () =>
                  context.push('/edit-profile', extra: dummyUser),
              onNotifications: () => _showComingSoon(context),
              onPrivacy: () => _showComingSoon(context),
              onHelp: () => _showComingSoon(context),
              onLogout: () => _showLogoutDialog(context, ref),
            ),
          ],
        ),
      ),
    );
  }
}

/// Profile for a guest: no personal sections, just a prompt to log in or sign
/// up plus the settings that don't need an account.
class _GuestProfile extends StatelessWidget {
  const _GuestProfile({required this.onHelp});

  final VoidCallback onHelp;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.kSpacing32),
              const SignInPrompt(
                icon: Icons.person_outline,
                title: 'Log in to your profile',
                message:
                    'Log in or sign up to manage your listings, '
                    'reviews and account settings.',
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.kSpacing16),
                child: _SettingsTile(
                  icon: Icons.help_outline,
                  title: 'Help & Support',
                  onTap: onHelp,
                ),
              ),
            ],
          ),
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
            backgroundImage: user.avatarUrl != null
                ? NetworkImage(user.avatarUrl!)
                : null,
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
              _StatBox(value: '${user.totalRentals}', label: 'Rentals'),
              _VerticalDivider(),
              _StatBox(
                value: '${user.ratingAvg.toStringAsFixed(1)} ⭐',
                label: 'Rating',
              ),
              _VerticalDivider(),
              _StatBox(value: '${user.totalListings}', label: 'Listings'),
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
    final color = isVerified
        ? AppColors.kColorSuccess
        : AppColors.kColorTextHint;

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
  const _MyListingsSection({
    required this.listingsAsync,
    required this.myListings,
    required this.onSeeAll,
    required this.onRetry,
  });

  final AsyncValue<List<ListingEntity>> listingsAsync;
  final List<ListingEntity> myListings;
  final VoidCallback onSeeAll;
  final VoidCallback onRetry;

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
          listingsAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.kSpacing24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => Padding(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.kSpacing16,
              ),
              child: TextButton(
                onPressed: onRetry,
                child: const Text('Could not load listings. Tap to retry.'),
              ),
            ),
            data: (_) {
              if (myListings.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.kSpacing16,
                  ),
                  child: Text(
                    'You have not posted any gear yet.',
                    style: AppTextStyles.kTextBodySmall.copyWith(
                      color: AppColors.kColorTextSecondary,
                    ),
                  ),
                );
              }
              return ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: myListings.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: AppSpacing.kSpacing12),
                itemBuilder: (context, index) {
                  return _MyListingCard(listing: myListings[index]);
                },
              );
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
