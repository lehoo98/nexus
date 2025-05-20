import 'package:flutter/material.dart';
import 'dart:io';
import '/widgets/sterne.dart';
import '/widgets/app_shell.dart';
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

  final List<Map<String, dynamic>> alleHandwerker = [
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
    if (nurVerfuegbar) {
      liste = liste.where((h) => h['verfuegbar'] == true).toList();
    }
    liste.sort((a, b) {
      final field = sortiereNach.toLowerCase();
      final valA = a[field];
      final valB = b[field];
      if (valA is num && valB is num) {
        return aufsteigend ? valA.compareTo(valB) : valB.compareTo(valA);
      }
      return 0;
    });
    return liste;
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          title: Text('🔧 Handwerker für: ${widget.leistung}'),
        ),
        body: Column(
          children: [
            if (widget.beschreibung != null && widget.beschreibung!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Dein Anliegen: ${widget.beschreibung!}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            if (widget.bilder != null && widget.bilder!.isNotEmpty)
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.bilder!.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Image.file(widget.bilder![index]),
                    );
                  },
                ),
              ),
            const Divider(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (var label in ['Preis', 'Entfernung', 'Rating'])
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Row(
                            children: [
                              Text(label),
                              if (sortiereNach == label)
                                Icon(
                                  aufsteigend ? Icons.arrow_upward : Icons.arrow_downward,
                                  size: 16,
                                )
                            ],
                          ),
                          selected: sortiereNach == label,
                          onSelected: (_) {
                            setState(() {
                              if (sortiereNach == label) {
                                aufsteigend = !aufsteigend;
                              } else {
                                sortiereNach = label;
                                aufsteigend = true;
                              }
                            });
                          },
                          selectedColor: Colors.teal.shade100,
                          backgroundColor: Colors.grey.shade200,
                        ),
                      ),
                    ChoiceChip(
                      label: const Text('Verfügbar'),
                      selected: nurVerfuegbar,
                      onSelected: (_) {
                        setState(() {
                          nurVerfuegbar = !nurVerfuegbar;
                        });
                      },
                      selectedColor: Colors.green.shade100,
                      backgroundColor: Colors.grey.shade200,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: gefilterteListe.length,
                itemBuilder: (context, index) {
                  final h = gefilterteListe[index];
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: AssetImage(h['bild']),
                      ),
                      title: Text(h['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
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
                          Text('${h['preis']} €', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const Text('/Std'),
                        ],
                      ),
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
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
      ),
    );
  }
}
