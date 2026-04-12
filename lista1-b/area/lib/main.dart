import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Área',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CalculadoraArea(),
    );
  }
}

class CalculadoraArea extends StatefulWidget {
  const CalculadoraArea({super.key});

  @override
  State<CalculadoraArea> createState() => _CalculadoraAreaState();
}

class _CalculadoraAreaState extends State<CalculadoraArea> {
  final TextEditingController _larguraController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();
  String _resultado = '';

  void _calcularArea() {
    final largura = double.tryParse(_larguraController.text);
    final altura = double.tryParse(_alturaController.text);

    if (largura == null || altura == null) {
      setState(() {
        _resultado = 'Por favor, insira valores válidos';
      });
      return;
    }

    if (largura <= 0 || altura <= 0) {
      setState(() {
        _resultado = 'Os valores devem ser maiores que zero';
      });
      return;
    }

    final area = largura * altura;
    setState(() {
      _resultado = 'Área do retângulo: ${area.toStringAsFixed(2)} unidades²';
    });
  }

  void _limpar() {
    setState(() {
      _larguraController.clear();
      _alturaController.clear();
      _resultado = '';
    });
  }

  @override
  void dispose() {
    _larguraController.dispose();
    _alturaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Área de Retângulo'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            const Icon(
              Icons.rectangle_outlined,
              size: 80,
              color: Colors.blue,
            ),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: _larguraController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Largura',
                        hintText: 'Digite a largura',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.width_normal),
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _alturaController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Altura',
                        hintText: 'Digite a altura',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.height),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _calcularArea,
                    icon: const Icon(Icons.calculate),
                    label: const Text('Calcular'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _limpar,
                    icon: const Icon(Icons.clear),
                    label: const Text('Limpar'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            if (_resultado.isNotEmpty)
              Card(
                color: _resultado.contains('Por favor') || 
                       _resultado.contains('devem ser')
                    ? Colors.red.shade50
                    : Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Icon(
                        _resultado.contains('Por favor') || 
                        _resultado.contains('devem ser')
                            ? Icons.error_outline
                            : Icons.check_circle_outline,
                        size: 40,
                        color: _resultado.contains('Por favor') || 
                               _resultado.contains('devem ser')
                            ? Colors.red
                            : Colors.green,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _resultado,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: _resultado.contains('Por favor') || 
                                 _resultado.contains('devem ser')
                              ? Colors.red.shade900
                              : Colors.green.shade900,
                        ),
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
}
