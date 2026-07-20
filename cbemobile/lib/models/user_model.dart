// lib/models/user_model.dart
class User {
  // Not UserModel - keep it as User
  final String id;
  final String firebaseUid;
  final String fullName;
  final String? phoneNumber;
  final String? email;
  final String? profileImage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? accountId;
  final String? accountNumber;
  final double? balance;
  final String? accountType;

  User({
    required this.id,
    required this.firebaseUid,
    required this.fullName,
    this.phoneNumber,
    this.email,
    this.profileImage,
    required this.createdAt,
    required this.updatedAt,
    this.accountId,
    this.accountNumber,
    this.balance,
    this.accountType,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      firebaseUid: json['firebase_uid'] ?? '',
      fullName: json['full_name'] ?? '',
      phoneNumber: json['phone_number'],
      email: json['email'],
      profileImage: json['profile_image'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : DateTime.now(),
      accountId: json['account_id'],
      accountNumber: json['account_number'],
      balance: json['balance'] != null
          ? double.parse(json['balance'].toString())
          : null,
      accountType: json['account_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firebase_uid': firebaseUid,
      'full_name': fullName,
      'phone_number': phoneNumber,
      'email': email,
      'profile_image': profileImage,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'account_id': accountId,
      'account_number': accountNumber,
      'balance': balance,
      'account_type': accountType,
    };
  }
}
