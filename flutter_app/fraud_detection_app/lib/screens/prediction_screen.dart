import 'package:flutter/material.dart';
import '../services/fraud_api_service.dart';
import '../data/sample_transactions.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String selectedSample = 'No sample selected';
  String predictionResult = '';
  List<double>? selectedFeatures;
  final FraudApiService apiService = FraudApiService();

  void selectSample(String sampleName, List<double> features) {
    setState(() {
      selectedSample = sampleName;
      selectedFeatures = features;
    });
  }

  Future<void> predictTransaction() async {
    if (selectedFeatures == null) {
      setState(() {
        predictionResult = 'Please select a transaction sample first.';
      });
      return;
    }

    setState(() {
      predictionResult = 'Predicting transaction...';
    });

    try {
      final result = await apiService.predictTransaction(selectedFeatures!);

      setState(() {
        predictionResult =
            'Prediction: ${result["result"]}\nRisk: ${result["risk_percentage"]}%';
      });
    } catch (error) {
      setState(() {
        predictionResult = 'Error: $error';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Transaction Prediction'),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Choose Transaction Sample',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  selectedSample,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4B5563),
                  ),
                ),
                const SizedBox(height: 32),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed:
                          () => selectSample(
                            'Safe sample selected',
                            safeTransactionSample,
                          ),
                      icon: const Icon(Icons.verified_user),
                      label: const Text('Safe Sample'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed:
                          () => selectSample(
                            'Fraud sample selected',
                            fraudTransactionSample,
                          ),
                      icon: const Icon(Icons.warning),
                      label: const Text('Fraud Sample'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                FilledButton(
                  onPressed: predictTransaction,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF253B80),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
                  ),
                  child: const Text('Predict Transaction'),
                ),
                const SizedBox(height: 24),
                Text(
                  predictionResult,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF111827),
                    fontWeight: FontWeight.w600,
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
