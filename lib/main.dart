import 'package:flutter/material.dart';
import 'widgets/main_scaffold.dart'; 
import 'scaffold/category_page.dart';
import 'scaffold/nearby_handwerker_page.dart';// enthält dein BottomNavigationBar-System
import '/account_tab/account_main.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // kommt gleich dazu
import 'auth_gate.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        routes: {
    '/home': (context) => const CategoryPage(),
//    '/plus': (context) => const Placeholder(), // oder deine Plus-Seite
    '/handwerker': (context) => const NearbyHandwerkerPage(),
    '/account': (context) => const AccountMainPage(), // oder deine Account-Seite
  },
      debugShowCheckedModeBanner: false,
      title: 'Handwerker App',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      home: const MainScaffold(), // <- wichtig: nur hier MainScaffold
    );
  }
}
