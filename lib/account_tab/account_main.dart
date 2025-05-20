import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';
// hier den korrekten Pfad zu deiner MainScaffold-Datei:
import '../widgets/main_scaffold.dart';
import '../widgets/app_shell.dart';

class AccountMainPage extends StatefulWidget {
  const AccountMainPage({super.key});

  @override
  State<AccountMainPage> createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  final _firestoreService = FirestoreService();
  UserModel? _userModel;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final data = await _firestoreService.getUser(uid);
      if (mounted) setState(() {
        _userModel = data;
        _loading = false;
      });
    } else {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    // Kompletten Stack auf Home-Tab zurücksetzen:
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScaffold(initialIndex: 0)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Dein Account'),
          actions: [
            if (FirebaseAuth.instance.currentUser != null)
              IconButton(
                icon: const Icon(Icons.logout),
                tooltip: 'Abmelden',
                onPressed: _logout,
              ),
          ],
        ),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _userModel == null
                ? const Center(child: Text('Keine Benutzerdaten gefunden.'))
                : Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.account_circle, size: 64),
                        const SizedBox(height: 16),
                        Text("👤 Name: ${_userModel!.name}", style: _textStyle),
                        const SizedBox(height: 8),
                        Text("📧 E-Mail: ${_userModel!.email}", style: _textStyle),
                        const SizedBox(height: 8),
                        Text("🏠 Adresse: ${_userModel!.address}", style: _textStyle),
                        const SizedBox(height: 8),
                        Text("📱 Telefon: ${_userModel!.phone}", style: _textStyle),
                        const SizedBox(height: 8),
                        Text(
                          _userModel!.isPremium
                              ? "🌟 Du bist PLUS-Mitglied!"
                              : "🔓 Kein Plus-Abo aktiv",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _userModel!.isPremium ? Colors.green : Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  TextStyle get _textStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
}
