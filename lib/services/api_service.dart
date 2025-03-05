import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://api.adviceslip.com/advice';

  // API dan maslahat olish
  Future<String> fetchAdvice() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['slip']['advice'];  // JSON dan advice ma'lumotini olish
    } else {
      throw Exception('Failed to load advice');
    }
  }
}
