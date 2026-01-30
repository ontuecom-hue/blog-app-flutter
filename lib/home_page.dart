import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import 'profile_provider.dart';
import 'supabase_client.dart';

class HomePage
    extends
        ConsumerWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
    WidgetRef ref,
  ) {
    final profileAsync = ref.watch(
      profileProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blog App',
        ),
        actions: [
          profileAsync.when(
            data:
                (
                  profile,
                ) {
                  final avatar = profile?['avatar_url'];
                  final displayName =
                      profile?['display_name'] ??
                      '';

                  return Row(
                    children: [
                      // Display name (optional - shows on wider screens)
                      if (MediaQuery.of(
                            context,
                          ).size.width >
                          600)
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 12,
                          ),
                          child: Text(
                            displayName,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),

                      // Avatar button - navigates to profile page
                      IconButton(
                        onPressed: () {
                          context.go(
                            '/profile',
                          );
                        },
                        icon: CircleAvatar(
                          backgroundImage:
                              avatar !=
                                  null
                              ? CachedNetworkImageProvider(
                                  avatar,
                                )
                              : null,
                          child:
                              avatar ==
                                  null
                              ? const Icon(
                                  Icons.person,
                                )
                              : null,
                        ),
                      ),
                    ],
                  );
                },
            loading: () => const SizedBox(),
            error:
                (
                  _,
                  __,
                ) => const SizedBox(),
          ),

          // Logout button
          IconButton(
            onPressed: () async {
              await SupabaseConfig.client.auth.signOut();
              if (context.mounted) {
                context.go(
                  '/login',
                );
              }
            },
            icon: const Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Home',
          style: TextStyle(
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
