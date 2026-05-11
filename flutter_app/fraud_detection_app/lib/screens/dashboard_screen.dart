import 'package:flutter/material.dart';
import '../models/prediction_record.dart';
import '../services/prediction_history_service.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = PredictionHistoryService.getRecords();

    final total = records.length;
    final fraudCount = records.where((record) => record.isFraud).length;
    final safeCount = total - fraudCount;

    final averageRisk = total == 0
        ? 0.0
        : records
                .map((record) => record.riskPercentage)
                .reduce((a, b) => a + b) /
            total;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      appBar: AppBar(
        title: const Text('Fraud Dashboard'),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Total: $total\nSafe: $safeCount\nFraud: $fraudCount\nAverage Risk: ${averageRisk.toStringAsFixed(1)}%',
        ),
      ),
    );
  }
}
