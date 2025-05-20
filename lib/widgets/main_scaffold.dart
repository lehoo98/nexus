// lib/scaffold/main_scaffold.dart (oder widgets/main_scaffold.dart)

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/account_tab/account_main.dart';
import 'package:flutter_application_1/account_tab/auth_choice_body.dart'; // neu
import '/scaffold/category_page.dart';
import '/scaffold/nearby_handwerker_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});
  @override State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  final _pages = [
    const CategoryPage(),
    const NearbyHandwerkerPage(),
    const AccountMainPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          if (i == 2 && FirebaseAuth.instance.currentUser == null) {
            // nicht eingeloggt → BottomSheet öffnen
            showModalBottomSheet(
              context: context,
              builder: (_) => const AuthChoiceBody(),
              isScrollControlled: true,
            );
            return;
          }
          setState(() => _currentIndex = i);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Handwerker'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
