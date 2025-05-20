import 'package:flutter/material.dart';
import 'handwerker_liste_page.dart';
import '../pages/anliegen_erfassen_page.dart';
import '../widgets/app_shell.dart';

class ServiceListPage extends StatefulWidget {
  final String categoryName;

  const ServiceListPage({super.key, required this.categoryName});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final TextEditingController _controller = TextEditingController();
//  final TextEditingController _anliegenController = TextEditingController();

  String searchQuery = '';

  final Map<String, List<String>> categoryServices = const {
    'Elektriker': ['Steckdose reparieren', 'Lichtinstallation', 'Katzen füttern'],
    'Klempner': ['Toilette verstopft', 'Wasserhahn tauschen'],
    'Maler': ['Wand streichen', 'Decke renovieren'],
    'Schreiner': ['Schrank montieren', 'Tisch reparieren'],
    'Heizung': ['Heizung entlüften', 'Thermostat tauschen'],
    'Reinigung': ['Wohnung putzen', 'Fensterreinigung'],
    'Hausmeister': ['Winterdienst', 'Hausflur reinigen'],
    'Sonstige Anliegen': ['Individuelle Anfrage', 'Beratung nötig'],
  };

  @override
  Widget build(BuildContext context) {
    final services = (categoryServices[widget.categoryName] ?? [])
        .where((s) => s.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return AppShell(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(title: Text('Leistungen: ${widget.categoryName}')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // 🔍 Suchleiste
            TextField(
              controller: _controller,
              onChanged: (val) => setState(() => searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Suche nach Dienstleistung...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          setState(() => searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // 📋 Gefilterte Dienstleistungen
            if (services.isEmpty)
              const Text('Keine Dienstleistung gefunden')
            else
              ...services.map(
                (service) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    title: Text(service),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              HandwerkerListePage(leistung: service),
                        ),
                      );
                    },
                  ),
                ),
              ),

            const Divider(height: 32),

            const SizedBox(height: 8),

            // ➕ Eigene Seite für Anliegen mit Bildern
            OutlinedButton.icon(
  onPressed: () async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (context) => const AnliegenErfassenPage(),
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HandwerkerListePage(leistung: result),
        ),
      );
    }
  },
  icon: const Icon(Icons.add),
  label: const Text('Anderes Anliegen?'),
),
          ],
        ),
      ),
    );
  }
}
