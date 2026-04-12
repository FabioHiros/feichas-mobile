import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Conversor de Temperatura',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const TemperatureConverter(),
    );
  }
}

class TemperatureConverter extends StatefulWidget {
  const TemperatureConverter({super.key});

  @override
  State<TemperatureConverter> createState() => _TemperatureConverterState();
}

class _TemperatureConverterState extends State<TemperatureConverter> {
  final TextEditingController _celsiusController = TextEditingController();
  String _fahrenheitResult = '';
  double? _currentCelsius;

  void _convertTemperature() {
    final String celsiusText = _celsiusController.text;
    
    if (celsiusText.isEmpty) {
      setState(() {
        _fahrenheitResult = '';
        _currentCelsius = null;
      });
      return;
    }

    final double? celsius = double.tryParse(celsiusText);
    
    if (celsius == null) {
      setState(() {
        _fahrenheitResult = 'Valor inválido';
        _currentCelsius = null;
      });
      return;
    }

    // Fórmula: F = (C * 9/5) + 32
    final double fahrenheit = (celsius * 9 / 5) + 32;
    
    setState(() {
      _currentCelsius = celsius;
      _fahrenheitResult = fahrenheit.toStringAsFixed(1);
    });
  }

  Color _getTemperatureColor(double? celsius) {
    if (celsius == null) return Colors.grey;
    if (celsius < 0) return Colors.blue.shade700;
    if (celsius < 15) return Colors.cyan.shade600;
    if (celsius < 25) return Colors.green.shade600;
    if (celsius < 35) return Colors.orange.shade600;
    return Colors.red.shade700;
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final temperatureColor = _getTemperatureColor(_currentCelsius);
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              temperatureColor.withOpacity(0.15),
              Colors.white,
              temperatureColor.withOpacity(0.1),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                // Title
                Text(
                  'CONVERSOR',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'DE TEMPERATURA',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 2,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 50),
                
                // Input Section
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: temperatureColor.withOpacity(0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.device_thermostat,
                            size: 40,
                            color: temperatureColor,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Celsius',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: temperatureColor,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      TextField(
                        controller: _celsiusController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: temperatureColor,
                        ),
                        decoration: InputDecoration(
                          hintText: '0',
                          hintStyle: TextStyle(
                            color: Colors.grey.shade300,
                          ),
                          suffixText: '°C',
                          suffixStyle: TextStyle(
                            fontSize: 24,
                            color: temperatureColor,
                          ),
                          border: InputBorder.none,
                        ),
                        onChanged: (_) => _convertTemperature(),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Arrow
                Icon(
                  Icons.arrow_downward_rounded,
                  size: 40,
                  color: temperatureColor.withOpacity(0.5),
                ),
                
                const SizedBox(height: 40),
                
                // Result Section
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        temperatureColor,
                        temperatureColor.withOpacity(0.7),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: temperatureColor.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(32.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(
                            Icons.whatshot,
                            size: 40,
                            color: Colors.white,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Fahrenheit',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _fahrenheitResult.isEmpty ? '--' : _fahrenheitResult,
                        style: const TextStyle(
                          fontSize: 64,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: -2,
                        ),
                      ),
                      if (_fahrenheitResult.isNotEmpty && _fahrenheitResult != 'Valor inválido')
                        const Text(
                          '°F',
                          style: TextStyle(
                            fontSize: 32,
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Formula
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'F = (C × 9/5) + 32',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                      fontFamily: 'Courier',
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
