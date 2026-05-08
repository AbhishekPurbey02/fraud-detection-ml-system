import 'package:flutter/material.dart';
import 'prediction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void startPrediction(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const PredictionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 760;

            final image = Image.asset(
              'assets/images/fraud_detection.png',
              height: isWide ? 360 : 240,
              fit: BoxFit.contain,
            );

            final content = Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment:
                  isWide ? CrossAxisAlignment.start : CrossAxisAlignment.center,
              children: [
                Text(
                  'AI Credit Card Fraud Detection System',
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Detect suspicious credit card transactions using a machine learning model trained on real transaction patterns.',
                  textAlign: isWide ? TextAlign.left : TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4B5563),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 32),
                FilledButton.icon(
                  onPressed: () => startPrediction(context),

                  label: const Text('Start Prediction'),
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
            );

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1040),
                  child:
                      isWide
                          ? Row(
                            children: [
                              Expanded(child: image),
                              const SizedBox(width: 56),
                              Expanded(child: content),
                            ],
                          )
                          : Column(
                            children: [
                              image,
                              const SizedBox(height: 28),
                              content,
                            ],
                          ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
