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
      title: 'Registro de Frequência',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      home: const AttendancePage(),
    );
  }
}

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  final _nameController = TextEditingController();
  Database? _db;
  List<Map<String, dynamic>> _attendees = [];

  @override
  void initState() {
    super.initState();
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    _db = await openDatabase(
      join(await getDatabasesPath(), 'attendance.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE attendees(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL)',
        );
      },
      version: 1,
    );
    await _loadAttendees();
  }

  Future<void> _loadAttendees() async {
    final rows = await _db!.query('attendees', orderBy: 'id DESC');
    setState(() {
      _attendees = rows;
    });
  }

  Future<void> _addName() async {
    final name = _nameController.text.trim();
    if (name.isEmpty || _db == null) return;

    await _db!.insert('attendees', {'name': name});
    _nameController.clear();
    await _loadAttendees();
  }

  Future<void> _deleteName(int id) async {
    await _db!.delete('attendees', where: 'id = ?', whereArgs: [id]);
    await _loadAttendees();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _db?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Registro de Frequência'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _addName(),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: _addName,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Adicionar'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  'Total: ${_attendees.length} presente(s)',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _attendees.isEmpty
                ? const Center(child: Text('Nenhum nome registrado.'))
                : ListView.builder(
                    itemCount: _attendees.length,
                    itemBuilder: (context, index) {
                      final attendee = _attendees[index];
                      return ListTile(
                        leading: const Icon(Icons.person),
                        title: Text(attendee['name'] as String),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteName(attendee['id'] as int),
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
