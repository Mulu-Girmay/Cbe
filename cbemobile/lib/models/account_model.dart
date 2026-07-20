// lib/models/account_model.dart
class Account {
  final String id;
  final String userId;
  final String accountNumber;
  final double balance;
  final String accountType;
  final String currency;
  final bool isActive;

  Account({
    required this.id,
    required this.userId,
    required this.accountNumber,
    required this.balance,
    required this.accountType,
    this.currency = 'ETB',
    this.isActive = true,
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      accountNumber: json['account_number'] ?? '',
      balance: double.parse(json['balance'].toString()),
      accountType: json['account_type'] ?? 'Savings',
      currency: json['currency'] ?? 'ETB',
      isActive: json['is_active'] ?? true,
    );
  }

  String get formattedBalance {
    return '${balance.toStringAsFixed(2)} $currency';
  }
}
