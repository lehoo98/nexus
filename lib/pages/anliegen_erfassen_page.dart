import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'handwerker_liste_page.dart';
import '../widgets/app_shell.dart';

class AnliegenErfassenPage extends StatefulWidget {
  const AnliegenErfassenPage({super.key});

  @override
  State<AnliegenErfassenPage> createState() => _AnliegenErfassenPageState();
}

class _AnliegenErfassenPageState extends State<AnliegenErfassenPage> {
  final TextEditingController _beschreibungController = TextEditingController();
  final List<File> _bilder = [];

  Future<void> _bildHinzufuegen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _bilder.add(File(picked.path));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppShell(
      currentIndex: 0,
      child: Scaffold(
        appBar: AppBar(title: const Text('Anliegen erfassen')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Was ist dein Anliegen?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _beschreibungController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Beschreibe dein Problem...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Bilder hinzufügen (optional):',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ..._bilder.map((img) => Image.file(img, width: 100, height: 100, fit: BoxFit.cover)),
                GestureDetector(
                  onTap: _bildHinzufuegen,
                  child: Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HandwerkerListePage(
                      leistung: 'Individuelles Anliegen',
                      beschreibung: _beschreibungController.text,
                      bilder: _bilder,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text('Anfrage absenden'),
            ),
          ],
        ),
      ),
    );
  }
}
