import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/account_tab/account_main.dart';
import 'package:flutter_application_1/account_tab/auth_choice_page.dart';
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
    const AccountMainPage(), // Account-Seite
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) async {
          if (index == 2) {
            final user = FirebaseAuth.instance.currentUser;

            if (user == null) {
              // ❌ Nicht eingeloggt → AuthChoicePage anzeigen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AuthChoicePage()),
              );
              return; // ❗ wichtig: _currentIndex nicht ändern
            }
          }

          // ✅ Eingeloggt oder anderer Tab → Tab normal wechseln
          setState(() => _currentIndex = index);
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.handyman),
            label: 'Handwerker',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Account',
          ),
        ],
      ),
    );
  }
}
