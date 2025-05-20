import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/user_model.dart';
import '../../services/firestore_service.dart';
import '../widgets/app_shell.dart';
import 'auth_choice_page.dart';

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
      final userData = await _firestoreService.getUser(uid);
      if (mounted) {
        setState(() {
          _userModel = userData;
          _loading = false;
        });
      }
    } else {
      // Wenn gar kein User angemeldet ist, direkt logout
      _signOutAndRedirect();
    }
  }

  /// Loggt aus und navigiert zur AuthChoicePage
  void _signOutAndRedirect() {
    FirebaseAuth.instance.signOut();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const AuthChoicePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 2,
      child: Scaffold(
        appBar: AppBar(title: const Text('Dein Account')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : _userModel == null
                // Wenn kein Datensatz gefunden: automatisch ausloggen
                ? _buildAutoLogout()
                // Wenn Daten da sind: normales Profil anzeigen
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
                          _userModel!.isPremium ? "🌟 Du bist PLUS-Mitglied!" : "🔓 Kein Plus-Abo aktiv",
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

  /// Gibt ein leeres Widget zurück und kickt den Sign-Out-Prozess an
  Widget _buildAutoLogout() {
    // Hier optional noch eine kurze Nachricht anzeigen,
    // z.B. Center(child: Text("Abmeldung läuft..."))
    // Wir geben aber einfach ein leeres SizedBox zurück:
    _signOutAndRedirect();
    return const SizedBox.shrink();
  }

  TextStyle get _textStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
}
