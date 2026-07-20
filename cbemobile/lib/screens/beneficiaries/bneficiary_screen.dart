// lib/screens/beneficiaries/beneficiary_screen.dart
import 'package:cbe_mobile_app/widget/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/account_provider.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';

class BeneficiaryScreen extends StatefulWidget {
  const BeneficiaryScreen({Key? key}) : super(key: key);

  @override
  State<BeneficiaryScreen> createState() => _BeneficiaryScreenState();
}

class _BeneficiaryScreenState extends State<BeneficiaryScreen> {
  List<dynamic> _beneficiaries = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadBeneficiaries();
  }

  Future<void> _loadBeneficiaries() async {
    setState(() => _isLoading = true);
    try {
      final accountProvider = context.read<AccountProvider>();
      // Add a method to fetch beneficiaries in AccountProvider
      // For now, we'll use sample data
      _beneficiaries = [
        {
          'id': '1',
          'nickname': 'Tigist Hailu',
          'accountNumber': '1000000002',
          'isFavorite': true,
          'beneficiaryName': 'Tigist Hailu',
          'beneficiaryPhone': '0923456789',
        },
        {
          'id': '2',
          'nickname': 'Samuel Tekle',
          'accountNumber': '1000000003',
          'isFavorite': false,
          'beneficiaryName': 'Samuel Tekle',
          'beneficiaryPhone': '0934567890',
        },
      ];
    } catch (e) {
      Helpers.showToast(context, 'Failed to load beneficiaries', isError: true);
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Beneficiaries'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddBeneficiaryDialog(context);
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _beneficiaries.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _beneficiaries.length,
                  itemBuilder: (context, index) {
                    final beneficiary = _beneficiaries[index];
                    return _buildBeneficiaryCard(beneficiary);
                  },
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          const Text(
            'No Beneficiaries',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your frequent contacts for quick transfers',
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddBeneficiaryDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Beneficiary'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBeneficiaryCard(dynamic beneficiary) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: () {
          _showBeneficiaryOptions(context, beneficiary);
        },
        leading: CircleAvatar(
          backgroundColor: Helpers.getColorFromString(
            beneficiary['nickname'] ?? beneficiary['beneficiaryName'] ?? '',
          ),
          child: Text(
            Helpers.getInitials(
              beneficiary['nickname'] ?? beneficiary['beneficiaryName'] ?? '?',
            ),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          beneficiary['nickname'] ??
              beneficiary['beneficiaryName'] ??
              'Unknown',
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Account: ${Helpers.maskAccountNumber(beneficiary['accountNumber'] ?? '')}',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            if (beneficiary['beneficiaryPhone'] != null)
              Text(
                beneficiary['beneficiaryPhone'],
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (beneficiary['isFavorite'] == true)
              const Icon(
                Icons.star,
                color: Colors.amber,
                size: 20,
              ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                _showBeneficiaryOptions(context, beneficiary);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showBeneficiaryOptions(BuildContext context, dynamic beneficiary) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Send Money'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(
                  context,
                  '/send',
                  arguments: {
                    'receiverAccount': beneficiary['accountNumber'],
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Beneficiary'),
              onTap: () {
                Navigator.pop(context);
                _showEditBeneficiaryDialog(context, beneficiary);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              title: Text(
                beneficiary['isFavorite'] == true
                    ? 'Remove from Favorites'
                    : 'Add to Favorites',
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  beneficiary['isFavorite'] =
                      !(beneficiary['isFavorite'] ?? false);
                });
                Helpers.showToast(
                  context,
                  beneficiary['isFavorite'] == true
                      ? 'Added to favorites'
                      : 'Removed from favorites',
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              title: const Text(
                'Delete Beneficiary',
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context, beneficiary);
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  void _showAddBeneficiaryDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final accountController = TextEditingController();
    final nicknameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Beneficiary'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                label: 'Account Number',
                hint: 'Enter 10-digit account number',
                controller: accountController,
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
              const SizedBox(height: 12),
              CustomTextField(
                label: 'Nickname (Optional)',
                hint: 'e.g., Mom, John, Rent',
                controller: nicknameController,
                prefixIcon: const Icon(Icons.person),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                setState(() {
                  _beneficiaries.add({
                    'id': DateTime.now().toString(),
                    'accountNumber': accountController.text,
                    'nickname': nicknameController.text.isNotEmpty
                        ? nicknameController.text
                        : 'Beneficiary ${_beneficiaries.length + 1}',
                    'isFavorite': false,
                    'beneficiaryName': 'New Beneficiary',
                  });
                });
                Helpers.showToast(context, 'Beneficiary added successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditBeneficiaryDialog(BuildContext context, dynamic beneficiary) {
    final formKey = GlobalKey<FormState>();
    final nicknameController = TextEditingController(
      text: beneficiary['nickname'] ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Beneficiary'),
        content: Form(
          key: formKey,
          child: CustomTextField(
            label: 'Nickname',
            hint: 'Enter new nickname',
            controller: nicknameController,
            prefixIcon: const Icon(Icons.person),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a nickname';
              }
              return null;
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                Navigator.pop(context);
                setState(() {
                  beneficiary['nickname'] = nicknameController.text;
                });
                Helpers.showToast(context, 'Beneficiary updated successfully');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, dynamic beneficiary) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Beneficiary'),
        content: Text(
          'Are you sure you want to delete "${beneficiary['nickname'] ?? beneficiary['beneficiaryName']}"?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _beneficiaries.remove(beneficiary);
              });
              Helpers.showToast(context, 'Beneficiary deleted');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
