// lib/widgets/main_scaffold.dart

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/scaffold/category_page.dart';
import 'package:flutter_application_1/scaffold/nearby_handwerker_page.dart';

import '../account_tab/account_main.dart';
import '../account_tab/auth_choice_body.dart';
import '../scaffold/category_page.dart';
import '../scaffold/nearby_handwerker_page.dart';

class MainScaffold extends StatefulWidget {
  /// Erlaubt, initial auf einen bestimmten Tab zu springen (0=Home,1=Handwerker,2=Account)
  final int initialIndex;
  const MainScaffold({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  late int _currentIndex;
  bool _authSheetShown = false;

  final List<Widget> _pages = const [
    CategoryPage(),
    NearbyHandwerkerPage(),
    AccountMainPage(),
  ];

  @override
  void initState() {
    super.initState();
    // den vom Konstruktor übergebenen Start-Tab verwenden
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        final user = snap.data;

        // Wenn man auf Account-Tab klickt, aber nicht eingeloggt, Auth-Sheet aufmachen
        if (_currentIndex == 2 && user == null && !_authSheetShown) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _authSheetShown = true;
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const AuthChoiceBody(),
            ).whenComplete(() => _authSheetShown = false);
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(_currentIndex == 0
                ? 'Home'
                : _currentIndex == 1
                    ? 'Handwerker'
                    : 'Dein Account'),
            actions: [
              // Logout-Button nur anzeigen, wenn eingeloggt und im Account-Tab
              if (_currentIndex == 2 && user != null)
                IconButton(
                  icon: const Icon(Icons.logout),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    setState(() => _currentIndex = 0);
                  },
                ),
            ],
          ),
          body: IndexedStack(index: _currentIndex, children: _pages),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentIndex,
            onTap: (i) {
              setState(() {
                _currentIndex = i;
                // Wenn man wegklickt, darf Auth-Sheet später wieder erneut kommen
                if (i != 2) _authSheetShown = false;
              });
            },
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
