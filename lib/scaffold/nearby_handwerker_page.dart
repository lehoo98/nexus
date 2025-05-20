import 'package:flutter/material.dart';
import '../widgets/sterne.dart';
import '../pages/firma_detail_sheet.dart';

class NearbyHandwerkerPage extends StatefulWidget {
  const NearbyHandwerkerPage({super.key});

  @override
  State<NearbyHandwerkerPage> createState() => _NearbyHandwerkerPageState();
}

class _NearbyHandwerkerPageState extends State<NearbyHandwerkerPage> {
  String sortiereNach = 'Preis';
  bool aufsteigend = true;
  bool nurVerfuegbar = false;
  String suchbegriff = '';

  final List<Map<String, dynamic>> firmen = [
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

  List<Map<String, dynamic>> get gefilterteFirmen {
    final suchtext = suchbegriff.toLowerCase();
    var liste = firmen
        .where((f) =>
            f['name'].toLowerCase().contains(suchtext) ||
            f['beruf'].toLowerCase().contains(suchtext))
        .toList();
    if (nurVerfuegbar) {
      liste = liste.where((f) => f['verfuegbar'] == true).toList();
    }
    liste.sort((a, b) {
      final key = sortiereNach.toLowerCase();
      final valA = a[key];
      final valB = b[key];
      if (valA is num && valB is num) {
        return aufsteigend ? valA.compareTo(valB) : valB.compareTo(valA);
      }
      return 0;
    });
    return liste;
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
          // 🔍 Suchleiste
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

          // 📦 Filter-Chips
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

          // 📋 Handwerkerliste
          Expanded(
            child: ListView.builder(
              itemCount: gefilterteFirmen.length,
              itemBuilder: (context, index) {
                final f = gefilterteFirmen[index];
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: f['verfuegbar'] ? Colors.white : Colors.grey[200],
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
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(f['bild']),
                    ),
                    title: Text(
                      f['name'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${f['beruf']} – ${f['entfernung']} km entfernt'),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            buildStarDisplay(f['rating'], size: 16),
                            const SizedBox(width: 6),
                            Text('${f['rating']}'),
                          ],
                        ),
                      ],
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${f['preis']} €',
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
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FirmaDetailSheet(firma: f),
  );
},

                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
