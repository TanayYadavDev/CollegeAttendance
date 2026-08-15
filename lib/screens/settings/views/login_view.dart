import 'package:flutter/material.dart';

import '../widgets/login_form.dart';
import '../widgets/mnnit_logo.dart';

class LoginView extends StatelessWidget {
  const LoginView({
    super.key,
    required this.onLogin,
    this.isLoading = false,
  });

  final Future<bool> Function(
      String registrationNo,
      String password,
      ) onLogin;

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const MnnitLogo(),
                const SizedBox(height: 40),
                LoginForm(
                  onLogin: onLogin,
                  isLoading: isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}