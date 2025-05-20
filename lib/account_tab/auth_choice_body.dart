// lib/account_tab/auth_choice_body.dart

import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthChoiceBody extends StatelessWidget {
  const AuthChoiceBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min, // important for BottomSheet
        children: [
          const Icon(Icons.account_circle, size: 72, color: Colors.teal),
          const SizedBox(height: 24),
          const Text(
            "Melde dich an oder erstelle einen Account",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            icon: const Icon(Icons.login),
            label: const Text("Login"),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            onPressed: () {
              Navigator.of(context).pop(); // schließt das Sheet
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LoginPage(email: "")));
            },
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            icon: const Icon(Icons.app_registration),
            label: const Text("Registrieren"),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const RegisterPage(email: "")));
            },
          ),
        ],
      ),
    );
  }
}
