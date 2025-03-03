import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'dart:developer';
import '../models/user_model.dart';

class AuthService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  // Keys for secure storage
  static const String _emailKey = 'user_email';
  static const String _passwordKey = 'user_password';

  // Save credentials in secure storage
  Future<void> saveCredentials(String email, String password) async {
    await _secureStorage.write(key: _emailKey, value: email);
    await _secureStorage.write(key: _passwordKey, value: password);
    log('Credentials saved to secure storage');
  }

  // Get credentials from secure storage
  Future<Map<String, String>> getCredentials() async {
    final email = await _secureStorage.read(key: _emailKey);
    final password = await _secureStorage.read(key: _passwordKey);

    return {'email': email ?? '', 'password': password ?? ''};
  }

  // Clear credentials on logout
  Future<void> clearCredentials() async {
    await _secureStorage.delete(key: _emailKey);
    await _secureStorage.delete(key: _passwordKey);
    log('Credentials cleared from secure storage');
  }

  // Save user data to Hive (including password now)
  Future<void> saveUserData(UserModel user) async {
    try {
      final userBox = await Hive.openBox<UserModel>(UserModel.boxName);

      // Use email as key to ensure we can retrieve the specific user later
      await userBox.put(user.email, user);
      log('User data saved to Hive');
    } catch (e) {
      log('Error saving user data: $e');
      rethrow;
    }
  }

  // Get user data from Hive
  Future<UserModel?> getUserData(String email) async {
    try {
      final userBox = await Hive.openBox<UserModel>(UserModel.boxName);
      return userBox.get(email);
    } catch (e) {
      log('Error getting user data: $e');
      return null;
    }
  }

  // Validate login credentials (check both secure storage and Hive)
  Future<bool> validateCredentials(String email, String password) async {
    // First check secure storage
    final savedCredentials = await getCredentials();
    log("SECURE STORED EMAIL: ${savedCredentials['email'].toString()}");
    log("SECURE STORED PASSWORD: ${savedCredentials['password'].toString()}");
    
    // If credentials match in secure storage, return true
    if (email == savedCredentials['email'] && password == savedCredentials['password']) {
      return true;
    }
    
    // If not found or don't match in secure storage, check Hive
    try {
      final userBox = await Hive.openBox<UserModel>(UserModel.boxName);
      final user = userBox.get(email);
      
      if (user != null && user.password == password) {
        // If valid, also restore credentials to secure storage for future use
        await saveCredentials(email, password);
        log("Credentials restored to secure storage from Hive data");
        return true;
      }
    } catch (e) {
      log('Error validating credentials from Hive: $e');
    }
    
    return false;
  }

  // Check user is logged in
  Future<bool> isUserLoggedIn() async {
    final credentials = await getCredentials();
    return credentials['email']!.isNotEmpty &&
        credentials['password']!.isNotEmpty;
  }
}