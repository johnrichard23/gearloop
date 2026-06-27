import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/main_shell_screen.dart';
import '../../features/bookings/domain/entities/booking_entity.dart';
import '../../features/listings/domain/entities/listing_entity.dart';
import '../../features/listings/presentation/screens/create_listing_screen.dart';
import '../../features/listings/presentation/screens/listing_detail_screen.dart';
import '../../features/listings/presentation/screens/location_picker_screen.dart';
import '../../features/bookings/presentation/screens/booking_request_screen.dart';
import '../../features/bookings/presentation/screens/booking_detail_screen.dart';
import '../../features/reviews/presentation/screens/write_review_screen.dart';
import '../../features/messaging/presentation/screens/chat_screen.dart';
import '../../features/profile/domain/entities/user_profile_entity.dart';
import '../../features/profile/presentation/screens/edit_profile_screen.dart';
import '../../features/notifications/presentation/screens/notification_center_screen.dart';

/// App-wide route definitions. Use with [MaterialApp.router] via [appRouter].
final GoRouter appRouter = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/',
      redirect: (context, state) => '/login',
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const MainShellScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: '/create-listing',
      builder: (context, state) => const CreateListingScreen(),
    ),
    GoRoute(
      path: '/location-picker',
      builder: (context, state) {
        final args = state.extra as Map<String, double>?;
        return LocationPickerScreen(
          initialLat: args?['lat'],
          initialLng: args?['lng'],
        );
      },
    ),
    GoRoute(
      path: '/listing/:id',
      builder: (context, state) {
        final listing = state.extra as ListingEntity;
        return ListingDetailScreen(listing: listing);
      },
    ),
    GoRoute(
      path: '/booking-request',
      builder: (context, state) {
        final listing = state.extra as ListingEntity;
        return BookingRequestScreen(listing: listing);
      },
    ),
    GoRoute(
      path: '/booking-detail',
      builder: (context, state) {
        final booking = state.extra as BookingEntity;
        return BookingDetailScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/write-review',
      builder: (context, state) {
        final booking = state.extra as BookingEntity;
        return WriteReviewScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final booking = state.extra as BookingEntity;
        return ChatScreen(booking: booking);
      },
    ),
    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        final user = state.extra as UserProfileEntity;
        return EditProfileScreen(user: user);
      },
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationCenterScreen(),
    ),
  ],
);
