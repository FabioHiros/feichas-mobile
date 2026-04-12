import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Desconto',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const DiscountCalculatorPage(),
    );
  }
}

class Product {
  final String name;
  final double originalPrice;
  final double discountPercentage;
  final double finalPrice;

  Product({
    required this.name,
    required this.originalPrice,
    required this.discountPercentage,
    required this.finalPrice,
  });
}

class DiscountCalculatorPage extends StatefulWidget {
  const DiscountCalculatorPage({super.key});

  @override
  State<DiscountCalculatorPage> createState() => _DiscountCalculatorPageState();
}

class _DiscountCalculatorPageState extends State<DiscountCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _discountController = TextEditingController();
  final List<Product> _products = [];
  double? _calculatedPrice;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  void _calculateDiscount() {
    if (_formKey.currentState!.validate()) {
      final originalPrice = double.parse(_priceController.text);
      final discountPercentage = double.parse(_discountController.text);
      final discountAmount = originalPrice * (discountPercentage / 100);
      final finalPrice = originalPrice - discountAmount;

      setState(() {
        _calculatedPrice = finalPrice;
      });
    }
  }

  void _addProduct() {
    if (_formKey.currentState!.validate() && _calculatedPrice != null) {
      final product = Product(
        name: _nameController.text,
        originalPrice: double.parse(_priceController.text),
        discountPercentage: double.parse(_discountController.text),
        finalPrice: _calculatedPrice!,
      );

      setState(() {
        _products.add(product);
        _nameController.clear();
        _priceController.clear();
        _discountController.clear();
        _calculatedPrice = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Produto adicionado com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _removeProduct(int index) {
    setState(() {
      _products.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Calculadora de Desconto'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'Dados do Produto',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nome do Produto',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.shopping_bag),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o nome do produto';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _priceController,
                          decoration: const InputDecoration(
                            labelText: 'Preço Original (R\$)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.attach_money),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o preço';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Por favor, insira um número válido';
                            }
                            if (double.parse(value) <= 0) {
                              return 'O preço deve ser maior que zero';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _discountController,
                          decoration: const InputDecoration(
                            labelText: 'Desconto (%)',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.percent),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, insira o desconto';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Por favor, insira um número válido';
                            }
                            final discount = double.parse(value);
                            if (discount < 0 || discount > 100) {
                              return 'O desconto deve estar entre 0 e 100';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton.icon(
                          onPressed: _calculateDiscount,
                          icon: const Icon(Icons.calculate),
                          label: const Text('Calcular Desconto'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                        if (_calculatedPrice != null) ...[
                          const SizedBox(height: 20),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.green),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Preço Final com Desconto',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'R\$ ${_calculatedPrice!.toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Economia: R\$ ${(double.parse(_priceController.text) - _calculatedPrice!).toStringAsFixed(2)}',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.green.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: _addProduct,
                            icon: const Icon(Icons.add),
                            label: const Text('Adicionar à Lista'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.all(16),
                              backgroundColor: Colors.green,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              if (_products.isNotEmpty) ...[
                const Text(
                  'Produtos Criados',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          product.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Preço Original: R\$ ${product.originalPrice.toStringAsFixed(2)}',
                            ),
                            Text(
                              'Desconto: ${product.discountPercentage.toStringAsFixed(0)}%',
                            ),
                            Text(
                              'Preço Final: R\$ ${product.finalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeProduct(index),
                        ),
                        isThreeLine: true,
                      ),
                    );
                  },
                ),
              ] else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32.0),
                    child: Text(
                      'Nenhum produto adicionado ainda.\nCalcule um desconto e adicione à lista!',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
