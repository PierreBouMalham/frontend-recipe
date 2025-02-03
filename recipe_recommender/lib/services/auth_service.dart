import '../constants/api_endpoints.dart';
import 'api_service.dart';

class AuthService {
  static Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final body = {
      'username': username,
      'email': email,
      'password': password,
    };
    return await ApiService.post(ApiEndpoints.register, body);
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final body = {
      'email': email,
      'password': password,
    };
    return await ApiService.post(ApiEndpoints.login, body);
  }
}
