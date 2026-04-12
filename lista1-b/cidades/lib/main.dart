import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pesquisa de Cidades',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const CitySearchPage(),
    );
  }
}

class CitySearchPage extends StatefulWidget {
  const CitySearchPage({super.key});

  @override
  State<CitySearchPage> createState() => _CitySearchPageState();
}

class _CitySearchPageState extends State<CitySearchPage> {
  // Lista de cidades brasileiras
  static const List<String> _cidadesBrasileiras = [
    'São Paulo',
    'Rio de Janeiro',
    'Brasília',
    'Salvador',
    'Fortaleza',
    'Belo Horizonte',
    'Manaus',
    'Curitiba',
    'Recife',
    'Porto Alegre',
    'Belém',
    'Goiânia',
    'Guarulhos',
    'Campinas',
    'São Luís',
    'São Gonçalo',
    'Maceió',
    'Duque de Caxias',
    'Natal',
    'Teresina',
    'Campo Grande',
    'Nova Iguaçu',
    'São Bernardo do Campo',
    'João Pessoa',
    'Santo André',
    'Osasco',
    'Jaboatão dos Guararapes',
    'São José dos Campos',
    'Ribeirão Preto',
    'Uberlândia',
    'Sorocaba',
    'Contagem',
    'Aracaju',
    'Feira de Santana',
    'Cuiabá',
    'Joinville',
    'Juiz de Fora',
    'Londrina',
    'Aparecida de Goiânia',
    'Porto Velho',
  ];

  String? _cidadeSelecionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Pesquisa de Cidades'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Digite o nome da cidade:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Autocomplete<String>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<String>.empty();
                }
                return _cidadesBrasileiras.where((String cidade) {
                  return cidade
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              onSelected: (String selection) {
                setState(() {
                  _cidadeSelecionada = selection;
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
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Digite para pesquisar...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: textEditingController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              textEditingController.clear();
                              setState(() {
                                _cidadeSelecionada = null;
                              });
                            },
                          )
                        : null,
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            if (_cidadeSelecionada != null) ...[
              const Text(
                'Cidade selecionada:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.deepPurple.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_city,
                        color: Colors.deepPurple.shade700),
                    const SizedBox(width: 12),
                    Text(
                      _cidadeSelecionada!,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
