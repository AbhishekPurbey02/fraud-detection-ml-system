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
  String statusMessage = 'Select a transaction sample';
  List<double>? selectedFeatures;
  String selectedSampleName = 'No sample selected';
  final safeSample = <double>[
  0.0,
  -1.3598071336738,
  -0.0727811733098497,
  2.53634673796914,
  1.37815522427443,
  -0.338320769942518,
  0.462387777762292,
  0.239598554061257,
  0.0986979012610507,
  0.363786969611213,
  0.0907941719789316,
  -0.551599533260813,
  -0.617800855762348,
  -0.991389847235408,
  -0.311169353699879,
  1.46817697209427,
  -0.470400525259478,
  0.207971241929242,
  0.0257905801985591,
  0.403992960255733,
  0.251412098239705,
  -0.018306777944153,
  0.277837575558899,
  -0.110473910188767,
  0.0669280749146731,
  0.128539358273528,
  -0.189114843888824,
  0.133558376740387,
  -0.0210530534538215,
  149.62,
];

final fraudSample = <double>[
  406.0,
  -2.3122265423263,
  1.95199201064158,
  -1.60985073229769,
  3.9979055875468,
  -0.522187864667764,
  -1.42654531920595,
  -2.53738730624579,
  1.39165724829804,
  -2.77008927719433,
  -2.77227214465915,
  3.20203320709635,
  -2.89990738849473,
  -0.595221881324605,
  -4.28925378244217,
  0.389724120274487,
  -1.14074717980657,
  -2.83005567450437,
  -0.0168224681808257,
  0.416955705037907,
  0.126910559061474,
  0.517232370861764,
  -0.0350493686052974,
  -0.465211076182388,
  0.320198198514526,
  0.0445191674731724,
  0.177839798284401,
  0.261145002567677,
  -0.143275874698919,
  0.0,
];
void selectSample(String sampleName, List<double> features) {
  setState(() {
    selectedSampleName = sampleName;
    selectedFeatures = features;
    statusMessage = '$sampleName selected. Ready to predict.';
  });
}

  Future<void> checkBackendHealth() async {
  setState(() {
    statusMessage = 'Checking backend...';
  });

  try {
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
  } catch (error) {
    setState(() {
      statusMessage = 'Connection failed:\n$error';
    });
  }
}

Future<void> testPrediction() async {
  if (selectedFeatures == null) {
    setState(() {
      statusMessage = 'Please select a sample first.';
    });
    return;
  }

  setState(() {
    statusMessage = 'Predicting $selectedSampleName...';
  });

  try {
    final url = Uri.parse('http://127.0.0.1:5000/predict');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'features': selectedFeatures,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      setState(() {
        statusMessage =
            'Prediction: ${data["result"]}\nRisk: ${data["risk_percentage"]}%';
      });
    } else {
      setState(() {
        statusMessage = 'Prediction error:\n${data["error"]}';
      });
    }
  } catch (error) {
    setState(() {
      statusMessage = 'Connection failed:\n$error';
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
                onPressed: () => selectSample('Safe sample', safeSample),
                child: const Text('Load Safe Sample'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => selectSample('Fraud sample', fraudSample),
                child: const Text('Load Fraud Sample'),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: testPrediction,
                child: const Text('Predict Transaction'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
