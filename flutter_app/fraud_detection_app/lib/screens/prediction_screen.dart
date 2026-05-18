import 'package:flutter/material.dart';
import 'package:fraud_detection_app/widgets/demo_prediction_tab.dart';
import 'package:fraud_detection_app/widgets/manual_input_tab.dart';
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
      final result = await apiService.predictTransaction(selectedFeatures!, source: selectedSample,);

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
            tabs: [Tab(text: 'DEMO SAMPLE'), Tab(text: 'MANUAL INPUT')],
          ),
        ),
        body: TabBarView(
          children: [
            DemoPredictionTab(
              selectedSample: selectedSample,
              isSafeSelected: isSafeSelected,
              isFraudSelected: isFraudSelected,
              isLoading: isLoading,
              errorMessage: errorMessage,
              predictionLabel: predictionLabel,
              riskPercentage: riskPercentage,
              onSelectSafe:
                  () => selectSample(
                    'Safe sample selected',
                    'safe',
                    safeTransactionSample,
                  ),
              onSelectFraud:
                  () => selectSample(
                    'Fraud sample selected',
                    'fraud',
                    fraudTransactionSample,
                  ),
              onPredict: predictTransaction,
            ),
            const ManualInputTab(),
          ],
        ),
      ),
    );
  }
}
