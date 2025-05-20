import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../account_tab/auth_choice_body.dart';
import '../widgets/main_scaffold.dart';
import 'handwerker_liste_page.dart';

class AnliegenErfassenPage extends StatefulWidget {
  const AnliegenErfassenPage({super.key});
  @override
  State<AnliegenErfassenPage> createState() => _AnliegenErfassenPageState();
}

class _AnliegenErfassenPageState extends State<AnliegenErfassenPage> {
  final _beschreibungController = TextEditingController();
  final List<File> _bilder = [];

  Future<void> _bildHinzufuegen() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _bilder.add(File(picked.path)));
    }
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
              ..._bilder.map((img) => Image.file(img,
                  width: 100, height: 100, fit: BoxFit.cover)),
              GestureDetector(
                onTap: _bildHinzufuegen,
                child: Container(
                  width: 100,
                  height: 100,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HandwerkerListePage(
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
