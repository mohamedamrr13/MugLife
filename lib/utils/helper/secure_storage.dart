import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppSecureStorage {
  static const _storage = FlutterSecureStorage(
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );

  /// Get string value from secure storage
  static Future<String?> getString(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Error reading secure storage: $e');
      return null;
    }
  }

  static Future<String?> getInt(String key) async {
    try {
      return await _storage.read(key: key);
    } catch (e) {
      print('Error reading secure storage: $e');
      return null;
    }
  }

  /// Get boolean value from secure storage
  static Future<bool?> getBool(String key) async {
    try {
      final value = await _storage.read(key: key);
      if (value == null) return null;
      return value.toLowerCase() == 'true';
    } catch (e) {
      print('Error reading secure storage: $e');
      return null;
    }
  }

  /// Set string value in secure storage
  static Future<void> setString(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
      rethrow;
    }
  }

  static Future<void> setInt(String key, String value) async {
    try {
      await _storage.write(key: key, value: value);
    } catch (e) {
      print('Error writing to secure storage: $e');
      rethrow;
    }
  }

  /// Set boolean value in secure storage
  static Future<void> setBool(String key, bool value) async {
    try {
      await _storage.write(key: key, value: value.toString());
    } catch (e) {
      print('Error writing to secure storage: $e');
      rethrow;
    }
  }

  /// Remove value from secure storage
  static Future<void> removeValue(String key) async {
    try {
      await _storage.delete(key: key);
    } catch (e) {
      print('Error removing from secure storage: $e');
      rethrow;
    }
  }

  /// Clear all values from secure storage
  static Future<void> clearAll() async {
    try {
      await _storage.deleteAll();
    } catch (e) {
      print('Error clearing secure storage: $e');
      rethrow;
    }
  }

  /// Check if key exists in secure storage
  static Future<bool> containsKey(String key) async {
    try {
      return await _storage.containsKey(key: key);
    } catch (e) {
      print('Error checking key in secure storage: $e');
      return false;
    }
  }

  /// Get all values from secure storage
  static Future<Map<String, String>> getAll() async {
    try {
      return await _storage.readAll();
    } catch (e) {
      print('Error reading all secure storage values: $e');
      return {};
    }
  }
}

class PaymobSecureStorage {
  static Future<void> setApiKey() async {
    final apiKey = dotenv.env['API_KEY'];
    // Store securely on device
    if (apiKey != null) {
      await AppSecureStorage.setString('api_key', apiKey);
      debugPrint('✅ API key stored securely');
    } else {
      debugPrint('⚠️ No API key found in .env');
    }
  }

  static Future<void> setTransactionId() async {
    final transactionId = dotenv.env['transaction_id'];

    if (transactionId != null) {
      await AppSecureStorage.setString('transaction_id', transactionId);
      debugPrint('✅ Id stored securely');
    } else {
      debugPrint('⚠️ No Id key found in .env');
    }
  }

  static Future<void> setMobileWalletId() async {
    final walletId = dotenv.env['wallet_id'];

    if (walletId != null) {
      await AppSecureStorage.setString('wallet_id', walletId);
      debugPrint('✅ Id stored securely');
    } else {
      debugPrint('⚠️ No Id key found in .env');
    }
  }
}
