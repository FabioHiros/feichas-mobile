import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Média',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculadoraMedia(),
    );
  }
}

class CalculadoraMedia extends StatefulWidget {
  const CalculadoraMedia({super.key});

  @override
  State<CalculadoraMedia> createState() => _CalculadoraMediaState();
}

class _CalculadoraMediaState extends State<CalculadoraMedia> {
  final TextEditingController _nota1Controller = TextEditingController();
  final TextEditingController _nota2Controller = TextEditingController();
  final TextEditingController _nota3Controller = TextEditingController();
  
  String _resultado = '';

  void _calcularMedia() {
    final nota1 = double.tryParse(_nota1Controller.text);
    final nota2 = double.tryParse(_nota2Controller.text);
    final nota3 = double.tryParse(_nota3Controller.text);

    if (nota1 == null || nota2 == null || nota3 == null) {
      setState(() {
        _resultado = 'Por favor, insira valores válidos para todas as notas!';
      });
      return;
    }

    final media = (nota1 + nota2 + nota3) / 3;
    
    setState(() {
      _resultado = 'Média Aritmética: ${media.toStringAsFixed(2)}';
    });
  }

  void _limparCampos() {
    _nota1Controller.clear();
    _nota2Controller.clear();
    _nota3Controller.clear();
    setState(() {
      _resultado = '';
    });
  }

  @override
  void dispose() {
    _nota1Controller.dispose();
    _nota2Controller.dispose();
    _nota3Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Média Aritmética'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Insira as três notas:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _nota1Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Nota 1',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nota2Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Nota 2',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _nota3Controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Nota 3',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.edit),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _calcularMedia,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      'Calcular Média',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limparCampos,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Limpar',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (_resultado.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: _resultado.contains('válidos')
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _resultado.contains('válidos')
                        ? Colors.red
                        : Colors.green,
                    width: 2,
                  ),
                ),
                child: Text(
                  _resultado,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: _resultado.contains('válidos')
                        ? Colors.red.shade900
                        : Colors.green.shade900,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
