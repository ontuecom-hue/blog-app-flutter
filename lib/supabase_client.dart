import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Loaded from --dart-define
  static const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
  );

  static SupabaseClient get client => Supabase.instance.client;
}
