import 'dart:convert';
import 'package:http/http.dart' as http;

class FraudApiService {
  final String baseUrl = 'http://127.0.0.1:5000';

  Future<Map<String, dynamic>> predictTransaction(List<double> features) async {
    final url = Uri.parse('$baseUrl/predict');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'features': features,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return data;
    } else {
      throw Exception(data['error'] ?? 'Prediction failed');
    }
  }
}
