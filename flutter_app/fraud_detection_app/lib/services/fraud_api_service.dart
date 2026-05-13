import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/prediction_record.dart';

class FraudApiService {
  final String baseUrl = 'http://127.0.0.1:5000';

  Future<Map<String, dynamic>> predictTransaction(List<double> features) async {
    final url = Uri.parse('$baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'features': features}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Prediction failed');
    }
  }

  Future<List<PredictionRecord>> getPredictions() async {
    final url = Uri.parse('$baseUrl/predictions');

    final response = await http.get(url);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      final predictions = data['predictions'] as List;

      return predictions
          .map((item) => PredictionRecord.fromJson(item))
          .toList();
    } else {
      throw Exception(data['error'] ?? 'Failed to load predictions');
    }
  }

  Future<void> markPredictionReviewed(int id) async {
    final url = Uri.parse('$baseUrl/predictions/$id/review');

    final response = await http.patch(url);
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to mark prediction reviewed');
    }
  }

  Future<void> clearPredictions() async {
    final url = Uri.parse('$baseUrl/predictions');

    final response = await http.delete(url);
    final data = jsonDecode(response.body);

    if (response.statusCode != 200) {
      throw Exception(data['error'] ?? 'Failed to clear predictions');
    }
  }
}
