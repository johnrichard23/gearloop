import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/network/supabase_client.dart';
import '../../../onboarding/presentation/providers/onboarding_provider.dart';

/// Route the splash screen hands off to:
/// - Home when a Supabase session was restored on launch;
/// - the onboarding story on a signed-out first launch;
/// - Home as a guest on later signed-out launches.
final splashDestinationProvider = Provider<String>((ref) {
  final hasSession = AppSupabase.client.auth.currentSession != null;
  if (hasSession) return '/home';
  final seen = ref.watch(onboardingRepositoryProvider).hasSeenOnboarding;
  return seen ? '/home' : '/onboarding';
});

/// Whether this is the very first launch (onboarding not seen yet). A first
/// launch gets the full brand moment; returning users get a shorter one.
final splashIsFirstLaunchProvider = Provider<bool>((ref) {
  return !ref.watch(onboardingRepositoryProvider).hasSeenOnboarding;
});
