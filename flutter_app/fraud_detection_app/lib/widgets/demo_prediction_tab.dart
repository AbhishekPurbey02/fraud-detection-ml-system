import 'package:flutter/material.dart';
import 'prediction_result_card.dart';

class DemoPredictionTab extends StatelessWidget {
  final String selectedSample;
  final bool isSafeSelected;
  final bool isFraudSelected;
  final bool isLoading;
  final String errorMessage;
  final String? predictionLabel;
  final double? riskPercentage;
  final VoidCallback onSelectSafe;
  final VoidCallback onSelectFraud;
  final VoidCallback onPredict;

  const DemoPredictionTab({
    super.key,
    required this.selectedSample,
    required this.isSafeSelected,
    required this.isFraudSelected,
    required this.isLoading,
    required this.errorMessage,
    required this.predictionLabel,
    required this.riskPercentage,
    required this.onSelectSafe,
    required this.onSelectFraud,
    required this.onPredict,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
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
                    onPressed: onSelectSafe,
                    icon: const Icon(Icons.verified_user),
                    label: const Text('Safe Sample'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isSafeSelected
                          ? const Color(0xFFE8F5E9)
                          : Colors.transparent,
                      foregroundColor: isSafeSelected
                          ? const Color(0xFF1B5E20)
                          : const Color(0xFF253B80),
                      side: BorderSide(
                        color: isSafeSelected
                            ? const Color(0xFF2E7D32)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: onSelectFraud,
                    icon: const Icon(Icons.warning),
                    label: const Text('Fraud Sample'),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: isFraudSelected
                          ? const Color(0xFFFFEBEE)
                          : Colors.transparent,
                      foregroundColor: isFraudSelected
                          ? const Color(0xFFB71C1C)
                          : const Color(0xFF253B80),
                      side: BorderSide(
                        color: isFraudSelected
                            ? const Color(0xFFD32F2F)
                            : const Color(0xFF9CA3AF),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              FilledButton(
                onPressed: onPredict,
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
