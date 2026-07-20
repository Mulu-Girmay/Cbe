// lib/screens/home/home_screen.dart
import 'package:cbe_mobile_app/screens/beneficiaries/bneficiary_screen.dart';
import 'package:cbe_mobile_app/screens/profile/profile_screen.dart';
import 'package:cbe_mobile_app/screens/transaction/send_money_screen.dart';
import 'package:cbe_mobile_app/screens/transaction/transaction_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/auth_provider.dart';
import 'package:cbe_mobile_app/providers/account_provider.dart';
import 'package:cbe_mobile_app/screens/home/dashboard_screen.dart';
import 'package:cbe_mobile_app/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const SendMoneyScreen(),
    const TransactionHistoryScreen(),
    const BeneficiaryScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    // Fetch account details on load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AccountProvider>().fetchAccountDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.send),
            label: 'Send',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Beneficiaries',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
