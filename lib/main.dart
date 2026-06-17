import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app.dart';

/// Placeholder Supabase project — replace with real URL/key via `--dart-define` or env later.
const String _kPlaceholderSupabaseUrl = 'https://placeholder.supabase.co';
const String _kPlaceholderSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnZWFybG9vcC1wbGFjZWhvbGRlciJ9.placeholder-anon-key-not-for-production';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: _kPlaceholderSupabaseUrl,
    anonKey: _kPlaceholderSupabaseAnonKey,
  );

  runApp(
    const ProviderScope(
      child: GearLoopApp(),
    ),
  );
}
