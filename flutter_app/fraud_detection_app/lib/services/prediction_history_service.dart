import '../models/prediction_record.dart';

class PredictionHistoryService {
  static final List<PredictionRecord> _records = [];

  static void addRecord(PredictionRecord record) {
    _records.add(record);
  }

  static List<PredictionRecord> getRecords() {
    return List.unmodifiable(_records);
  }

  static void clear() {
    _records.clear();
  }

  static void markReviewed(PredictionRecord record) {
    final index = _records.indexOf(record);

    if (index == -1) {
      return;
    }

    _records[index] = record.copyWith(reviewed: true);
  }
}
