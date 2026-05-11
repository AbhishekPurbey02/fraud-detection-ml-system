import 'package:flutter/material.dart';
import '../models/prediction_record.dart';
import '../services/prediction_history_service.dart';
import '../widgets/dashboard_stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final records = PredictionHistoryService.getRecords();

    final total = records.length;
    final fraudCount = records.where((record) => record.isFraud).length;
    final safeCount = total - fraudCount;

    final averageRisk =
        total == 0
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
        actions: [
          IconButton(
            onPressed: () {
              PredictionHistoryService.clear();

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Prediction history cleared')),
              );

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DashboardScreen(),
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Clear history',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overview',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 20),

            GridView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 260,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.8,
              ),
              children: [
                DashboardStatCard(
                  title: 'Total Predictions',
                  value: total.toString(),
                  color: const Color(0xFF253B80),
                ),
                DashboardStatCard(
                  title: 'Safe Transactions',
                  value: safeCount.toString(),
                  color: const Color(0xFF2E7D32),
                ),
                DashboardStatCard(
                  title: 'Fraud Alerts',
                  value: fraudCount.toString(),
                  color: const Color(0xFFD32F2F),
                ),
                DashboardStatCard(
                  title: 'Average Risk',
                  value: '${averageRisk.toStringAsFixed(1)}%',
                  color: const Color(0xFF7C3AED),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Text(
              'Recent Predictions',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: const Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 16),
            if (records.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: const Text(
                  'No predictions yet. Run a prediction to see history.',
                ),
              )
            else
              Column(
                children:
                    records.reversed.map((record) {
                      final color =
                          record.isFraud
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF2E7D32);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: color.withOpacity(0.25)),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              record.isFraud
                                  ? Icons.warning
                                  : Icons.check_circle,
                              color: color,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    record.result,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: const Color(0xFF111827),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    record.source,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyMedium?.copyWith(
                                      color: const Color(0xFF6B7280),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '${record.riskPercentage.toStringAsFixed(0)}%',
                              style: Theme.of(
                                context,
                              ).textTheme.titleMedium?.copyWith(
                                color: color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
              ),
          ],
        ),
      ),
    );
  }
}
