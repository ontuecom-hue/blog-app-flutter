import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class LoginPage
    extends
        StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<
    LoginPage
  >
  createState() => _LoginPageState();
}

class _LoginPageState
    extends
        State<
          LoginPage
        > {
  final email = TextEditingController();
  final password = TextEditingController();
  bool isLoading = false;

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

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(
            20.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(
                height: 10,
              ),
              TextField(
                controller: password,
                decoration: const InputDecoration(
                  labelText: 'Password',
                ),
                obscureText: true,
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: isLoading
                    ? null
                    : () async {
                        setState(
                          () => isLoading = true,
                        );
                        try {
                          await Supabase.instance.client.auth.signInWithPassword(
                            email: email.text.trim(),
                            password: password.text,
                          );
                          if (mounted) {
                            context.go(
                              '/',
                            );
                          }
                        } catch (
                          e
                        ) {
                          showMessage(
                            'Login failed: ${e.toString()}',
                          );
                        } finally {
                          if (mounted)
                            setState(
                              () => isLoading = false,
                            );
                        }
                      },
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Login',
                      ),
              ),
              TextButton(
                onPressed: () {
                  context.go(
                    '/register',
                  );
                },
                child: const Text(
                  'Create an account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
