import 'package:flutter/material.dart';
import '../pages/service_list_page.dart';
//import '../pages/handwerker_detail_sheet.dart';
import '../pages/firma_detail_sheet.dart';

final List<Map<String, String>> searchItems = [
  {'type': 'Handwerksdienst', 'value': 'Max Müller'},
  {'type': 'Handwerksdienst', 'value': 'Anna Becker'},
  {'type': 'Dienstleistung', 'value': 'Toilette verstopft'},
  {'type': 'Dienstleistung', 'value': 'Schrank montieren'},
  {'type': 'Unternehmen', 'value': 'Muster GmbH'},
  {'type': 'Unternehmen', 'value': 'Reparatur Express'},
];

class SearchSuggestionsBar extends StatefulWidget {
  const SearchSuggestionsBar({super.key});

  @override
  State<SearchSuggestionsBar> createState() => _SearchSuggestionsBarState();
}

class _SearchSuggestionsBarState extends State<SearchSuggestionsBar> {
  final TextEditingController _controller = TextEditingController();
  String query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = searchItems
        .where((item) =>
            item['value']!.toLowerCase().startsWith(query.toLowerCase()))
        .toList();

    final grouped = <String, List<Map<String, String>>>{};
    for (var item in filtered) {
      grouped.putIfAbsent(item['type']!, () => []).add(item);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _controller,
          onChanged: (val) => setState(() => query = val),
          decoration: InputDecoration(
            hintText: 'Suche nach Name, Dienst, Firma...',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: query.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() => query = '');
                    },
                  )
                : null,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 10),
        if (query.isNotEmpty)
          SizedBox(
            height: 250,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: grouped.entries.map((entry) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.key,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      ...entry.value.map((item) => ListTile(
                            title: Text(item['value']!),
                            onTap: () {
                              _controller.text = item['value']!;
                              setState(() => query = item['value']!);

                              final type = item['type'];

                              if (type == 'Dienstleistung') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ServiceListPage(
                                        categoryName: 'Sonstige Anliegen'),
                                  ),
                                );
                             } else if (type == 'Handwerksdienst') {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => FirmaDetailSheet( // 👈 wir nutzen testweise FirmaDetailSheet für ALLE, um das Dropdown zu sehen
      firma: {
        'name': item['value'],
        'beruf': 'Elektriker',
        'preis': 50,
        'entfernung': 2.0,
        'verfuegbar': true,
        'bild': 'assets/profile_pics/images.png',
      },
    ),
  );
}
 else if (type == 'Unternehmen') {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(20)),
                                  ),
                                  builder: (_) => FirmaDetailSheet(
                                    firma: {
                                      'name': item['value'],
                                      'beruf': 'Sanitärfirma',
                                      'preis': 65,
                                      'entfernung': 3.4,
                                      'verfuegbar': true,
                                      'bild': 'assets/profile_pics/images.png',
                                    },
                                  ),
                                );
                              }
                            },
                          )),
                      const Divider(),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
      ],
    );
  }
}
