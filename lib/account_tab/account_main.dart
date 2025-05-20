// lib/account_tab/account_main.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../account_tab/auth_choice_body.dart';
import '../widgets/main_scaffold.dart';
import '../services/firestore_service.dart';
import '../models/user_model.dart';

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
    // Auch auf Auth-Änderungen hören:
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user == null) {
        // User hat sich ausgeloggt
        setState(() {
          _userModel = null;
          _loading = false;
        });
      } else {
        // neu einloggen → Daten nachladen
        _loadUserData();
      }
    });
  }

  Future<void> _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      // nicht angemeldet
      setState(() {
        _loading = false;
        _userModel = null;
      });
      return;
    }
    setState(() => _loading = true);
    final data = await _firestoreService.getUser(user.uid);
    setState(() {
      _userModel = data;
      _loading = false;
    });
  }

  void _onLogout() async {
    await FirebaseAuth.instance.signOut();
    // direkt zum Home-Tab wechseln
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const MainScaffold(initialIndex: 0)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // 1) Wenn noch lädt → Spinner
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // 2) Wenn nicht eingeloggt → AuthChoiceBody im Vollbild
    if (FirebaseAuth.instance.currentUser == null) {
      return const AuthChoiceBody();
    }

    // 3) Wenn eingeloggt, aber kein Firestore‐Datensatz → Hinweis
    if (_userModel == null) {
      return const Scaffold(
        body: Center(child: Text('Keine Benutzerdaten gefunden.')),
      );
    }

    // 4) Alles da → richtiges Konto‐UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dein Account'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _onLogout,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.account_circle, size: 64),
            const SizedBox(height: 16),
            Text("👤 Name: ${_userModel!.name}",
                style: _textStyle),
            const SizedBox(height: 8),
            Text("📧 E-Mail: ${_userModel!.email}",
                style: _textStyle),
            const SizedBox(height: 8),
            Text("🏠 Adresse: ${_userModel!.address}",
                style: _textStyle),
            const SizedBox(height: 8),
            Text("📱 Telefon: ${_userModel!.phone}",
                style: _textStyle),
            const SizedBox(height: 8),
            Text(
              _userModel!.isPremium
                  ? "🌟 Du bist PLUS-Mitglied!"
                  : "🔓 Kein Plus-Abo aktiv",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color:
                    _userModel!.isPremium ? Colors.green : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextStyle get _textStyle => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
      );
}
