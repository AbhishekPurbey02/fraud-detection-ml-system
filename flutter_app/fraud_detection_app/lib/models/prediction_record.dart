class PredictionRecord {
  final String source;
  final String result;
  final double riskPercentage;
  final DateTime createdAt;
  final bool reviewed;

  const PredictionRecord({
    required this.source,
    required this.result,
    required this.riskPercentage,
    required this.createdAt,
     this.reviewed = false,
  });

  bool get isFraud => result == 'Fraud Transaction';
   PredictionRecord copyWith({
    String? source,
    String? result,
    double? riskPercentage,
    DateTime? createdAt,
    bool? reviewed,
  }) {
    return PredictionRecord(
      source: source ?? this.source,
      result: result ?? this.result,
      riskPercentage: riskPercentage ?? this.riskPercentage,
      createdAt: createdAt ?? this.createdAt,
      reviewed: reviewed ?? this.reviewed,
    );
  }
}
