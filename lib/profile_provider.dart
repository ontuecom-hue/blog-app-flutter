import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_client.dart';

final profileProvider =
    FutureProvider<
      Map<
        String,
        dynamic
      >?
    >(
      (
        ref,
      ) async {
        final user = SupabaseConfig.client.auth.currentUser;
        if (user ==
            null)
          return null;

        final res = await SupabaseConfig.client
            .from(
              'profiles',
            )
            .select()
            .eq(
              'id',
              user.id,
            )
            .single();

        return res;
      },
    );

final profileActionsProvider = Provider(
  (
    ref,
  ) {
    final client = SupabaseConfig.client;
    return _ProfileActions(
      client,
    );
  },
);

class _ProfileActions {
  final SupabaseClient client;
  _ProfileActions(
    this.client,
  );

  /// Upload or update user avatar
  Future<
    void
  >
  uploadAvatar(
    Uint8List bytes,
  ) async {
    final user = client.auth.currentUser!;
    final path = '${user.id}/avatar.png';

    await client.storage
        .from(
          'avatars',
        )
        .uploadBinary(
          path,
          bytes,
          fileOptions: const FileOptions(
            upsert: true,
          ),
        );
    
    final url = client.storage
        .from(
          'avatars',
        )
        .getPublicUrl(
          path,
        );

    

    await client
        .from(
          'profiles',
        )
        .update(
          {
            'avatar_url': url,
          },
        )
        .eq(
          'id',
          user.id,
        );



  }

  /// Update user display name
  Future<
    void
  >
  updateDisplayName(
    String displayName,
  ) async {
    final user = client.auth.currentUser!;

    await client
        .from(
          'profiles',
        )
        .update(
          {
            'display_name': displayName,
          },
        )
        .eq(
          'id',
          user.id,
        );
  }

  /// Delete user avatar
  Future<
    void
  >
  deleteAvatar() async {
    final user = client.auth.currentUser!;
    final path = '${user.id}/avatar.png';

    // Delete from storage
    try {
      await client.storage
          .from(
            'avatars',
          )
          .remove(
            [
              path,
            ],
          );
    } catch (
      e
    ) {
      // Ignore if file doesn't exist
    }

    // Remove URL from database
    await client
        .from(
          'profiles',
        )
        .update(
          {
            'avatar_url': null,
          },
        )
        .eq(
          'id',
          user.id,
        );
  }
}
