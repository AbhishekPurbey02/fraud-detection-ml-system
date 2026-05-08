import 'package:flutter/material.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  String selectedSample = 'No sample selected';

  void selectSample(String sampleName) {
    setState(() {
      selectedSample = sampleName;
    });
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
                      onPressed: () => selectSample('Safe sample selected'),
                      icon: const Icon(Icons.verified_user),
                      label: const Text('Safe Sample'),
                    ),
                    const SizedBox(width: 16),
                    OutlinedButton.icon(
                      onPressed: () => selectSample('Fraud sample selected'),
                      icon: const Icon(Icons.warning),
                      label: const Text('Fraud Sample'),
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: () {},
                  label: const Text('Predict Transaction'),
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF253B80),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 16,
                    ),
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
