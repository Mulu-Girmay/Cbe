// lib/utils/constants.dart
class AppConstants {
  // App info
  static const String appName = 'CBE Banking';
  static const String appVersion = '1.0.0';

  // API endpoints
  static const String baseUrl = 'http://localhost:5000/api';

  // Storage keys
  static const String tokenKey = 'firebase_token';
  static const String verificationIdKey = 'verification_id';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Transaction types
  static const String transactionTypeTransfer = 'transfer';
  static const String transactionTypeDeposit = 'deposit';
  static const String transactionTypeWithdrawal = 'withdrawal';
  static const String transactionTypePayment = 'payment';

  // Transaction status
  static const String statusPending = 'pending';
  static const String statusCompleted = 'completed';
  static const String statusFailed = 'failed';
  static const String statusReversed = 'reversed';

  // Account types
  static const String accountTypeSavings = 'Savings';
  static const String accountTypeCurrent = 'Current';
  static const String accountTypeBusiness = 'Business';

  // Currencies
  static const String currencyETB = 'ETB';

  // Limits
  static const double minTransferAmount = 1.0;
  static const double maxTransferAmount = 1000000.0;

  // Regular expressions
  static const String phoneRegex = r'^\+?[0-9]{9,13}$';
  static const String emailRegex =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';
  static const String accountNumberRegex = r'^[0-9]{10}$';
}
