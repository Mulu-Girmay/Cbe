// lib/screens/transactions/send_money_screen.dart
import 'package:cbe_mobile_app/widget/custom_button.dart';
import 'package:cbe_mobile_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/transaction_provider.dart';
import 'package:cbe_mobile_app/providers/account_provider.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';
import 'package:cbe_mobile_app/models/transaction_model.dart';

class SendMoneyScreen extends StatefulWidget {
  final String? receiverAccount;
  final double? amount;

  const SendMoneyScreen({
    Key? key,
    this.receiverAccount,
    this.amount,
  }) : super(key: key);

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _accountController = TextEditingController();
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool _showConfirmation = false;
  Transaction? _transaction;

  @override
  void initState() {
    super.initState();
    if (widget.receiverAccount != null) {
      _accountController.text = widget.receiverAccount!;
    }
    if (widget.amount != null) {
      _amountController.text = widget.amount!.toString();
    }
  }

  Future<void> _sendMoney() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final transactionProvider = context.read<TransactionProvider>();
      final success = await transactionProvider.sendMoney(
        receiverAccount: _accountController.text.trim(),
        amount: double.parse(_amountController.text),
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );

      if (success && mounted) {
        _transaction = transactionProvider.lastTransaction;
        setState(() {
          _showConfirmation = true;
        });
        // Refresh account balance
        await context.read<AccountProvider>().fetchAccountDetails();
      } else if (mounted) {
        Helpers.showToast(
          context,
          transactionProvider.error ?? 'Transaction failed',
          isError: true,
        );
      }
    } catch (e) {
      Helpers.showToast(context, e.toString(), isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_showConfirmation && _transaction != null) {
      return _buildConfirmationScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Money'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Receiver Account Number',
                hint: 'Enter 10-digit account number',
                controller: _accountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.account_balance),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter account number';
                  }
                  if (value.length != 10) {
                    return 'Account number must be 10 digits';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Amount (ETB)',
                hint: 'Enter amount to send',
                controller: _amountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.money),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter amount';
                  }
                  final amount = double.tryParse(value);
                  if (amount == null || amount <= 0) {
                    return 'Please enter a valid amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Description (Optional)',
                hint: 'What is this for?',
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                prefixIcon: const Icon(Icons.note),
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: Colors.blue[700]),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Transaction fee: 1% (min 5 ETB, max 50 ETB)',
                        style: TextStyle(
                          color: Colors.blue[700],
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              CustomButton(
                text: 'Send Money',
                onPressed: _sendMoney,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Successful'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 80,
            ),
            const SizedBox(height: 16),
            const Text(
              'Money Sent Successfully!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${Helpers.formatCurrency(_transaction!.amount)} sent to ${_transaction!.receiverName ?? 'Receiver'}',
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildConfirmationRow(
                    'Transaction Reference',
                    _transaction!.transactionReference,
                  ),
                  _buildDivider(),
                  _buildConfirmationRow(
                    'Date',
                    Helpers.formatDateTime(_transaction!.createdAt),
                  ),
                  _buildDivider(),
                  _buildConfirmationRow(
                    'Amount',
                    Helpers.formatCurrency(_transaction!.amount),
                  ),
                  _buildDivider(),
                  _buildConfirmationRow(
                    'Fee',
                    Helpers.formatCurrency(_transaction!.fee),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: 'Done',
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/home');
              },
            ),
            const SizedBox(height: 8),
            CustomButton(
              text: 'Send Another',
              onPressed: () {
                setState(() {
                  _showConfirmation = false;
                  _transaction = null;
                  _accountController.clear();
                  _amountController.clear();
                  _descriptionController.clear();
                });
              },
              isOutlined: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmationRow(String label, String value) {
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
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
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
