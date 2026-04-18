import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perfil de Usuário',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  List<Map<String, String>> _profiles = [];

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<File> get _profileFile async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/profile.json');
  }

  Future<void> _loadProfiles() async {
    try {
      final file = await _profileFile;
      if (await file.exists()) {
        final contents = await file.readAsString();
        final data = jsonDecode(contents);
        setState(() {
          _profiles = List<Map<String, String>>.from(
            (data as List).map((e) => Map<String, String>.from(e)),
          );
        });
      }
    } catch (e) {
      debugPrint('Erro ao carregar perfis: $e');
    }
  }

  Future<void> _saveProfile() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    if (name.isEmpty || email.isEmpty) return;

    final updated = [..._profiles, {'name': name, 'email': email}];
    final file = await _profileFile;
    await file.writeAsString(jsonEncode(updated));

    setState(() {
      _profiles = updated;
      _nameController.clear();
      _emailController.clear();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Perfil de Usuário'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nome',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'E-mail',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveProfile,
              child: const Text('Salvar'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Perfis salvos',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Expanded(
              child: _profiles.isEmpty
                  ? const Center(child: Text('Nenhum perfil salvo.'))
                  : ListView.builder(
                      itemCount: _profiles.length,
                      itemBuilder: (context, index) {
                        final p = _profiles[index];
                        return ListTile(
                          leading: const Icon(Icons.person),
                          title: Text(p['name'] ?? ''),
                          subtitle: Text(p['email'] ?? ''),
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
