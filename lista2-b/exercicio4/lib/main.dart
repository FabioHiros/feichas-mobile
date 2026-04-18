import 'package:flutter/material.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import 'dart:io';

void main() {
  if (Platform.isLinux || Platform.isWindows || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Controle de Estoque',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const EstoquePage(),
    );
  }
}

class Produto {
  final int? id;
  final String nome;
  final int quantidade;

  Produto({this.id, required this.nome, required this.quantidade});

  Map<String, dynamic> toMap() => {'nome': nome, 'quantidade': quantidade};
}

class EstoqueDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    final dbPath = await getDatabasesPath();
    _db = await openDatabase(
      join(dbPath, 'estoque.db'),
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE produtos(id INTEGER PRIMARY KEY AUTOINCREMENT, nome TEXT, quantidade INTEGER)',
        );
      },
    );
    return _db!;
  }

  static Future<void> inserir(Produto produto) async {
    final db = await database;
    await db.insert('produtos', produto.toMap());
  }

  static Future<List<Produto>> listar() async {
    final db = await database;
    final maps = await db.query('produtos');
    return maps
        .map((m) => Produto(id: m['id'] as int, nome: m['nome'] as String, quantidade: m['quantidade'] as int))
        .toList();
  }
}

class EstoquePage extends StatefulWidget {
  const EstoquePage({super.key});

  @override
  State<EstoquePage> createState() => _EstoquePageState();
}

class _EstoquePageState extends State<EstoquePage> {
  final _nomeController = TextEditingController();
  final _quantidadeController = TextEditingController();
  final _buscaController = TextEditingController();
  List<Produto> _produtos = [];
  List<Produto> _produtosFiltrados = [];

  @override
  void initState() {
    super.initState();
    _buscaController.addListener(_filtrar);
    _carregarProdutos();
  }

  @override
  void dispose() {
    _buscaController.dispose();
    super.dispose();
  }

  void _filtrar() {
    final termo = _buscaController.text.toLowerCase();
    setState(() {
      _produtosFiltrados = _produtos
          .where((p) => p.nome.toLowerCase().contains(termo))
          .toList();
    });
  }

  Future<void> _carregarProdutos() async {
    final lista = await EstoqueDatabase.listar();
    setState(() {
      _produtos = lista;
      _produtosFiltrados = lista
          .where((p) => p.nome.toLowerCase().contains(_buscaController.text.toLowerCase()))
          .toList();
    });
  }

  Future<void> _adicionarProduto() async {
    final nome = _nomeController.text.trim();
    final quantidade = int.tryParse(_quantidadeController.text.trim());

    if (nome.isEmpty || quantidade == null) return;

    await EstoqueDatabase.inserir(Produto(nome: nome, quantidade: quantidade));
    _nomeController.clear();
    _quantidadeController.clear();
    await _carregarProdutos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Controle de Estoque'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(
                labelText: 'Nome do produto',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _quantidadeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Quantidade',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _adicionarProduto,
                child: const Text('Cadastrar'),
              ),
            ),
            const SizedBox(height: 16),
            const Divider(),
            TextField(
              controller: _buscaController,
              decoration: const InputDecoration(
                labelText: 'Buscar produto',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text('Produtos em estoque', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _produtosFiltrados.isEmpty
                  ? const Center(child: Text('Nenhum produto encontrado.'))
                  : ListView.builder(
                      itemCount: _produtosFiltrados.length,
                      itemBuilder: (context, index) {
                        final p = _produtosFiltrados[index];
                        return ListTile(
                          leading: const Icon(Icons.inventory_2),
                          title: Text(p.nome),
                          trailing: Text('Qtd: ${p.quantidade}', style: const TextStyle(fontSize: 16)),
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
