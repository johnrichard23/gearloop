import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:gearloop/core/network/supabase_client.dart';

/// Shared Supabase client for datasources (read via Riverpod, not from widgets directly).
///
/// Call [AppSupabase.initialize] before the first frame that depends on this provider.
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return AppSupabase.client;
});

/// Optional [ProviderScope] overrides (tests, staging doubles). Empty until features register overrides.
List<Override> buildProviderOverrides() => const <Override>[];
