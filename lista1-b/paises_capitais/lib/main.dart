import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Classe para representar um país e sua capital
class Pais {
  final String nome;
  final String capital;

  Pais({required this.nome, required this.capital});
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Países e Capitais',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const PaisesCapitaisPage(),
    );
  }
}

class PaisesCapitaisPage extends StatefulWidget {
  const PaisesCapitaisPage({super.key});

  @override
  State<PaisesCapitaisPage> createState() => _PaisesCapitaisPageState();
}

class _PaisesCapitaisPageState extends State<PaisesCapitaisPage> {
  // Lista de países e suas capitais
  final List<Pais> paises = [
    Pais(nome: 'Brasil', capital: 'Brasília'),
    Pais(nome: 'Argentina', capital: 'Buenos Aires'),
    Pais(nome: 'Portugal', capital: 'Lisboa'),
    Pais(nome: 'Estados Unidos', capital: 'Washington D.C.'),
    Pais(nome: 'França', capital: 'Paris'),
    Pais(nome: 'Alemanha', capital: 'Berlim'),
    Pais(nome: 'Itália', capital: 'Roma'),
    Pais(nome: 'Espanha', capital: 'Madri'),
    Pais(nome: 'Japão', capital: 'Tóquio'),
    Pais(nome: 'China', capital: 'Pequim'),
    Pais(nome: 'Índia', capital: 'Nova Délhi'),
    Pais(nome: 'Canadá', capital: 'Ottawa'),
    Pais(nome: 'México', capital: 'Cidade do México'),
    Pais(nome: 'Reino Unido', capital: 'Londres'),
    Pais(nome: 'Austrália', capital: 'Camberra'),
  ];

  String? capitalSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Países e Capitais'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Pesquise um país:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Autocomplete<Pais>(
              displayStringForOption: (Pais pais) => pais.nome,
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Pais>.empty();
                }
                return paises.where((Pais pais) {
                  return pais.nome
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (Pais pais) {
                setState(() {
                  capitalSelecionada = pais.capital;
                });
              },
              fieldViewBuilder: (
                BuildContext context,
                TextEditingController textEditingController,
                FocusNode focusNode,
                VoidCallback onFieldSubmitted,
              ) {
                return TextField(
                  controller: textEditingController,
                  focusNode: focusNode,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Digite o nome do país',
                    prefixIcon: Icon(Icons.search),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Capital:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: capitalSelecionada ?? ''),
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Capital do país selecionado',
                prefixIcon: Icon(Icons.location_city),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
