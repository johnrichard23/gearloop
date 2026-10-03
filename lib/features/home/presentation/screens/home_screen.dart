import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../widgets/home_category_row.dart';
import '../widgets/home_header.dart';
import '../widgets/home_near_you_section.dart';
import '../widgets/home_search_pill.dart';

/// Home has one job: help a renter find gear nearby. Search first, then the
/// popular categories, then a short list of nearby listings.
class HomeScreen extends StatelessWidget {
  const HomeScreen({required this.onBrowseTap, super.key});

  final VoidCallback onBrowseTap;

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Coming soon!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SingleChildScrollView(
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppSpacing.kSpacing16,
                  AppSpacing.kSpacing8,
                  AppSpacing.kSpacing16,
                  0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    HomeHeader(
                      onLocationTap: () => _showComingSoon(context),
                      onNotificationsTap: () => context.push('/notifications'),
                    ),
                    const SizedBox(height: AppSpacing.kSpacing12),
                    HomeSearchPill(onTap: onBrowseTap),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.kSpacing24),
              HomeCategoryRow(onBrowseTap: onBrowseTap),
              const SizedBox(height: AppSpacing.kSpacing24),
              HomeNearYouSection(onSeeAll: onBrowseTap),
            ],
          ),
        ),
      ),
    );
  }
}
