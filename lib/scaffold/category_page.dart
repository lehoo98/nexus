import 'package:flutter/material.dart';
import '../pages/service_list_page.dart';
import '../widgets/search_bar_home.dart';
//import '../widgets/app_shell.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  static const List<Map<String, String>> categories = [
    {'name': 'Elektriker', 'image': 'assets/kategorien/Elektriker.png'},
    {'name': 'Klempner', 'image': 'assets/kategorien/Sanitar.png'},
    {'name': 'Maler', 'image': 'assets/kategorien/Maler.png'},
    {'name': 'Schreiner', 'image': 'assets/kategorien/Carpenter.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
           appBar: AppBar(
        title: const Text('Handwerker in deiner Nähe'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // 👑 Eigene AppBar im AppShell-Body
          const Padding(
            padding: EdgeInsets.only(top: 48, left: 20, right: 20, bottom: 8),
            child: Text(
              'Handwerker Kategorien',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: SearchSuggestionsBar(),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.9,
                children: categories.map((item) {
                  return GestureDetector(
                   onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          ServiceListPage(categoryName: item['name']!),
    ),
  );
},

                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundImage: AssetImage(item['image']!),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          item['name']!,
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
