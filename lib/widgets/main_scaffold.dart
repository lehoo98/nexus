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
  bool _authSheetShown = false;

  final List<Widget> _pages = const [
    CategoryPage(),
    NearbyHandwerkerPage(),
    AccountMainPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        final user = snapshot.data;

        // Wenn ich gerade Account-Tab gewählt habe, aber nicht eingeloggt bin:
        if (_currentIndex == 2 && user == null && !_authSheetShown) {
          // Zeige AuthChoice als BottomSheet
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _authSheetShown = true;
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AuthChoiceBody(),
            ).whenComplete(() {
              // Sheet ist zu, Merker zurücksetzen
              _authSheetShown = false;
            });
          });
        }

        return Scaffold(
          body: IndexedStack(
            index: _currentIndex,
            children: _pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) {
              setState(() {
                _currentIndex = i;
                // Wenn wir wegswitchen, dürfen wir später wieder die Auth-Sheet zeigen
                if (i != 2) _authSheetShown = false;
              });
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
      },
    );
  }
}
