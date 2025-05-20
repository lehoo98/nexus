
import 'package:flutter/material.dart';
import '../widgets/sterne.dart';

class FirmaDetailSheet extends StatefulWidget {
  final Map<String, dynamic> firma;

  const FirmaDetailSheet({super.key, required this.firma});

  @override
  State<FirmaDetailSheet> createState() => _FirmaDetailSheetState();
}

class _FirmaDetailSheetState extends State<FirmaDetailSheet> {
  String? ausgewaehltesProblem;
  String sortiereNach = 'Datum';
  bool aufsteigend = false;

  final List<Map<String, dynamic>> ratings = [
    {'text': 'Super Firma!', 'rating': 5.0, 'date': DateTime(2025, 4, 9)},
    {'text': 'Schnelle Hilfe.', 'rating': 4.25, 'date': DateTime(2025, 4, 1)},
    {'text': 'Ganz okay.', 'rating': 3.0, 'date': DateTime(2025, 3, 20)},
  ];

  final List<String> probleme = [
    'Toilette verstopft',
    'Wasserhahn undicht',
    'Heizung funktioniert nicht',
    'Fenster defekt',
  ];

  List<Map<String, dynamic>> get sortierteRatings {
    List<Map<String, dynamic>> sorted = [...ratings];
    sorted.sort((a, b) {
      var field = sortiereNach.toLowerCase();
      var valA = field == 'datum' ? a['date'] : a['rating'];
      var valB = field == 'datum' ? b['date'] : b['rating'];
      return aufsteigend ? valA.compareTo(valB) : valB.compareTo(valA);
    });
    return sorted;
  }

  @override
  Widget build(BuildContext context) {
    final f = widget.firma;
    final bool verfuegbar = f['verfuegbar'] == true;
    final bool problemGegeben = ausgewaehltesProblem != null;

    return SafeArea(
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  f['bild'],
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 12),
              Text('${f['beruf']} – ${f['name']}',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              const Text('📍 Musterstraße 12, 12345 Stadt'),
              Text('🚗 ~${f['entfernung']} km'),
              Text('💰 ${f['preis']} €/h'),
              const Divider(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Bewertungen:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      ChoiceChip(
                        label: const Text('Datum', style: TextStyle(fontSize: 13)),
                        selected: sortiereNach == 'Datum',
                        selectedColor: Colors.teal.shade100,
                        onSelected: (_) => setState(() {
                          if (sortiereNach == 'Datum') {
                            aufsteigend = !aufsteigend;
                          } else {
                            sortiereNach = 'Datum';
                            aufsteigend = true;
                          }
                        }),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sortiereNach == 'Datum'
                              ? Colors.teal.shade900
                              : Colors.black,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      const SizedBox(width: 6),
                      ChoiceChip(
                        label: const Text('Bewertung', style: TextStyle(fontSize: 13)),
                        selected: sortiereNach == 'Bewertung',
                        selectedColor: Colors.teal.shade100,
                        onSelected: (_) => setState(() {
                          if (sortiereNach == 'Bewertung') {
                            aufsteigend = !aufsteigend;
                          } else {
                            sortiereNach = 'Bewertung';
                            aufsteigend = true;
                          }
                        }),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: sortiereNach == 'Bewertung'
                              ? Colors.teal.shade900
                              : Colors.black,
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      IconButton(
                        icon: Icon(
                          aufsteigend ? Icons.arrow_upward : Icons.arrow_downward,
                          size: 20,
                        ),
                        onPressed: () => setState(() => aufsteigend = !aufsteigend),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Column(
                children: sortierteRatings.map((r) {
                  return ListTile(
                    dense: true,
                    title: Text(r['text']),
                    subtitle: Row(
                      children: [
                        buildStarDisplay(r['rating'], size: 18),
                        const SizedBox(width: 8),
                        Text(r['date'].toString().split(' ')[0]),
                      ],
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              const Text('Welches Problem liegt vor?', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: ausgewaehltesProblem,
                items: probleme.map((p) => DropdownMenuItem(value: p, child: Text(p))).toList(),
                onChanged: (val) => setState(() => ausgewaehltesProblem = val),
                decoration: InputDecoration(
                  hintText: 'Problem auswählen...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: verfuegbar && problemGegeben
                    ? () {
                        Navigator.pop(context);

                        showDialog(
                          context: context,
                          builder: (context) {
                            final name = f['name'];
                            final entfernung = (f['entfernung'] as double).round();

                            return AlertDialog(
                              title: const Text('Auftrag bestätigt'),
                              content: Text(
                                '$name ist in ca. $entfernung Minuten bei Ihnen und hilft dir weiter.\n\nVielen Dank!',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('OK'),
                                ),
                              ],
                            );
                          },
                        );

                        // TODO: Auftrag an Firebase übermitteln
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: verfuegbar ? Colors.amber : Colors.grey[300],
                  foregroundColor: Colors.black,
                  minimumSize: const Size.fromHeight(50),
                ),
                child: const Text('Zahlungspflichtig bestellen'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
