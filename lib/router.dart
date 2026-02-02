import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'home_page.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect:
      (
        context,
        state,
      ) {
        final isLoggedIn =
            Supabase.instance.client.auth.currentUser !=
            null;
        final isGoingToLogin =
            state.matchedLocation ==
            '/login';
        final isGoingToRegister =
            state.matchedLocation ==
            '/register';

        // If not logged in and not going to login/register, redirect to login
        if (!isLoggedIn &&
            !isGoingToLogin &&
            !isGoingToRegister) {
          return '/login';
        }

        // If logged in and going to login/register, redirect to home
        if (isLoggedIn &&
            (isGoingToLogin ||
                isGoingToRegister)) {
          return '/';
        }

        // No redirect needed
        return null;
      },
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder:
          (
            context,
            state,
          ) => const HomePage(),
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder:
          (
            context,
            state,
          ) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder:
          (
            context,
            state,
          ) => const RegisterPage(),
    ),
    GoRoute(
      path: '/profile',
      name: 'profile',
      builder:
          (
            context,
            state,
          ) => const ProfilePage(),
    ),
  ],
);
