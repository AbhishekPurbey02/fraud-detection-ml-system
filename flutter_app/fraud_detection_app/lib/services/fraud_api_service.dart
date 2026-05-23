import 'dart:convert';
import 'package:fraud_detection_app/config/api_config.dart';
import 'package:http/http.dart' as http;
import '../models/prediction_record.dart';

class FraudApiService {
  final String baseUrl = ApiConfig.baseUrl;

  Future<Map<String, dynamic>> predictTransaction(
    List<double> features, {
    String source = 'API Prediction',
  }) async {
    final url = Uri.parse('$baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'features': features, 'source': source}),
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

  Future<Map<String, dynamic>> registerUser({
    required String name,
    required String email,
    required String password,
    String role = 'analyst',
  }) async {
    final url = Uri.parse('$baseUrl/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 201) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Registration failed');
    }
  }

  Future<Map<String, dynamic>> loginUser({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Login failed');
    }
  }
}
