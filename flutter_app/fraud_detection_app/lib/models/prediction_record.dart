class PredictionRecord {
  final String source;
  final String result;
  final double riskPercentage;
  final DateTime createdAt;
  final bool reviewed;
  final int id;

  const PredictionRecord({
    required this.source,
    required this.result,
    required this.id,
    required this.riskPercentage,
    required this.createdAt,
    this.reviewed = false,
  });

  bool get isFraud => result == 'Fraud Transaction';
  PredictionRecord copyWith({
    String? source,
    int? id,
    String? result,
    double? riskPercentage,
    DateTime? createdAt,
    bool? reviewed,
  }) {
    return PredictionRecord(
      id: id ?? this.id,
      source: source ?? this.source,
      result: result ?? this.result,
      riskPercentage: riskPercentage ?? this.riskPercentage,
      createdAt: createdAt ?? this.createdAt,
      reviewed: reviewed ?? this.reviewed,
    );
  }

  factory PredictionRecord.fromJson(Map<String, dynamic> json) {
    return PredictionRecord(
      id: json['id'],
      source: json['source'],
      result: json['result'],
      riskPercentage: (json['risk_percentage'] as num).toDouble(),
      createdAt: DateTime.parse(json['created_at']),
      reviewed: json['reviewed'] == 1 || json['reviewed'] == true,
    );
  }
}
