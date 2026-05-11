class PredictionRecord {
  final String source;
  final String result;
  final double riskPercentage;
  final DateTime createdAt;

  const PredictionRecord({
    required this.source,
    required this.result,
    required this.riskPercentage,
    required this.createdAt,
  });

  bool get isFraud => result == 'Fraud Transaction';
}
