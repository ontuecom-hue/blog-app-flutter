import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const supabaseUrl = 'https://uvsyohfstingoxsilbqn.supabase.co';
  static const supabaseAnonKey = 'sb_publishable_yfdq36mPAvHUG_Q-xaMh0Q_1Bb1uw6N';

  static SupabaseClient get client => Supabase.instance.client;
}
