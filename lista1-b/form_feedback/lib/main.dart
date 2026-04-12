import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Formulário de Feedback',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _comentariosController = TextEditingController();
  String? _avaliacao;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _comentariosController.dispose();
    super.dispose();
  }

  void _enviarFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_avaliacao == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Por favor, selecione uma avaliação'),
            backgroundColor: Colors.orange,
          ),
        );
        return;
      }

      // Simulação do envio
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Feedback enviado com sucesso!\n'
            'Nome: ${_nomeController.text}\n'
            'Email: ${_emailController.text}\n'
            'Avaliação: $_avaliacao',
          ),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Limpar formulário
      _formKey.currentState!.reset();
      _nomeController.clear();
      _emailController.clear();
      _comentariosController.clear();
      setState(() {
        _avaliacao = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Formulário de Feedback'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Compartilhe sua opinião',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Campo Nome
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome',
                  hintText: 'Digite seu nome',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu nome';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Campo Email
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Digite seu email',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira seu email';
                  }
                  if (!value.contains('@')) {
                    return 'Por favor, insira um email válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Avaliação
              const Text(
                'Avaliação do Serviço',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),

              // Radio Buttons
              RadioListTile<String>(
                title: const Text('Excelente'),
                value: 'Excelente',
                groupValue: _avaliacao,
                onChanged: (value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Bom'),
                value: 'Bom',
                groupValue: _avaliacao,
                onChanged: (value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Regular'),
                value: 'Regular',
                groupValue: _avaliacao,
                onChanged: (value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
              ),
              RadioListTile<String>(
                title: const Text('Ruim'),
                value: 'Ruim',
                groupValue: _avaliacao,
                onChanged: (value) {
                  setState(() {
                    _avaliacao = value;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Campo Comentários
              TextFormField(
                controller: _comentariosController,
                decoration: const InputDecoration(
                  labelText: 'Comentários',
                  hintText: 'Digite seus comentários aqui...',
                  prefixIcon: Icon(Icons.comment),
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 5,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 24),

              // Botão Enviar
              ElevatedButton(
                onPressed: _enviarFeedback,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Enviar Feedback',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
