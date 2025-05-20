import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../account_tab/auth_choice_body.dart';
import '../widgets/main_scaffold.dart';
import '/widgets/sterne.dart';
import 'handwerker_detail_sheet.dart';

class HandwerkerListePage extends StatefulWidget {
  final String leistung;
  final List<File>? bilder;
  final String? beschreibung;

  const HandwerkerListePage({
    super.key,
    required this.leistung,
    this.bilder,
    this.beschreibung,
  });

  @override
  State<HandwerkerListePage> createState() => _HandwerkerListePageState();
}

class _HandwerkerListePageState extends State<HandwerkerListePage> {
  String sortiereNach = 'Entfernung';
  bool aufsteigend = true;
  bool nurVerfuegbar = false;

  final alleHandwerker = <Map<String, dynamic>>[
    {
      'name': 'Max Müller',
      'beruf': 'Elektriker',
      'preis': 45,
      'entfernung': 2.3,
      'rating': 4.7,
      'verfuegbar': true,
      'bild': 'assets/profile_pics/images.png',
    },
    {
      'name': 'Anna Becker',
      'beruf': 'Elektrikerin',
      'preis': 55,
      'entfernung': 1.5,
      'rating': 4.9,
      'verfuegbar': false,
      'bild': 'assets/profile_pics/A-team.png',
    },
    {
      'name': 'Thomas Klein',
      'beruf': 'Elektriker',
      'preis': 40,
      'entfernung': 3.2,
      'rating': 4.3,
      'verfuegbar': true,
      'bild': 'assets/profile_pics/Stemmle-640w.png',
    },
  ];

  List<Map<String, dynamic>> get gefilterteListe {
    var liste = [...alleHandwerker];
    if (nurVerfuegbar) liste = liste.where((h) => h['verfuegbar']).toList();
    liste.sort((a, b) {
      final valA = a[sortiereNach.toLowerCase()];
      final valB = b[sortiereNach.toLowerCase()];
      if (valA is num && valB is num) {
        return aufsteigend ? valA.compareTo(valB) : valB.compareTo(valA);
      }
      return 0;
    });
    return liste;
  }

  void _onNavTap(int i) {
    if (i == 2 && FirebaseAuth.instance.currentUser == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AuthChoiceBody(),
      );
    } else {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => MainScaffold(initialIndex: i)),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('🔧 Handwerker für: ${widget.leistung}')),
      body: Column(
        children: [
          if ((widget.beschreibung ?? '').isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Dein Anliegen: ${widget.beschreibung!}',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
          if ((widget.bilder ?? []).isNotEmpty)
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.bilder!.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Image.file(widget.bilder![i]),
                ),
              ),
            ),
          const Divider(height: 24),
          // Sortier-Chips ...
          // (gleiche Logik wie vorher)
          Expanded(
            child: ListView.builder(
              itemCount: gefilterteListe.length,
              itemBuilder: (_, idx) {
                final h = gefilterteListe[idx];
                return ListTile(
                  // ...
                  onTap: () => showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                    ),
                    builder: (_) => HandwerkerDetailSheet(handwerker: h),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Handwerker'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
