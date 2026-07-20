// lib/screens/home/dashboard_screen.dart
import 'package:cbe_mobile_app/widget/balance_card.dart';
import 'package:cbe_mobile_app/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/account_provider.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final accountProvider = context.watch<AccountProvider>();

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('CBE Banking'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => accountProvider.fetchAccountDetails(),
        child: accountProvider.isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    BalanceCard(
                      balance: accountProvider.balance,
                      accountNumber: accountProvider.accountNumber,
                      accountType: accountProvider.accountType,
                    ),
                    const SizedBox(height: 24),
                    // Quick Actions
                    Row(
                      children: [
                        _buildQuickAction(
                          context,
                          'Send Money',
                          Icons.send,
                          () {
                            Navigator.pushNamed(context, '/send');
                          },
                        ),
                        _buildQuickAction(
                          context,
                          'History',
                          Icons.history,
                          () {
                            Navigator.pushNamed(context, '/history');
                          },
                        ),
                        _buildQuickAction(
                          context,
                          'Beneficiaries',
                          Icons.people,
                          () {
                            Navigator.pushNamed(context, '/beneficiaries');
                          },
                        ),
                        _buildQuickAction(
                          context,
                          'More',
                          Icons.more_horiz,
                          () {},
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // Recent Transactions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Recent Transactions',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/history');
                          },
                          child: const Text('View All'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (accountProvider.recentTransactions.isEmpty)
                      const Card(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Center(
                            child: Text('No transactions yet'),
                          ),
                        ),
                      )
                    else
                      ...accountProvider.recentTransactions
                          .take(5)
                          .map((transaction) => TransactionCard(
                                transaction: transaction,
                                onTap: () {
                                  // Navigate to transaction details
                                },
                              ))
                          .toList(),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildQuickAction(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primary,
                  size: 24,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
