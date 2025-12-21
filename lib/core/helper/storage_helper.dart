// import 'dart:convert';
// import 'package:beauty_salon/features/authentication/models/login_data_model.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// // import 'package:mavemate/features/authentication/models/login_data_model.dart';
//
// class StorageHelper {
//   static const String _loginDataKey = 'login_data';
//   static const String _profileCompletedKeyPrefix = 'profile_completed_';
//
//   /// Save LoginData as JSON string in SharedPreferences
//   static Future<void> saveLoginData(LoginData data) async {
//     final prefs = await SharedPreferences.getInstance();
//     String jsonString = jsonEncode(data.toMap());
//     await prefs.setString(_loginDataKey, jsonString);
//   }
//
//   /// Retrieve LoginData from SharedPreferences, or null if not found
//   static Future<LoginData?> getLoginData() async {
//     final prefs = await SharedPreferences.getInstance();
//     String? jsonString = prefs.getString(_loginDataKey);
//     if (jsonString == null) return null;
//
//     try {
//       Map<String, dynamic> jsonMap = jsonDecode(jsonString);
//       return LoginData.fromMap(jsonMap);
//     } catch (e) {
//       // Corrupted data, clear it
//       await clearLoginData();
//       return null;
//     }
//   }
//
//
//
//   /// Clear only login session (logout)
//   static Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_loginDataKey);
//   }
//
//   /// Completely clear all SharedPreferences data (optional)
//   /// Clear only login data
//   static Future<void> clearLoginData() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.remove(_loginDataKey);
//   }
//
//
//
// }
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:beauty_salon/features/authentication/models/login_data_model.dart';

class StorageHelper {
  static const String _loginDataKey = 'login_data';
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  /// Save LoginData object and its tokens
  static Future<void> saveLoginData(LoginData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toMap());
    await prefs.setString(_loginDataKey, jsonString);
    await saveAccessToken(data.accessToken);
    await saveRefreshToken(data.refreshToken);
  }

  /// Get LoginData object from storage
  static Future<LoginData?> getLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_loginDataKey);
    if (jsonString == null) return null;

    try {
      final jsonMap = jsonDecode(jsonString);
      return LoginData.fromMap(jsonMap);
    } catch (_) {
      await clearLoginData();
      return null;
    }
  }

  /// Save access token
  static Future<void> saveAccessToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_accessTokenKey, token);
  }

  /// Retrieve access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String? token) async {
    if (token == null) return;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_refreshTokenKey, token);
  }

  /// Retrieve refresh token
  static Future<String?> getRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_refreshTokenKey);
  }

  /// Clear login data and tokens (use for logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginDataKey);
  }

  /// Internal: Clear all stored credentials
  static Future<void> clearLoginData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_loginDataKey);
    await prefs.remove(_accessTokenKey);
    await prefs.remove(_refreshTokenKey);
  }
}
