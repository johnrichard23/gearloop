import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/sign_in_prompt.dart';
import '../../../auth/presentation/providers/session_provider.dart';
import '../../../bookings/presentation/screens/my_bookings_screen.dart';
import '../widgets/floating_tab_bar.dart';
import '../widgets/native_glass_tab_bar.dart';
import 'home_screen.dart';
import '../../../listings/presentation/screens/browse_screen.dart';
import '../../../profile/presentation/screens/profile_screen.dart';

/// App shell with bottom tab navigation. Guests can browse; Post, Bookings and
/// Profile ask them to log in.
class MainShellScreen extends ConsumerStatefulWidget {
  const MainShellScreen({super.key});

  @override
  ConsumerState<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends ConsumerState<MainShellScreen> {
  int _selectedIndex = 0;

  List<Widget> _tabBodies({required bool isSignedIn}) => [
    HomeScreen(onBrowseTap: () => setState(() => _selectedIndex = 1)),
    const BrowseScreen(),
    if (isSignedIn)
      const _TabPlaceholder(message: 'Post Gear — coming soon')
    else
      const _GuestTab(
        icon: Icons.add_circle_outline,
        title: 'Log in to post your gear',
        message: 'Create an account to list your gear and start earning.',
      ),
    if (isSignedIn)
      const MyBookingsScreen()
    else
      const _GuestTab(
        icon: Icons.calendar_today_outlined,
        title: 'Log in to see your bookings',
        message:
            'Your rentals and requests will show up here once you '
            'are logged in.',
      ),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isSignedIn = ref.watch(isSignedInProvider);
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      // Screens run underneath the floating bar; each pads its own scroll end.
      extendBody: true,
      body: _tabBodies(isSignedIn: isSignedIn)[_selectedIndex],
      bottomNavigationBar: AdaptiveTabBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2 && isSignedIn) {
            context.push('/create-listing');
            return;
          }
          setState(() => _selectedIndex = index);
        },
        items: [
          const FloatingTabItem(
            icon: Icons.home_outlined,
            selectedIcon: Icons.home_rounded,
            label: 'Home',
          ),
          const FloatingTabItem(
            icon: Icons.search_outlined,
            selectedIcon: Icons.search_rounded,
            label: 'Browse',
          ),
          const FloatingTabItem(
            icon: Icons.add_rounded,
            selectedIcon: Icons.add_rounded,
            label: 'Post',
          ),
          const FloatingTabItem(
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_month_rounded,
            label: 'Bookings',
          ),
          FloatingTabItem(
            icon: Icons.person_outline,
            selectedIcon: Icons.person_rounded,
            label: isSignedIn ? 'Profile' : 'Log in',
          ),
        ],
      ),
    );
  }
}

/// A tab body that asks a guest to log in.
class _GuestTab extends StatelessWidget {
  const _GuestTab({
    required this.icon,
    required this.title,
    required this.message,
  });

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.kColorBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: SignInPrompt(icon: icon, title: title, message: message),
          ),
        ),
      ),
    );
  }
}

class _TabPlaceholder extends StatelessWidget {
  const _TabPlaceholder({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text(message)));
  }
}
