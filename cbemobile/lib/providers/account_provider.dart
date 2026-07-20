// lib/providers/account_provider.dart
import 'package:flutter/material.dart';
import 'package:cbe_mobile_app/services/api_service.dart';
import 'package:cbe_mobile_app/models/transaction_model.dart';

class AccountProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  double _balance = 0.0;
  String _accountNumber = '';
  String _accountType = 'Savings';
  List<Transaction> _recentTransactions = [];
  Map<String, dynamic> _stats = {};
  String? _error;

  bool get isLoading => _isLoading;
  double get balance => _balance;
  String get accountNumber => _accountNumber;
  String get accountType => _accountType;
  List<Transaction> get recentTransactions => _recentTransactions;
  Map<String, dynamic> get stats => _stats;
  String? get error => _error;

  Future<void> fetchAccountDetails() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.get('/account/profile');

      if (response['success'] == true) {
        final data = response['data'];

        // Update account info
        _balance = data['account']['balance'] ?? 0.0;
        _accountNumber = data['account']['number'] ?? '';
        _accountType = data['account']['type'] ?? 'Savings';
        _stats = data['stats'] ?? {};

        // Update transactions
        if (data['recentTransactions'] != null) {
          _recentTransactions = (data['recentTransactions'] as List)
              .map((t) => Transaction.fromJson(t))
              .toList();
        }

        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<List<Transaction>> fetchTransactionHistory(
      {int limit = 50, int offset = 0}) async {
    try {
      final response = await _apiService
          .get('/account/transactions?limit=$limit&offset=$offset');

      if (response['success'] == true) {
        return (response['data'] as List)
            .map((t) => Transaction.fromJson(t))
            .toList();
      }
      return [];
    } catch (e) {
      return [];
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
}
