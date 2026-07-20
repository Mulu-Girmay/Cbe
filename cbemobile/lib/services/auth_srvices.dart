// lib/services/auth_service.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:cbe_mobile_app/services/storage_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    final token = await StorageService.getSecure('firebase_token');
    return token != null && _auth.currentUser != null;
  }

  // Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Get ID Token
  Future<String?> getIdToken() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken();
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // Sign in with phone number
  Future<void> signInWithPhone(String phoneNumber) async {
    try {
      // Format phone number
      final formattedPhone =
          phoneNumber.startsWith('+') ? phoneNumber : '+251$phoneNumber';

      await _auth.verifyPhoneNumber(
        phoneNumber: formattedPhone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          throw Exception('Verification failed: ${e.message}');
        },
        codeSent: (String verificationId, int? resendToken) {
          // Store verification ID for OTP verification
          StorageService.saveSecure('verification_id', verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto retrieval timeout
        },
      );
    } catch (e) {
      throw Exception('Failed to send OTP: ${e.toString()}');
    }
  }

  // Verify OTP
  Future<UserCredential> verifyOTP(String smsCode) async {
    try {
      final verificationId = await StorageService.getSecure('verification_id');

      if (verificationId == null) {
        throw Exception('Verification ID not found');
      }

      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final result = await _auth.signInWithCredential(credential);

      // Store token
      final token = await result.user?.getIdToken();
      if (token != null) {
        await StorageService.saveSecure('firebase_token', token);
      }

      return result;
    } catch (e) {
      throw Exception('Failed to verify OTP: ${e.toString()}');
    }
  }

  // Sign in with email and password
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store token
      final token = await result.user?.getIdToken();
      if (token != null) {
        await StorageService.saveSecure('firebase_token', token);
      }

      return result;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  // Sign up with email and password
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store token
      final token = await result.user?.getIdToken();
      if (token != null) {
        await StorageService.saveSecure('firebase_token', token);
      }

      return result;
    } catch (e) {
      throw Exception('Registration failed: ${e.toString()}');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await StorageService.clearAllSecure();
  }

  // Delete account (for testing)
  Future<void> deleteAccount() async {
    final user = _auth.currentUser;
    if (user != null) {
      await user.delete();
    }
  }
}
