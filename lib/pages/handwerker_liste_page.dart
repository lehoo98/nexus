import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../account_tab/auth_choice_body.dart';
import '../widgets/sterne.dart';
import '../widgets/main_scaffold.dart';
import 'handwerker_detail_sheet.dart';

class HandwerkerListePage extends StatefulWidget {
  final String leistung;
  final String? beschreibung;
  final List<File>? bilder;

  const HandwerkerListePage({
    super.key,
    required this.leistung,
    this.beschreibung,
    this.bilder,
  });

  @override
  State<HandwerkerListePage> createState() => _HandwerkerListePageState();
}

class _HandwerkerListePageState extends State<HandwerkerListePage> {
  String suchbegriff = '';
  String sortiereNach = 'Preis';
  bool aufsteigend = true;
  bool nurVerfuegbar = false;

  // Beispiel-Daten
  final List<Map<String, dynamic>> alleHandwerker = [
    {
      'name': 'Anna Becker',
      'beruf': 'Klempnerin',
      'entfernung': 1.5,
      'preis': 55,
      'rating': 4.9,
      'verfuegbar': false,
      'bild': 'assets/profile_pics/A-team.png',
    },
    {
      'name': 'Max Müller',
      'beruf': 'Elektriker',
      'entfernung': 2.3,
      'preis': 45,
      'rating': 4.7,
      'verfuegbar': true,
      'bild': 'assets/profile_pics/images.png',
    },
    {
      'name': 'Thomas Klein',
      'beruf': 'Schreiner',
      'entfernung': 3.2,
      'preis': 40,
      'rating': 4.3,
      'verfuegbar': true,
      'bild': 'assets/profile_pics/Stemmle-640w.png',
    },
  ];

  List<Map<String, dynamic>> get gefilterteListe {
    var liste = alleHandwerker
        .where((h) =>
            h['name'].toLowerCase().contains(suchbegriff.toLowerCase()) ||
            h['beruf'].toLowerCase().contains(suchbegriff.toLowerCase()))
        .toList();

    if (nurVerfuegbar) {
      liste = liste.where((h) => h['verfuegbar'] as bool).toList();
    }

    liste.sort((a, b) {
      final key = sortiereNach.toLowerCase();
      final valA = a[key];
      final valB = b[key];
      if (valA is num && valB is num) {
        return aufsteigend
            ? valA.compareTo(valB)
            : valB.compareTo(valA);
      }
      return 0;
    });

    return liste;
  }

  void _onNavTap(int index) {
    if (index == 2 && FirebaseAuth.instance.currentUser == null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (_) => const AuthChoiceBody(),
      );
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => MainScaffold(initialIndex: index)),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Handwerker in deiner Nähe'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Suchleiste
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: (val) => setState(() => suchbegriff = val),
              decoration: InputDecoration(
                hintText: 'Suche nach Firma oder Beruf...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),

          // Filter-Chips
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var label in ['Preis', 'Entfernung', 'Rating'])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Row(
                          children: [
                            Text(label),
                            if (sortiereNach == label)
                              Icon(
                                aufsteigend
                                    ? Icons.arrow_upward
                                    : Icons.arrow_downward,
                                size: 16,
                              )
                          ],
                        ),
                        selected: sortiereNach == label,
                        onSelected: (_) => setState(() {
                          if (sortiereNach == label) {
                            aufsteigend = !aufsteigend;
                          } else {
                            sortiereNach = label;
                            aufsteigend = true;
                          }
                        }),
                        selectedColor: Colors.teal.shade100,
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ChoiceChip(
                    label: const Text('Verfügbar'),
                    selected: nurVerfuegbar,
                    onSelected: (_) =>
                        setState(() => nurVerfuegbar = !nurVerfuegbar),
                    selectedColor: Colors.green.shade100,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ],
              ),
            ),
          ),

          // Liste der Handwerker
          Expanded(
            child: ListView.builder(
              itemCount: gefilterteListe.length,
              itemBuilder: (context, idx) {
                final h = gefilterteListe[idx];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: h['verfuegbar'] ? Colors.white : Colors.grey[200],
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(2, 2),
                      )
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(h['bild']),
                    ),
                    title: Text(
                      h['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${h['beruf']} – ${h['entfernung']} km entfernt'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            buildStarDisplay(h['rating'], size: 16),
                            const SizedBox(width: 6),
                            Text('${h['rating']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${h['preis']} €',
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const Text('/Std'),
                      ],
                    ),
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        builder: (_) => HandwerkerDetailSheet(handwerker: h),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Tab "Handwerker"
        onTap: _onNavTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.handyman), label: 'Handwerker'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Account'),
        ],
      ),
    );
  }
}
