import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';
import '../profile_provider.dart';

class ProfilePage
    extends
        ConsumerStatefulWidget {
  const ProfilePage({
    super.key,
  });

  @override
  ConsumerState<
    ProfilePage
  >
  createState() => _ProfilePageState();
}

class _ProfilePageState
    extends
        ConsumerState<
          ProfilePage
        > {
  final displayNameController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    displayNameController.dispose();
    super.dispose();
  }

  void showMessage(
    String message,
  ) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  Future<
    void
  >
  updateProfile() async {
    setState(
      () => isLoading = true,
    );
    try {
      await ref
          .read(
            profileActionsProvider,
          )
          .updateDisplayName(
            displayNameController.text.trim(),
          );
      ref.invalidate(
        profileProvider,
      );
      showMessage(
        'Profile updated successfully!',
      );

      // Navigate back to home after a short delay
      await Future.delayed(
        const Duration(
          milliseconds: 500,
        ),
      );
      if (mounted)
        context.go(
          '/',
        );
    } catch (
      e
    ) {
      showMessage(
        'Failed to update profile: ${e.toString()}',
      );
    } finally {
      if (mounted)
        setState(
          () => isLoading = false,
        );
    }
  }

  Future<
    void
  >
  changePhoto() async {
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (picked ==
        null)
      return;

    setState(
      () => isLoading = true,
    );
    try {
      final bytes = await picked.readAsBytes();
      await ref
          .read(
            profileActionsProvider,
          )
          .uploadAvatar(
            bytes,
          );
      ref.invalidate(
        profileProvider,
      );
      showMessage(
        'Photo updated successfully!',
      );
    } catch (
      e
    ) {
      showMessage(
        'Failed to upload photo: ${e.toString()}',
      );
    } finally {
      if (mounted)
        setState(
          () => isLoading = false,
        );
    }
  }

  Future<
    void
  >
  deletePhoto() async {
    setState(
      () => isLoading = true,
    );
    try {
      await ref
          .read(
            profileActionsProvider,
          )
          .deleteAvatar();
      ref.invalidate(
        profileProvider,
      );
      showMessage(
        'Photo deleted successfully!',
      );
    } catch (
      e
    ) {
      showMessage(
        'Failed to delete photo: ${e.toString()}',
      );
    } finally {
      if (mounted)
        setState(
          () => isLoading = false,
        );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final profileAsync = ref.watch(
      profileProvider,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => context.go(
            '/',
          ),
        ),
      ),
      body: profileAsync.when(
        data:
            (
              profile,
            ) {
              // Set initial value for display name
              if (displayNameController.text.isEmpty &&
                  profile?['display_name'] !=
                      null) {
                displayNameController.text = profile!['display_name'];
              }

              final avatarUrl = profile?['avatar_url'];

              return Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(
                      20.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),

                        // Profile Photo Section
                        const Text(
                          'Profile Photo',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        // Avatar with delete button
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundImage:
                                  avatarUrl !=
                                      null
                                  ? CachedNetworkImageProvider(
                                      avatarUrl,
                                    )
                                  : null,
                              child:
                                  avatarUrl ==
                                      null
                                  ? const Icon(
                                      Icons.person,
                                      size: 60,
                                    )
                                  : null,
                            ),
                            if (avatarUrl !=
                                null)
                              Positioned(
                                right: 0,
                                top: 0,
                                child: GestureDetector(
                                  onTap: isLoading
                                      ? null
                                      : deletePhoto,
                                  child: Container(
                                    padding: const EdgeInsets.all(
                                      4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.red,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white,
                                        width: 2,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(
                          height: 15,
                        ),

                        // Change Photo Button
                        OutlinedButton.icon(
                          onPressed: isLoading
                              ? null
                              : changePhoto,
                          icon: const Icon(
                            Icons.photo_library,
                          ),
                          label: const Text(
                            'Change Photo',
                          ),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),

                        const SizedBox(
                          height: 40,
                        ),

                        // Display Name Field
                        TextField(
                          controller: displayNameController,
                          decoration: const InputDecoration(
                            labelText: 'Display Name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                          ),
                          enabled: !isLoading,
                        ),

                        const SizedBox(
                          height: 30,
                        ),

                        // Update Profile Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : updateProfile,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 16,
                              ),
                              backgroundColor: Colors.black,
                              foregroundColor: Colors.white,
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor:
                                          AlwaysStoppedAnimation<
                                            Color
                                          >(
                                            Colors.white,
                                          ),
                                    ),
                                  )
                                : const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
        error:
            (
              error,
              stack,
            ) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 60,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Error loading profile: ${error.toString()}',
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(
                      profileProvider,
                    ),
                    child: const Text(
                      'Retry',
                    ),
                  ),
                ],
              ),
            ),
      ),
    );
  }
}
