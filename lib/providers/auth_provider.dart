import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../supabase_client.dart';

final authProvider = Provider(
  (
    ref,
  ) {
    return SupabaseConfig.client.auth;
  },
);
