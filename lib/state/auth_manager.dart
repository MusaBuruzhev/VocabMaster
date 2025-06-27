import 'package:flutter/material.dart';
import '../core/auth_service.dart';

class AuthManager with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isAuthenticated = false;
  String? _errorMessage;

  bool get isAuthenticated => _isAuthenticated;
  String? get errorMessage => _errorMessage;

  Future<void> checkAuthState() async {
    final user = _authService.getCurrentUser();
    _isAuthenticated = user != null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    try {
      final user = await _authService.signIn(email, password);
      _isAuthenticated = user != null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> register(String email, String password) async {
    try {
      final user = await _authService.register(email, password);
      _isAuthenticated = user != null;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await _authService.signOut();
    _isAuthenticated = false;
    notifyListeners();
  }
}