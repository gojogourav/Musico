import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static final String _baseUrl = Platform.isAndroid
      ? "http://10.0.2.2:5000/auth"
      : "http://localhost:5000/auth";
  static const _header = {"Content-Type": "application/json"};
  static const _storage = FlutterSecureStorage();

  static Future<void> _storeTokens(Map<String, dynamic> tokens) async {
    final accessToken = tokens['accessToken'];
    final refreshToken = tokens['refreshToken'];
    if (accessToken != null && refreshToken != null) {
      await _storage.write(key: 'access_token', value: accessToken);
      await _storage.write(key: 'refresh_token', value: refreshToken);
      print('Tokens saved successfully!');
    }
  }

  static Future<Map<String, dynamic>> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/login"),
        headers: _header,
        body: jsonEncode({"email": email, "password": password}),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        await _storeTokens(
          responseData,
        ); // CRITICAL FIX: Correctly call helper.
        return {
          "ok": true,
          "data": responseData,
          "message": responseData['message'],
        };
      } else {
        return {
          "ok": false,
          "message": responseData['message'] ?? "Login Failed",
        };
      }
    } on SocketException {
      return {"ok": false, " message": "Could not connect to the server."};
    } catch (e) {
      print(e);
      return {"ok": false, "message": "Login Failed"};
    }
  }

  static Future<Map<String, dynamic>> register({
    required String email,
    required String password,
    required String username,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/register"),
        headers: _header,
        body: jsonEncode({
          "email": email,
          "password": password,
          "username": username,
          "name": name,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode >= 200) {
        await _storeTokens(responseData['tokens']);
        // return ApiResponse.fromJson(responseData);
        return {"ok": true, "message": responseData["message"]};
      } else {
        print('Registration failed with status: ${response.statusCode}');
        return {
          "ok": false,
          "message": responseData['message'] ?? "Registration Failed",
        };
      }
    } catch (e) {
      print("HTTP register request failed: $e");
      return {"ok": false, "message": "Could not connect to the server."};
    }
  }

  static Future<Map<String, dynamic>?> refreshTokens() async {
    try {
      final refreshToken = await _storage.read(key: 'refresh_token');
      if (refreshToken == null) {
        print('No refresh token found for refresh action.');
        return null;
      }

      final response = await http.post(
        Uri.parse("$_baseUrl/refresh"),
        headers: _header,
        body: jsonEncode({"token": refreshToken}),
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        final newTokens = responseData['tokens'];
        await _storeTokens(newTokens);
        // Return the new tokens as a Map<String, String>
        return {
          'accessToken': newTokens['accessToken'],
          'refreshToken': newTokens['refreshToken'],
        };
      } else {
        print(
          'Failed to refresh tokens. Status: ${response.statusCode}. Logging out.',
        );
        // If refresh fails (e.g., token is also expired), log the user out.
        await logout();
        return null;
      }
    } catch (e) {
      print("Refresh token request failed: $e");
      return null;
    }
  }

  static Future<void> logout() async {
    await _storage.delete(key: 'access_token');
    await _storage.delete(key: 'refresh_token');
    print("User tokens deleted.");
  }

  static Future<String?> getAccessToken() async {
    return await _storage.read(key: 'access_token');
  }
}
