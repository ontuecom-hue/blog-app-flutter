import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  // Loaded from --dart-define
  static const supabaseUrl = String.fromEnvironment(
    'https://uvsyohfstingoxsilbqn.supabase.co',
  );

  static const supabaseAnonKey = String.fromEnvironment(
    'sb_publishable_yfdq36mPAvHUG_Q-xaMh0Q_1Bb1uw6N',
  );

  static SupabaseClient get client => Supabase.instance.client;
}
