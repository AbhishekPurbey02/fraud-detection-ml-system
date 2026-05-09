import 'package:flutter/material.dart';
import '../services/fraud_api_service.dart';
import '../data/sample_transactions.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String selectedSampleType = '';
  String selectedSample = 'No sample selected';
  String? predictionLabel;
  double? riskPercentage;
  String errorMessage = '';
  bool isLoading = false;

  List<double>? selectedFeatures;
  final FraudApiService apiService = FraudApiService();

  void selectSample(
    String sampleName,
    String sampleType,
    List<double> features,
  ) {
    setState(() {
      selectedSample = sampleName;
      selectedSampleType = sampleType;
      selectedFeatures = features;
      predictionLabel = null;
      riskPercentage = null;
      errorMessage = '';
    });
  }

  Future<void> predictTransaction() async {
    if (selectedFeatures == null) {
      setState(() {
        errorMessage = 'Please select a transaction sample first.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = '';
      predictionLabel = null;
      riskPercentage = null;
    });

    try {
      final result = await apiService.predictTransaction(selectedFeatures!);

      setState(() {
        predictionLabel = result["result"];
        riskPercentage = (result["risk_percentage"] as num).toDouble();
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        errorMessage = 'Error: $error';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSafeSelected = selectedSampleType == 'safe';
    final isFraudSelected = selectedSampleType == 'fraud';

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F8FC),
        appBar: AppBar(
          title: const Text('Transaction Prediction'),
          backgroundColor: Colors.white,
          bottom: const TabBar(
            tabs: [Tab(text: 'Demo Sample'), Tab(text: 'Manual Input')],
          ),
        ),
        body: TabBarView(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Choose Transaction Sample',
                        style: Theme.of(
                          context,
                        ).textTheme.headlineSmall?.copyWith(
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
                                  'safe',
                                  safeTransactionSample,
                                ),
                            icon: const Icon(Icons.verified_user),
                            label: const Text('Safe Sample'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  isSafeSelected
                                      ? const Color(0xFFE8F5E9)
                                      : Colors.transparent,
                              foregroundColor:
                                  isSafeSelected
                                      ? const Color(0xFF1B5E20)
                                      : const Color(0xFF253B80),
                              side: BorderSide(
                                color:
                                    isSafeSelected
                                        ? const Color(0xFF2E7D32)
                                        : const Color(0xFF9CA3AF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton.icon(
                            onPressed:
                                () => selectSample(
                                  'Fraud sample selected',
                                  'fraud',
                                  fraudTransactionSample,
                                ),
                            icon: const Icon(Icons.warning),
                            label: const Text('Fraud Sample'),
                            style: OutlinedButton.styleFrom(
                              backgroundColor:
                                  isFraudSelected
                                      ? const Color(0xFFFFEBEE)
                                      : Colors.transparent,
                              foregroundColor:
                                  isFraudSelected
                                      ? const Color(0xFFB71C1C)
                                      : const Color(0xFF253B80),
                              side: BorderSide(
                                color:
                                    isFraudSelected
                                        ? const Color(0xFFD32F2F)
                                        : const Color(0xFF9CA3AF),
                              ),
                            ),
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
                      if (isLoading)
                        const Text('Predicting transaction...')
                      else if (errorMessage.isNotEmpty)
                        Text(
                          errorMessage,
                          textAlign: TextAlign.center,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyLarge?.copyWith(
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      else if (predictionLabel != null &&
                          riskPercentage != null)
                        Builder(
                          builder: (context) {
                            final isFraud =
                                predictionLabel == 'Fraud Transaction';

                            final backgroundColor =
                                isFraud
                                    ? const Color(0xFFFFEBEE)
                                    : const Color(0xFFE8F5E9);

                            final borderColor =
                                isFraud
                                    ? const Color(0xFFD32F2F)
                                    : const Color(0xFF2E7D32);

                            final textColor =
                                isFraud
                                    ? const Color(0xFFB71C1C)
                                    : const Color(0xFF1B5E20);

                            return Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: backgroundColor,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: borderColor),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    predictionLabel!,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleLarge?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Risk Score: ${riskPercentage!.toStringAsFixed(0)}%',
                                    textAlign: TextAlign.center,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge?.copyWith(
                                      color: textColor,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),

            const Center(child: Text('Manual input form will be added here')),
          ],
        ),
      ),
    );
  }
}
