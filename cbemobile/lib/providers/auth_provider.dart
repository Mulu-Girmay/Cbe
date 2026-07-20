import 'package:cbe_mobile_app/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cbe_mobile_app/services/api_service.dart';
import 'package:cbe_mobile_app/models/user_model.dart'; // Your User model

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  firebase_auth.User? _firebaseUser; // ← Use firebase_auth.User
  User? _userModel; // ← Your User model (no prefix needed)
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  firebase_auth.User? get firebaseUser =>
      _firebaseUser; // ← Use firebase_auth.User
  User? get userModel => _userModel;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  String? get error => _error;

  AuthProvider() {
    _initAuth();
  }

  void _initAuth() {
    _authService.isLoggedIn().then((loggedIn) {
      if (loggedIn) {
        _firebaseUser = _authService.getCurrentUser();
        _isAuthenticated = true;
        _loadUserProfile();
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserProfile() async {
    try {
      final response = await _apiService.get('/account/profile');
      if (response['success'] == true) {
        _userModel =
            User.fromJson(response['data']['profile'] ?? response['data']);
        _isAuthenticated = true;
        notifyListeners();
      }
    } catch (e) {
      print('Load profile error: $e');
    }
  }

  Future<void> signInWithPhone(String phoneNumber) async {
    _setLoading(true);
    _clearError();

    try {
      await _authService.signInWithPhone(phoneNumber);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> verifyOTP(String smsCode) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.verifyOTP(smsCode);
      _firebaseUser = result.user; // ← firebase_auth.User
      _isAuthenticated = true;

      // Login to backend
      final response = await _apiService.post('/auth/login', {});
      if (response['success'] == true) {
        final userData = response['data'];
        if (userData is Map<String, dynamic>) {
          _userModel = User.fromJson(userData); // ← Your User model
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _authService.signInWithEmail(email, password);
      _firebaseUser = result.user; // ← firebase_auth.User
      _isAuthenticated = true;

      final response = await _apiService.post('/auth/login', {});
      if (response['success'] == true) {
        final userData = response['data'];
        if (userData is Map<String, dynamic>) {
          _userModel = User.fromJson(userData); // ← Your User model
        }
        return true;
      }
      return false;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _firebaseUser = null;
      _userModel = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
