import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/account_tab/account_main.dart';
import 'package:flutter_application_1/account_tab/auth_choice_body.dart';
import '/scaffold/category_page.dart';
import '/scaffold/nearby_handwerker_page.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const CategoryPage(),
    const NearbyHandwerkerPage(),
    const AccountMainPage(),
  ];

  @override
  void initState() {
    super.initState();
    // Sobald sich der Auth-Status ändert, wird Account-Tab neu aufgebaut
    FirebaseAuth.instance.authStateChanges().listen((user) {
      if (user != null && _currentIndex == 2) {
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) {
          // Account-Tab und nicht eingeloggt? Dann AuthChoiceBody anzeigen
          if (i == 2 && FirebaseAuth.instance.currentUser == null) {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AuthChoiceBody(),
            );
            return;
          }
          // sonst Tab wechseln
          setState(() => _currentIndex = i);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Handwerker'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
