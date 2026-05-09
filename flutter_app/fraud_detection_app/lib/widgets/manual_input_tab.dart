import 'package:flutter/material.dart';

class ManualInputTab extends StatefulWidget {
  const ManualInputTab({super.key});

  @override
  State<ManualInputTab> createState() => _ManualInputTabState();
}

class _ManualInputTabState extends State<ManualInputTab> {
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
  'e.g. -2.31', 'e.g. 1.95', 'e.g. -1.60', 'e.g. 3.99',
  'e.g. -0.52', 'e.g. -1.42', 'e.g. -2.53', 'e.g. 1.39',
  'e.g. -2.77', 'e.g. -2.77', 'e.g. 3.20', 'e.g. -2.89',
  'e.g. -0.59', 'e.g. -4.28', 'e.g. 0.38', 'e.g. -1.14',
  'e.g. -2.83', 'e.g. -0.01', 'e.g. 0.41', 'e.g. 0.12',
  'e.g. 0.51', 'e.g. -0.03', 'e.g. -0.46', 'e.g. 0.32',
  'e.g. 0.04', 'e.g. 0.17', 'e.g. 0.26', 'e.g. -0.14',
  'e.g. 149.62',
];

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
                onPressed: () {},
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
            ],
          ),
        ),
      ),
    );
  }
}
