import 'package:supabase_flutter/supabase_flutter.dart';

/// GearLoop Supabase singleton: one-time initialization and global client access.
///
/// Secrets must come from compile-time defines (see CONSTITUTION.md), for example:
/// `flutter run --dart-define=SUPABASE_URL=https://xxx.supabase.co --dart-define=SUPABASE_ANON_KEY=eyJ...`
abstract final class AppSupabase {
  AppSupabase._();

  static const String _url = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: '',
  );

  static const String _anonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: '',
  );

  /// `true` when both URL and anon key were provided at compile time.
  static bool get isConfigured => _url.isNotEmpty && _anonKey.isNotEmpty;

  /// Initializes the Supabase SDK. Call once after
  /// [WidgetsFlutterBinding.ensureInitialized], before [runApp].
  ///
  /// Throws [StateError] if [isConfigured] is false.
  static Future<void> initialize() async {
    if (!isConfigured) {
      throw StateError(
        'Missing SUPABASE_URL or SUPABASE_ANON_KEY. '
        'Pass them using --dart-define when running or building the app.',
      );
    }
    await Supabase.initialize(
      url: _url,
      anonKey: _anonKey,
    );
  }

  /// The shared Supabase client. [initialize] must have completed successfully.
  static SupabaseClient get client => Supabase.instance.client;
}
