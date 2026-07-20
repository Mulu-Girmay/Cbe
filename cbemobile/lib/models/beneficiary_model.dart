// lib/models/beneficiary_model.dart
class Beneficiary {
  final String id;
  final String userId;
  final String beneficiaryAccountId;
  final String nickname;
  final bool isFavorite;
  final DateTime createdAt;
  final String? accountNumber;
  final String? beneficiaryName;
  final String? beneficiaryPhone;

  Beneficiary({
    required this.id,
    required this.userId,
    required this.beneficiaryAccountId,
    required this.nickname,
    required this.isFavorite,
    required this.createdAt,
    this.accountNumber,
    this.beneficiaryName,
    this.beneficiaryPhone,
  });

  factory Beneficiary.fromJson(Map<String, dynamic> json) {
    return Beneficiary(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      beneficiaryAccountId: json['beneficiary_account_id'] ?? '',
      nickname: json['nickname'] ?? '',
      isFavorite: json['is_favorite'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      accountNumber: json['account_number'],
      beneficiaryName: json['beneficiary_name'],
      beneficiaryPhone: json['beneficiary_phone'],
    );
  }

  String get displayName => nickname.isNotEmpty
      ? nickname
      : beneficiaryName ?? accountNumber ?? 'Unknown';
}
