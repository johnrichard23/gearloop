import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/network/supabase_client.dart';

/// The live Supabase session: the one restored from disk at launch, then every
/// sign-in, sign-out and token refresh after it. `null` means a guest.
final sessionProvider = StreamProvider<Session?>((ref) async* {
  final auth = AppSupabase.client.auth;
  yield auth.currentSession;
  yield* auth.onAuthStateChange.map((state) => state.session);
});

/// Whether someone is signed in right now. Falls back to the persisted session
/// until the stream emits, so a signed-in user never flashes the guest UI.
final isSignedInProvider = Provider<bool>((ref) {
  return ref
      .watch(sessionProvider)
      .when(
        data: (session) => session != null,
        loading: () => AppSupabase.client.auth.currentSession != null,
        error: (_, _) => AppSupabase.client.auth.currentSession != null,
      );
});
