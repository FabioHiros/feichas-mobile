import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _selectedTheme = 'Claro';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Configurações de Preferência',
      theme: _selectedTheme == 'Claro' 
        ? ThemeData.light().copyWith(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          )
        : ThemeData.dark().copyWith(
            colorScheme: ColorScheme.fromSeed(
              seedColor: Colors.blue,
              brightness: Brightness.dark,
            ),
          ),
      home: MyHomePage(
        onThemeChanged: (theme) {
          setState(() {
            _selectedTheme = theme;
          });
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Function(String) onThemeChanged;
  
  const MyHomePage({super.key, required this.onThemeChanged});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _selectedTheme = 'Claro';
  String _selectedLanguage = 'Português';
  final TextEditingController _usernameController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Configurações de Preferência'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Seção de Tema
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tema',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      title: const Text('Claro'),
                      value: 'Claro',
                      groupValue: _selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          _selectedTheme = value!;
                          widget.onThemeChanged(value);
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Escuro'),
                      value: 'Escuro',
                      groupValue: _selectedTheme,
                      onChanged: (value) {
                        setState(() {
                          _selectedTheme = value!;
                          widget.onThemeChanged(value);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Idioma
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Idioma',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    RadioListTile<String>(
                      title: const Text('Português'),
                      value: 'Português',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Inglês'),
                      value: 'Inglês',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                    RadioListTile<String>(
                      title: const Text('Espanhol'),
                      value: 'Espanhol',
                      groupValue: _selectedLanguage,
                      onChanged: (value) {
                        setState(() {
                          _selectedLanguage = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Seção de Nome de Usuário
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nome de Usuário',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Digite seu nome de usuário',
                        hintText: 'Ex: João Silva',
                        prefixIcon: Icon(Icons.person),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Seção de Exibição das Seleções Atuais
            Card(
              color: Theme.of(context).colorScheme.primaryContainer,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Seleções Atuais',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context,
                      'Tema:',
                      _selectedTheme,
                      Icons.brightness_6,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      'Idioma:',
                      _selectedLanguage,
                      Icons.language,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoRow(
                      context,
                      'Nome de Usuário:',
                      _usernameController.text.isEmpty 
                        ? '(não definido)' 
                        : _usernameController.text,
                      Icons.person,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
        ),
      ],
    );
  }
}
