import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const FraudDetectionApp());
}

class FraudDetectionApp extends StatelessWidget {
  const FraudDetectionApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fraud Detection App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BackendCheckPage(),
    );
  }
}

class BackendCheckPage extends StatefulWidget {
  const BackendCheckPage({super.key});

  @override
  State<BackendCheckPage> createState() => _BackendCheckPageState();
}

class _BackendCheckPageState extends State<BackendCheckPage> {
  String statusMessage = 'Backend not checked yet';

  Future<void> checkBackendHealth() async {
    final url = Uri.parse('http://127.0.0.1:5000/health');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        statusMessage =
            'Status: ${data["status"]}\nModel Loaded: ${data["model_loaded"]}\nScaler Loaded: ${data["scaler_loaded"]}';
      });
    } else {
      setState(() {
        statusMessage = 'Backend error: ${response.statusCode}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fraud Detection App'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: checkBackendHealth,
                child: const Text('Check Backend'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
