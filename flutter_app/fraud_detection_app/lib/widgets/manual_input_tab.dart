import 'package:flutter/material.dart';
import '../data/sample_transactions.dart';
import '../services/fraud_api_service.dart';
import 'prediction_result_card.dart';

class ManualInputTab extends StatefulWidget {
  const ManualInputTab({super.key});

  @override
  State<ManualInputTab> createState() => _ManualInputTabState();
}

class _ManualInputTabState extends State<ManualInputTab> {
  final FraudApiService apiService = FraudApiService();

  String? predictionLabel;
  double? riskPercentage;
  String errorMessage = '';
  bool isLoading = false;

  final featureNames = [
    'Time',
    'V1',
    'V2',
    'V3',
    'V4',
    'V5',
    'V6',
    'V7',
    'V8',
    'V9',
    'V10',
    'V11',
    'V12',
    'V13',
    'V14',
    'V15',
    'V16',
    'V17',
    'V18',
    'V19',
    'V20',
    'V21',
    'V22',
    'V23',
    'V24',
    'V25',
    'V26',
    'V27',
    'V28',
    'Amount',
  ];
  final featureHints = [
    'e.g. 406',
    'e.g. -2.31',
    'e.g. 1.95',
    'e.g. -1.60',
    'e.g. 3.99',
    'e.g. -0.52',
    'e.g. -1.42',
    'e.g. -2.53',
    'e.g. 1.39',
    'e.g. -2.77',
    'e.g. -2.77',
    'e.g. 3.20',
    'e.g. -2.89',
    'e.g. -0.59',
    'e.g. -4.28',
    'e.g. 0.38',
    'e.g. -1.14',
    'e.g. -2.83',
    'e.g. -0.01',
    'e.g. 0.41',
    'e.g. 0.12',
    'e.g. 0.51',
    'e.g. -0.03',
    'e.g. -0.46',
    'e.g. 0.32',
    'e.g. 0.04',
    'e.g. 0.17',
    'e.g. 0.26',
    'e.g. -0.14',
    'e.g. 149.62',
  ];
  void fillForm(List<double> sample) {
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].text = sample[i].toString();
    }
  }

  Future<void> predictManualTransaction() async {
    final features = <double>[];

    for (int i = 0; i < controllers.length; i++) {
      final value = double.tryParse(controllers[i].text.trim());

      if (value == null) {
        setState(() {
          errorMessage = 'Please enter a valid number for ${featureNames[i]}.';
          predictionLabel = null;
          riskPercentage = null;
        });
        return;
      }

      features.add(value);
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      predictionLabel = null;
      riskPercentage = null;
    });

    try {
      final result = await apiService.predictTransaction(features, source: 'Manual Input');

      setState(() {
        predictionLabel = result['result'];
        riskPercentage = (result['risk_percentage'] as num).toDouble();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
    }
  }

  late final List<TextEditingController> controllers;

  @override
  void initState() {
    super.initState();

    controllers = List.generate(
      featureNames.length,
      (index) => TextEditingController(),
    );
  }

  @override
  void dispose() {
    for (final controller in controllers) {
      controller.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Manual Transaction Input',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF111827),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter processed transaction features in the same order used by the model.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4B5563),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  OutlinedButton(
                    onPressed: () => fillForm(safeTransactionSample),
                    child: const Text('Fill Safe Example'),
                  ),
                  const SizedBox(width: 12),
                  OutlinedButton(
                    onPressed: () => fillForm(fraudTransactionSample),
                    child: const Text('Fill Fraud Example'),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: featureNames.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 180,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 3.2,
                ),
                itemBuilder: (context, index) {
                  return TextField(
                    controller: controllers[index],
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: true,
                    ),
                    decoration: InputDecoration(
                      labelText: featureNames[index],
                      hintText: featureHints[index],
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                  );
                },
              ),

              const SizedBox(height: 28),
              FilledButton(
                onPressed: predictManualTransaction,

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
              if (isLoading)
                const Text('Predicting transaction...')
              else if (errorMessage.isNotEmpty)
                Text(
                  errorMessage,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                )
              else if (predictionLabel != null && riskPercentage != null)
                PredictionResultCard(
                  predictionLabel: predictionLabel!,
                  riskPercentage: riskPercentage!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
