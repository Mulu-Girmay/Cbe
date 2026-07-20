// lib/providers/auth_provider.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cbe_mobile_app/services/auth_service.dart';
import 'package:cbe_mobile_app/services/api_service.dart';
import 'package:cbe_mobile_app/models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final ApiService _apiService = ApiService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  bool _isAuthenticated = false;
  String? _error;

  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
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
        _userModel = UserModel.fromJson(response['data']);
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
      // OTP will be verified separately
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
      _firebaseUser = result.user;
      _isAuthenticated = true;

      // Login to backend
      final response = await _apiService.post('/auth/login', {});
      if (response['success'] == true) {
        _userModel = UserModel.fromJson(response['data']);
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
      _firebaseUser = result.user;
      _isAuthenticated = true;

      // Login to backend
      final response = await _apiService.post('/auth/login', {});
      if (response['success'] == true) {
        _userModel = UserModel.fromJson(response['data']);
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
