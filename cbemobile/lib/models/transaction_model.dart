import "package:flutter/material.dart";

class Transaction {
  final String id;
  final String transactionReference;
  final String? senderAccountId;
  final String? receiverAccountId;
  final double amount;
  final String transactionType;
  final String? description;
  final String status;
  final double fee;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? senderAccountNumber;
  final String? receiverAccountNumber;
  final String? senderName;
  final String? receiverName;
  final String? direction; // 'sent' or 'received'

  Transaction({
    required this.id,
    required this.transactionReference,
    this.senderAccountId,
    this.receiverAccountId,
    required this.amount,
    required this.transactionType,
    this.description,
    required this.status,
    this.fee = 0.0,
    required this.createdAt,
    this.completedAt,
    this.senderAccountNumber,
    this.receiverAccountNumber,
    this.senderName,
    this.receiverName,
    this.direction,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'] ?? '',
      transactionReference: json['transaction_reference'] ?? '',
      senderAccountId: json['sender_account_id'],
      receiverAccountId: json['receiver_account_id'],
      amount: double.parse(json['amount'].toString()),
      transactionType: json['transaction_type'] ?? '',
      description: json['description'],
      status: json['status'] ?? 'pending',
      fee: json['fee'] != null ? double.parse(json['fee'].toString()) : 0.0,
      createdAt: DateTime.parse(json['created_at']),
      completedAt: json['completed_at'] != null
          ? DateTime.parse(json['completed_at'])
          : null,
      senderAccountNumber: json['sender_account_number'],
      receiverAccountNumber: json['receiver_account_number'],
      senderName: json['sender_name'],
      receiverName: json['receiver_name'],
      direction: json['direction'],
    );
  }

  bool get isSent => direction == 'sent';
  bool get isReceived => direction == 'received';
  bool get isCompleted => status == 'completed';
  bool get isPending => status == 'pending';
  bool get isFailed => status == 'failed';

  String get formattedAmount {
    return '${isSent ? '-' : '+'}${amount.toStringAsFixed(2)} ETB';
  }

  Color get amountColor {
    if (isSent) return Colors.red;
    if (isReceived) return Colors.green;
    return Colors.grey;
  }
}
