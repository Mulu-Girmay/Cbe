// lib/screens/auth/otp_verification_screen.dart
import 'package:cbe_mobile_app/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cbe_mobile_app/providers/auth_provider.dart';
import 'package:cbe_mobile_app/utils/colors.dart';
import 'package:cbe_mobile_app/utils/helpers.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _otpControllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  bool _isLoading = false;
  int _timerSeconds = 60;
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    _startTimer();
    // Focus on first field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodes[0].requestFocus();
    });
  }

  void _startTimer() {
    _timerSeconds = 60;
    _canResend = false;
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          _timerSeconds--;
          if (_timerSeconds > 0) {
            _startTimer();
          } else {
            _canResend = true;
          }
        });
      }
    });
  }

  String get _otpCode => _otpControllers.map((c) => c.text).join();

  Future<void> _verifyOTP() async {
    if (_otpCode.length < 6) {
      Helpers.showToast(context, 'Please enter complete 6-digit code',
          isError: true);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final authProvider = context.read<AuthProvider>();
      final success = await authProvider.verifyOTP(_otpCode);

      if (success && mounted) {
        // Navigate to home
        Navigator.pushReplacementNamed(context, '/home');
      } else if (mounted) {
        Helpers.showToast(
          context,
          authProvider.error ?? 'Verification failed',
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify OTP'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the 6-digit code sent to',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            Text(
              widget.phoneNumber,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 32),
            // OTP Input
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                return SizedBox(
                  width: 45,
                  child: TextField(
                    controller: _otpControllers[index],
                    focusNode: _focusNodes[index],
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: (value) {
                      if (value.isNotEmpty && index < 5) {
                        _focusNodes[index + 1].requestFocus();
                      } else if (value.isEmpty && index > 0) {
                        _focusNodes[index - 1].requestFocus();
                      }
                      if (_otpCode.length == 6) {
                        _verifyOTP();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Verify OTP',
              onPressed: _verifyOTP,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 16),
            Center(
              child: Column(
                children: [
                  if (_timerSeconds > 0)
                    Text(
                      'Resend code in ${_timerSeconds}s',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _canResend
                          ? () {
                              setState(() {
                                _canResend = false;
                                _startTimer();
                              });
                              // Resend OTP
                              final authProvider = context.read<AuthProvider>();
                              authProvider.signInWithPhone(widget.phoneNumber);
                            }
                          : null,
                      child: const Text('Resend OTP'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }
}
