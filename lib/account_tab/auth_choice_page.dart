import 'package:flutter/material.dart';
import 'login_page.dart';
import 'register_page.dart';

class AuthChoicePage extends StatelessWidget {
  const AuthChoicePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Willkommen')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.account_circle, size: 72, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              "Melde dich an oder erstelle einen Account",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 32),

            // 👉 Deine Buttons kommen genau hier:
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage(email: "")),
                );
              },
              child: const Text("Login"),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterPage(email: "")),
                );
              },
              child: const Text("Registrieren"),
            ),
          ],
        ),
      ),
    );
  }
}
