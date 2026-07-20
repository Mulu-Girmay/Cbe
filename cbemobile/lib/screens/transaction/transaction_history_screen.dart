// lib/screens/transactions/transaction_history_screen.dart
import 'package:cbe_mobile_app/widget/transaction_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/account_provider.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({Key? key}) : super(key: key);

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _transactions = [];
  bool _isLoading = false;
  bool _hasMore = true;
  int _page = 0;
  final int _limit = 20;

  @override
  void initState() {
    super.initState();
    _loadTransactions();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200 &&
        !_isLoading &&
        _hasMore) {
      _loadTransactions();
    }
  }

  Future<void> _loadTransactions() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final accountProvider = context.read<AccountProvider>();
      final newTransactions = await accountProvider.fetchTransactionHistory(
        limit: _limit,
        offset: _page * _limit,
      );

      setState(() {
        if (newTransactions.isNotEmpty) {
          _transactions.addAll(newTransactions);
          _page++;
        } else {
          _hasMore = false;
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      Helpers.showToast(context, 'Failed to load transactions', isError: true);
    }
  }

  Future<void> _refreshTransactions() async {
    setState(() {
      _transactions = [];
      _page = 0;
      _hasMore = true;
    });
    await _loadTransactions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Transaction History'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshTransactions,
        child: _transactions.isEmpty && !_isLoading
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.history,
                      size: 64,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'No transactions yet',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Your transactions will appear here',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _transactions.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _transactions.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  final transaction = _transactions[index];
                  return TransactionCard(
                    transaction: transaction,
                    onTap: () {
                      _showTransactionDetails(context, transaction);
                    },
                  );
                },
              ),
      ),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Transactions'),
        content: TextField(
          decoration: InputDecoration(
            hintText: 'Search by description, amount...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onSubmitted: (value) {
            // Implement search logic
            Navigator.pop(context);
            Helpers.showToast(context, 'Search: $value');
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    String? selectedType = 'All';
    String? selectedStatus = 'All';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: const Text('Filter Transactions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Transaction Type',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'sent', child: Text('Sent')),
                    DropdownMenuItem(
                        value: 'received', child: Text('Received')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedType = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedStatus,
                  decoration: const InputDecoration(
                    labelText: 'Status',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(
                        value: 'completed', child: Text('Completed')),
                    DropdownMenuItem(value: 'pending', child: Text('Pending')),
                    DropdownMenuItem(value: 'failed', child: Text('Failed')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      selectedStatus = value;
                    });
                  },
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  // Apply filters
                  Helpers.showToast(context, 'Filters applied');
                },
                child: const Text('Apply'),
              ),
            ],
          );
        },
      ),
    );
  }

  void _showTransactionDetails(BuildContext context, dynamic transaction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: transaction.isSent
                          ? Colors.red[100]
                          : Colors.green[100],
                      radius: 30,
                      child: Icon(
                        transaction.isSent
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 30,
                        color: transaction.isSent ? Colors.red : Colors.green,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.isSent
                                ? 'Sent Money'
                                : 'Received Money',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            transaction.description ?? 'No description',
                            style: const TextStyle(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _buildDetailRow(
                  'Amount',
                  Helpers.formatCurrency(transaction.amount),
                  textColor: transaction.isSent ? Colors.red : Colors.green,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Status',
                  transaction.status.toUpperCase(),
                  textColor: transaction.status == 'completed'
                      ? Colors.green
                      : transaction.status == 'pending'
                          ? Colors.orange
                          : Colors.red,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Reference',
                  transaction.transactionReference,
                ),
                _buildDivider(),
                _buildDetailRow(
                  'Date',
                  Helpers.formatDateTime(transaction.createdAt),
                ),
                _buildDivider(),
                if (transaction.senderName != null)
                  _buildDetailRow(
                    'From',
                    transaction.senderName ?? 'Unknown',
                  ),
                if (transaction.receiverName != null)
                  _buildDetailRow(
                    'To',
                    transaction.receiverName ?? 'Unknown',
                  ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Close'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {Color? textColor}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: textColor ?? Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      color: AppColors.greyLight,
      thickness: 0.5,
    );
  }
}
