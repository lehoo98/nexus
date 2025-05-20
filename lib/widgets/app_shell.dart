import 'package:flutter/material.dart';
import '../scaffold/category_page.dart';
import '../scaffold/nearby_handwerker_page.dart';
import '/account_tab/account_main.dart';

class AppShell extends StatelessWidget {
  final int currentIndex;
  final Widget child;

  const AppShell({super.key, required this.currentIndex, required this.child});

  void _onTabTap(BuildContext context, int index) {
    if (index == currentIndex) return;

    Widget target;
    switch (index) {
      case 0:
        target = const CategoryPage();
      case 1:
        target = const NearbyHandwerkerPage();
      case 2:
        target = const AccountMainPage();
      default:
        target = const Scaffold(body: Center(child: Text('Demnächst verfügbar')));
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => AppShell(currentIndex: index, child: target),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => _onTabTap(context, index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Plus'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Handwerker'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
