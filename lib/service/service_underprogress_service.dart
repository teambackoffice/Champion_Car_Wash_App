import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ServiceUnderprogressService {
  final String _baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.update_service_to_inprogress';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<http.Response?> updateServiceToInProgress(
    String serviceId,
    String serviceType,
  ) async {
    try {
      // 🔐 Get SID from secure storage
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        return null;
      }

      final Uri url = Uri.parse(_baseUrl);
      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid', // ✅ Only include SID
      };
      final body = jsonEncode({
        'service_id': serviceId,
        'service_type': serviceType,
      });

      // 🔹 Debug logs

      final response = await http.post(url, headers: headers, body: body);

      // 🔹 Response logs

      return response;
    } catch (e) {
      return null;
    }
  }
}
