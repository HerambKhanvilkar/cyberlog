import 'dart:convert';
import 'package:http/http.dart' as http;

class CyberTipService {
  static Future<String> fetchCyberTip() async {
    final url = Uri.parse("https://api.adviceslip.com/advice");

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['slip']['advice'];
    } else {
      throw Exception("Failed to fetch cyber tip");
    }
  }
}
