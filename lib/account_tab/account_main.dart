// lib/account_tab/account_main.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';

class AccountMainPage extends StatefulWidget {
  const AccountMainPage({super.key});
  @override State<AccountMainPage> createState() => _AccountMainPageState();
}

class _AccountMainPageState extends State<AccountMainPage> {
  final _fs = FirestoreService();
  UserModel? _user;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      _fs.getUser(uid).then((u) {
        setState(() { _user = u; _loading = false; });
      });
    } else {
      _loading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_user == null) {
      return const Center(child: Text('Keine Benutzerdaten gefunden.'));
    }
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.account_circle, size: 64),
          const SizedBox(height: 16),
          Text("👤 Name: ${_user!.name}"),
          Text("📧 E-Mail: ${_user!.email}"),
          Text("🏠 Adresse: ${_user!.address}"),
          Text("📱 Telefon: ${_user!.phone}"),
          Text(_user!.isPremium 
              ? "🌟 PLUS-Mitglied" 
              : "🔓 Kein Plus-Abo"),
        ],
      ),
    );
  }
}
