import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro de Tarefas',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const TaskListPage(),
    );
  }
}

// Enum para prioridade da tarefa
enum TaskPriority {
  baixa,
  media,
  alta,
}

// Classe modelo para representar uma tarefa
class Task {
  String name;
  String description;
  bool isCompleted;
  TaskPriority priority;

  Task({
    required this.name,
    required this.description,
    this.isCompleted = false,
    this.priority = TaskPriority.media,
  });
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Task> _tasks = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TaskPriority _selectedPriority = TaskPriority.media;

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addTask() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira o nome da tarefa')),
      );
      return;
    }

    setState(() {
      _tasks.add(Task(
        name: _nameController.text,
        description: _descriptionController.text,
        priority: _selectedPriority,
      ));
      _nameController.clear();
      _descriptionController.clear();
      _selectedPriority = TaskPriority.media;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa adicionada com sucesso!')),
    );
  }

  void _toggleTaskCompletion(int index) {
    setState(() {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
    });
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tarefa removida')),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.baixa:
        return Colors.green;
      case TaskPriority.media:
        return Colors.orange;
      case TaskPriority.alta:
        return Colors.red;
    }
  }

  String _getPriorityLabel(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.baixa:
        return 'Baixa';
      case TaskPriority.media:
        return 'Média';
      case TaskPriority.alta:
        return 'Alta';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Cadastro de Tarefas Diárias'),
        elevation: 2,
      ),
      body: Column(
        children: [
          // Formulário de entrada
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campo de nome da tarefa
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nome da Tarefa',
                    hintText: 'Ex: Estudar Flutter',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.task_alt),
                  ),
                ),
                const SizedBox(height: 12),
                
                // Campo de descrição
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    hintText: 'Breve descrição da tarefa',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.description),
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                
                // Radio buttons para prioridade
                const Text(
                  'Prioridade:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<TaskPriority>(
                        title: const Text('Baixa'),
                        value: TaskPriority.baixa,
                        groupValue: _selectedPriority,
                        onChanged: (TaskPriority? value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<TaskPriority>(
                        title: const Text('Média'),
                        value: TaskPriority.media,
                        groupValue: _selectedPriority,
                        onChanged: (TaskPriority? value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<TaskPriority>(
                        title: const Text('Alta'),
                        value: TaskPriority.alta,
                        groupValue: _selectedPriority,
                        onChanged: (TaskPriority? value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                
                // Botão adicionar
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _addTask,
                    icon: const Icon(Icons.add),
                    label: const Text('Adicionar Tarefa'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Cabeçalho da lista
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Minhas Tarefas (${_tasks.length})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (_tasks.isNotEmpty)
                  Text(
                    'Concluídas: ${_tasks.where((t) => t.isCompleted).length}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
              ],
            ),
          ),
          
          // ListView com as tarefas
          Expanded(
            child: _tasks.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.task_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma tarefa cadastrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Adicione uma tarefa acima',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[400],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _tasks.length,
                    itemBuilder: (context, index) {
                      final task = _tasks[index];
                      return Card(
                        elevation: 2,
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          // Checkbox para marcar como concluída
                          leading: Checkbox(
                            value: task.isCompleted,
                            onChanged: (_) => _toggleTaskCompletion(index),
                          ),
                          
                          // Conteúdo da tarefa
                          title: Text(
                            task.name,
                            style: TextStyle(
                              decoration: task.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (task.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  task.description,
                                  style: TextStyle(
                                    decoration: task.isCompleted
                                        ? TextDecoration.lineThrough
                                        : null,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: _getPriorityColor(task.priority)
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Prioridade ${_getPriorityLabel(task.priority)}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _getPriorityColor(task.priority),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          
                          // Botão de deletar
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTask(index),
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
