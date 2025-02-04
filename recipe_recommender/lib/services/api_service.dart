import 'dart:convert';
import 'package:http/http.dart' as http;
 
class ApiService {
  static Future<Map<String, dynamic>> post(String url, Map<String, dynamic> body) async {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
 
    if (response.statusCode == 200 || response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.body}');
    }
  }
 
  static Future<Map<String, dynamic>> get(String url) async {
    final response = await http.get(Uri.parse(url));
 
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get data: ${response.body}');
    }
  }
}
 
 