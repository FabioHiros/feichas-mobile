import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agenda de Eventos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const EventSchedulerPage(),
    );
  }
}

class Event {
  final String name;
  final DateTime date;
  final String time;

  Event({required this.name, required this.date, required this.time});
}

class EventSchedulerPage extends StatefulWidget {
  const EventSchedulerPage({super.key});

  @override
  State<EventSchedulerPage> createState() => _EventSchedulerPageState();
}

class _EventSchedulerPageState extends State<EventSchedulerPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final TextEditingController _eventNameController = TextEditingController();
  final TextEditingController _eventTimeController = TextEditingController();
  final List<Event> _events = [];

  @override
  void dispose() {
    _eventNameController.dispose();
    _eventTimeController.dispose();
    super.dispose();
  }

  void _addEvent() {
    if (_eventNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome do evento')),
      );
      return;
    }

    if (_eventTimeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira a hora do evento')),
      );
      return;
    }

    setState(() {
      _events.add(Event(
        name: _eventNameController.text,
        date: _selectedDay,
        time: _eventTimeController.text,
      ));
      _eventNameController.clear();
      _eventTimeController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Evento adicionado com sucesso!')),
    );
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events.where((event) {
      return isSameDay(event.date, day);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Agenda de Eventos'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Calendário
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TableCalendar(
                    firstDay: DateTime(2020),
                    lastDay: DateTime(2030),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    calendarFormat: CalendarFormat.month,
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                    ),
                    calendarStyle: CalendarStyle(
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    eventLoader: _getEventsForDay,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Campo de nome do evento
              TextField(
                controller: _eventNameController,
                decoration: InputDecoration(
                  labelText: 'Nome do Evento',
                  hintText: 'Digite o nome do evento',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.event),
                ),
              ),
              const SizedBox(height: 16),
              
              // Campo de hora do evento
              TextField(
                controller: _eventTimeController,
                decoration: InputDecoration(
                  labelText: 'Hora do Evento',
                  hintText: 'Ex: 14:30',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  prefixIcon: const Icon(Icons.access_time),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),
              
              // Botão adicionar evento
              ElevatedButton.icon(
                onPressed: _addEvent,
                icon: const Icon(Icons.add),
                label: const Text('Adicionar Evento'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              
              // Título da lista de eventos
              const Text(
                'Eventos Agendados',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 2),
              const SizedBox(height: 8),
              
              // Lista de eventos
              _events.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: 64,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum evento agendado',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _events.length,
                      itemBuilder: (context, index) {
                        final event = _events[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                              child: const Icon(
                                Icons.event,
                                color: Colors.white,
                              ),
                            ),
                            title: Text(
                              event.name,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              '${DateFormat('dd/MM/yyyy').format(event.date)} às ${event.time}',
                            ),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _events.removeAt(index);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Evento removido'),
                                  ),
                                );
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
