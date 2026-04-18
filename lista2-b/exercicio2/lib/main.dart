import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de Despesas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const ExpenseManagerPage(),
    );
  }
}

class Expense {
  final String description;
  final double value;

  Expense({required this.description, required this.value});

  Map<String, dynamic> toJson() => {
        'description': description,
        'value': value,
      };

  factory Expense.fromJson(Map<String, dynamic> json) => Expense(
        description: json['description'] as String,
        value: (json['value'] as num).toDouble(),
      );
}

class ExpenseManagerPage extends StatefulWidget {
  const ExpenseManagerPage({super.key});

  @override
  State<ExpenseManagerPage> createState() => _ExpenseManagerPageState();
}

class _ExpenseManagerPageState extends State<ExpenseManagerPage> {
  final _descriptionController = TextEditingController();
  final _valueController = TextEditingController();
  List<Expense> _expenses = [];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/despesas.json');
  }

  Future<void> _loadExpenses() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonList = jsonDecode(contents);
        setState(() {
          _expenses = jsonList.map((e) => Expense.fromJson(e)).toList();
        });
      }
    } catch (_) {}
  }

  Future<void> _saveExpenses() async {
    final file = await _getFile();
    await file.writeAsString(jsonEncode(_expenses.map((e) => e.toJson()).toList()));
  }

  void _addExpense() {
    final description = _descriptionController.text.trim();
    final value = double.tryParse(_valueController.text.trim().replaceAll(',', '.'));

    if (description.isEmpty || value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha descrição e valor válido.')),
      );
      return;
    }

    setState(() {
      _expenses.add(Expense(description: description, value: value));
    });
    _saveExpenses();
    _descriptionController.clear();
    _valueController.clear();
  }

  double get _total => _expenses.fold(0, (sum, e) => sum + e.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Gerenciador de Despesas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Descrição',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _valueController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Valor (R\$)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addExpense,
                child: const Text('Adicionar Despesa'),
              ),
            ),
            const SizedBox(height: 16),
            if (_expenses.isNotEmpty)
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'Total: R\$ ${_total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            const SizedBox(height: 8),
            Expanded(
              child: _expenses.isEmpty
                  ? const Center(child: Text('Nenhuma despesa registrada.'))
                  : ListView.builder(
                      itemCount: _expenses.length,
                      itemBuilder: (context, index) {
                        final expense = _expenses[index];
                        return Card(
                          child: ListTile(
                            title: Text(expense.description),
                            trailing: Text(
                              'R\$ ${expense.value.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
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
