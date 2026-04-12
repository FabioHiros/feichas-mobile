import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Compras',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ShoppingListPage(),
    );
  }
}

// Modelo de item de compras
class ShoppingItem {
  String name;
  bool isPurchased;

  ShoppingItem({required this.name, this.isPurchased = false});
}

class ShoppingListPage extends StatefulWidget {
  const ShoppingListPage({super.key});

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  // Lista de itens de compras
  final List<ShoppingItem> _shoppingList = [];
  
  // Controlador do TextField
  final TextEditingController _textController = TextEditingController();

  // Adicionar item à lista
  void _addItem() {
    if (_textController.text.isNotEmpty) {
      setState(() {
        _shoppingList.add(ShoppingItem(name: _textController.text));
        _textController.clear();
      });
    }
  }

  // Remover item da lista
  void _removeItem(int index) {
    setState(() {
      _shoppingList.removeAt(index);
    });
  }

  // Alternar estado de comprado
  void _togglePurchased(int index) {
    setState(() {
      _shoppingList[index].isPurchased = !_shoppingList[index].isPurchased;
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Lista de Compras'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Campo de entrada
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(
                      labelText: 'Adicionar item',
                      hintText: 'Digite o nome do item',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                    onSubmitted: (_) => _addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                  ),
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
          const Divider(),
          // Lista de itens
          Expanded(
            child: _shoppingList.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.shopping_basket_outlined,
                          size: 80,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum item na lista',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _shoppingList.length,
                    itemBuilder: (context, index) {
                      final item = _shoppingList[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        child: ListTile(
                          leading: Checkbox(
                            value: item.isPurchased,
                            onChanged: (bool? value) {
                              _togglePurchased(index);
                            },
                          ),
                          title: Text(
                            item.name,
                            style: TextStyle(
                              decoration: item.isPurchased
                                  ? TextDecoration.lineThrough
                                  : TextDecoration.none,
                              color: item.isPurchased
                                  ? Colors.grey
                                  : Colors.black,
                            ),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeItem(index),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
