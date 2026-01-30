import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:go_router/go_router.dart';

class RegisterPage
    extends
        StatefulWidget {
  const RegisterPage({
    super.key,
  });

  @override
  State<
    RegisterPage
  >
  createState() => _RegisterPageState();
}

class _RegisterPageState
    extends
        State<
          RegisterPage
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
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
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
                          await Supabase.instance.client.auth.signUp(
                            email: email.text.trim(),
                            password: password.text,
                          );
                          showMessage(
                            'Registration successful! Please check your email.',
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
                            'Registration failed: ${e.toString()}',
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
                        'Register',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
