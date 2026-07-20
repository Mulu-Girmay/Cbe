// lib/providers/transaction_provider.dart
import 'package:flutter/material.dart';
import 'package:cbe_mobile_app/services/api_service.dart';
import 'package:cbe_mobile_app/models/transaction_model.dart';

class TransactionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  bool _isLoading = false;
  Transaction? _lastTransaction;
  String? _error;

  bool get isLoading => _isLoading;
  Transaction? get lastTransaction => _lastTransaction;
  String? get error => _error;

  Future<bool> sendMoney({
    required String receiverAccount,
    required double amount,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.post('/transactions/send', {
        'receiverAccountNumber': receiverAccount,
        'amount': amount,
        'description': description ?? 'Money transfer',
      });

      if (response['success'] == true) {
        _lastTransaction =
            Transaction.fromJson(response['data']['transaction']);
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

  Future<Transaction?> getTransactionByReference(String reference) async {
    try {
      final response = await _apiService.get('/transactions/$reference');

      if (response['success'] == true) {
        return Transaction.fromJson(response['data']);
      }
      return null;
    } catch (e) {
      return null;
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

  void clearLastTransaction() {
    _lastTransaction = null;
    notifyListeners();
  }
}
