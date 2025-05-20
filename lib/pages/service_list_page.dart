import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../account_tab/auth_choice_body.dart';
import '../widgets/main_scaffold.dart';
import 'handwerker_liste_page.dart';
import 'anliegen_erfassen_page.dart';

class ServiceListPage extends StatefulWidget {
  final String categoryName;
  const ServiceListPage({super.key, required this.categoryName});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  final _controller = TextEditingController();
  String searchQuery = '';

  final Map<String, List<String>> categoryServices = const {
    'Elektriker': ['Steckdose reparieren', 'Lichtinstallation', 'Katzen füttern'],
    'Klempner': ['Toilette verstopft', 'Wasserhahn tauschen'],
    // ...
  };

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
    final services = (categoryServices[widget.categoryName] ?? [])
        .where((s) => s.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(title: Text('Leistungen: ${widget.categoryName}')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _controller,
            onChanged: (v) => setState(() => searchQuery = v),
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
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
          const SizedBox(height: 20),
          if (services.isEmpty)
            const Text('Keine Dienstleistung gefunden')
          else
            ...services.map((service) => Card(
                  child: ListTile(
                    title: Text(service),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              HandwerkerListePage(leistung: service),
                        ),
                      );
                    },
                  ),
                )),
          const Divider(height: 32),
          OutlinedButton.icon(
            onPressed: () async {
              final result = await Navigator.push<String>(
                context,
                MaterialPageRoute(
                  builder: (_) => const AnliegenErfassenPage(),
                ),
              );
              if (result != null && result.trim().isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        HandwerkerListePage(leistung: result),
                  ),
                );
              }
            },
            icon: const Icon(Icons.add),
            label: const Text('Anderes Anliegen?'),
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
