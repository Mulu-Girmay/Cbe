// lib/services/storage_service.dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static final FlutterSecureStorage _secureStorage =
      const FlutterSecureStorage();

  // Secure storage (for tokens, sensitive data)
  static Future<void> saveSecure(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }

  static Future<String?> getSecure(String key) async {
    return await _secureStorage.read(key: key);
  }

  static Future<void> deleteSecure(String key) async {
    await _secureStorage.delete(key: key);
  }

  static Future<void> clearAllSecure() async {
    await _secureStorage.deleteAll();
  }

  // Shared preferences (for non-sensitive data)
  static Future<void> save(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is String) {
      await prefs.setString(key, value);
    } else if (value is int) {
      await prefs.setInt(key, value);
    } else if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is double) {
      await prefs.setDouble(key, value);
    }
  }

  static Future<String?> getString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(key);
  }
}
