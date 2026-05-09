import 'package:flutter/material.dart';

class PredictionResultCard extends StatelessWidget {
  final String predictionLabel;
  final double riskPercentage;

  const PredictionResultCard({
    super.key,
    required this.predictionLabel,
    required this.riskPercentage,
  });

  @override
  Widget build(BuildContext context) {
    final isFraud = predictionLabel == 'Fraud Transaction';

    final backgroundColor =
        isFraud ? const Color(0xFFFFEBEE) : const Color(0xFFE8F5E9);

    final borderColor =
        isFraud ? const Color(0xFFD32F2F) : const Color(0xFF2E7D32);

    final textColor =
        isFraud ? const Color(0xFFB71C1C) : const Color(0xFF1B5E20);

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
            predictionLabel,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            'Risk Score: ${riskPercentage.toStringAsFixed(0)}%',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
