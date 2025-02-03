import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  String? _userId;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get userId => _userId;

  Future<void> login(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await AuthService.login(email, password);
      _userId = response['userId'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  Future<void> register(String username, String email, String password) async {
    _setLoading(true);
    _errorMessage = null;

    try {
      final response = await AuthService.register(username, email, password);
      _userId = response['userId'];
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void logout() {
    _userId = null;
    notifyListeners();
  }
}