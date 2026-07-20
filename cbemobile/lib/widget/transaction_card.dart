// lib/widgets/transaction_card.dart
import 'package:flutter/material.dart';
import 'package:cbe_mobile_app/models/transaction_model.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';

class TransactionCard extends StatelessWidget {
  final Transaction transaction;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.transaction,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor:
              transaction.isSent ? Colors.red.shade100 : Colors.green.shade100,
          child: Icon(
            transaction.isSent ? Icons.arrow_upward : Icons.arrow_downward,
            color: transaction.isSent ? Colors.red : Colors.green,
          ),
        ),
        title: Text(
          transaction.isSent
              ? transaction.receiverName ?? 'Transfer'
              : transaction.senderName ?? 'Received',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              transaction.description ?? 'No description',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              Helpers.formatDate(transaction.createdAt),
              style: const TextStyle(
                fontSize: 11,
                color: AppColors.textLight,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Helpers.formatCurrency(transaction.amount),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: transaction.isSent ? Colors.red : Colors.green,
                fontSize: 16,
              ),
            ),
            if (transaction.status == 'pending')
              const Text(
                'Pending',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.warning,
                ),
              ),
            if (transaction.status == 'failed')
              const Text(
                'Failed',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
