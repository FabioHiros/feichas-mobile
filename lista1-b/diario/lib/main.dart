import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Diário Pessoal',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DiaryPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DiaryPage extends StatefulWidget {
  const DiaryPage({super.key});

  @override
  State<DiaryPage> createState() => _DiaryPageState();
}

class _DiaryPageState extends State<DiaryPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final TextEditingController _textController = TextEditingController();
  Map<String, String> _diaryEntries = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadDiaryEntries();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // Carrega as entradas do diário do armazenamento local
  Future<void> _loadDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final String? entriesJson = prefs.getString('diary_entries');
    if (entriesJson != null) {
      setState(() {
        _diaryEntries = Map<String, String>.from(json.decode(entriesJson));
        _isLoading = false;
        _loadEntryForSelectedDay();
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Salva as entradas do diário no armazenamento local
  Future<void> _saveDiaryEntries() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('diary_entries', json.encode(_diaryEntries));
  }

  // Carrega a entrada para o dia selecionado
  void _loadEntryForSelectedDay() {
    if (_selectedDay != null) {
      final dateKey = _formatDate(_selectedDay!);
      _textController.text = _diaryEntries[dateKey] ?? '';
    }
  }

  // Formata a data como string para usar como chave
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  // Salva a entrada atual
  void _saveCurrentEntry() {
    if (_selectedDay != null) {
      final dateKey = _formatDate(_selectedDay!);
      final text = _textController.text.trim();
      
      setState(() {
        if (text.isEmpty) {
          _diaryEntries.remove(dateKey);
        } else {
          _diaryEntries[dateKey] = text;
        }
      });
      
      _saveDiaryEntries();
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Entrada salva com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // Verifica se um dia tem entrada
  bool _hasEntryForDay(DateTime day) {
    final dateKey = _formatDate(day);
    return _diaryEntries.containsKey(dateKey) && _diaryEntries[dateKey]!.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diário Pessoal'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 2,
      ),
      body: Column(
        children: [
          // Calendário
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _loadEntryForSelectedDay();
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            // Personaliza o estilo do calendário
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.deepPurple.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
              selectedDecoration: const BoxDecoration(
                color: Colors.deepPurple,
                shape: BoxShape.circle,
              ),
              markerDecoration: const BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
            // Adiciona marcadores para dias com entradas
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (_hasEntryForDay(date)) {
                  return Positioned(
                    bottom: 1,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: true,
              titleCentered: true,
              formatButtonShowsNext: false,
            ),
          ),
          const Divider(height: 1),
          // Área de texto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Entrada do dia ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(
                    child: TextField(
                      controller: _textController,
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      decoration: InputDecoration(
                        hintText: 'Escreva sua entrada de diário aqui...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _saveCurrentEntry,
                      icon: const Icon(Icons.save),
                      label: const Text('Salvar Entrada'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
