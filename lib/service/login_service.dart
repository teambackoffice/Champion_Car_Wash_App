// services/auth_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class LoginService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.user_login';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<bool> login(String username, String password) async {
    final url = Uri.parse('$baseUrl?usr=$username&pwd=$password');
    log('Login request: $url');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        log('Login successful: $responseData');
        final fullName = responseData['full_name'];
        final message = responseData['message'];
        final apiKey = message['api_key'];
        final sid = message['sid'];
        final branch = message['branch'];
        final roles = message['roles'];

        // Store values in secure storage
        await _secureStorage.write(key: 'full_name', value: fullName);
        await _secureStorage.write(key: 'api_key', value: apiKey);
        await _secureStorage.write(key: 'sid', value: sid);
        await _secureStorage.write(key: "branch", value: branch);

        // Convert roles to JSON string and store
        await _secureStorage.write(key: 'roles', value: jsonEncode(roles));

        return message['success_key'] == 1;
      } else {
        log('Login failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      log('Login error: $e');
      return false;
    }
  }



  Future<String?> getFullName() async {
    return await _secureStorage.read(key: 'full_name');
  }

  Future<String?> getApiKey() async {
    return await _secureStorage.read(key: 'api_key');
  }

  // Optional: Method to clear storage on logout
  Future<void> logout() async {
    await _secureStorage.deleteAll();
  }
}
