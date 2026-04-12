import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Produtos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CatalogoProdutos(),
    );
  }
}

// Modelo de Produto
class Produto {
  final String nome;
  final double preco;
  final String descricao;

  Produto({
    required this.nome,
    required this.preco,
    required this.descricao,
  });
}

class CatalogoProdutos extends StatelessWidget {
  const CatalogoProdutos({super.key});

  // Listas de produtos por categoria
  static final List<Produto> eletronicos = [
    Produto(
      nome: 'Smartphone Galaxy S24',
      preco: 3499.99,
      descricao: 'Smartphone com 256GB de armazenamento',
    ),
    Produto(
      nome: 'Notebook Dell Inspiron',
      preco: 4299.00,
      descricao: 'Notebook i7, 16GB RAM, 512GB SSD',
    ),
    Produto(
      nome: 'Fone de Ouvido Bluetooth',
      preco: 299.90,
      descricao: 'Fone sem fio com cancelamento de ruído',
    ),
    Produto(
      nome: 'Smart TV 55"',
      preco: 2599.00,
      descricao: 'TV 4K com Android TV',
    ),
    Produto(
      nome: 'Tablet iPad',
      preco: 3899.00,
      descricao: 'iPad 10ª geração, 64GB',
    ),
  ];

  static final List<Produto> roupas = [
    Produto(
      nome: 'Camiseta Básica',
      preco: 49.90,
      descricao: 'Camiseta 100% algodão',
    ),
    Produto(
      nome: 'Calça Jeans',
      preco: 159.90,
      descricao: 'Calça jeans slim fit',
    ),
    Produto(
      nome: 'Jaqueta de Couro',
      preco: 599.00,
      descricao: 'Jaqueta de couro legítimo',
    ),
    Produto(
      nome: 'Tênis Esportivo',
      preco: 299.90,
      descricao: 'Tênis para corrida e caminhada',
    ),
    Produto(
      nome: 'Vestido Floral',
      preco: 189.90,
      descricao: 'Vestido longo estampado',
    ),
  ];

  static final List<Produto> livros = [
    Produto(
      nome: 'O Senhor dos Anéis',
      preco: 89.90,
      descricao: 'Edição completa da trilogia',
    ),
    Produto(
      nome: 'Clean Code',
      preco: 79.90,
      descricao: 'Guia de programação limpa',
    ),
    Produto(
      nome: 'Harry Potter - Coleção',
      preco: 249.00,
      descricao: 'Box com 7 livros',
    ),
    Produto(
      nome: '1984',
      preco: 39.90,
      descricao: 'Clássico de George Orwell',
    ),
    Produto(
      nome: 'Sapiens',
      preco: 54.90,
      descricao: 'Uma breve história da humanidade',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Catálogo de Produtos'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.devices),
                text: 'Eletrônicos',
              ),
              Tab(
                icon: Icon(Icons.checkroom),
                text: 'Roupas',
              ),
              Tab(
                icon: Icon(Icons.book),
                text: 'Livros',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildProductList(eletronicos),
            _buildProductList(roupas),
            _buildProductList(livros),
          ],
        ),
      ),
    );
  }

  Widget _buildProductList(List<Produto> produtos) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: produtos.length,
      itemBuilder: (context, index) {
        final produto = produtos[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16.0),
            title: Text(
              produto.nome,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Text(produto.descricao),
                const SizedBox(height: 8),
                Text(
                  'R\$ ${produto.preco.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              color: Theme.of(context).colorScheme.primary,
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${produto.nome} adicionado ao carrinho!'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
