import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/car_wash_tech/new_carwash_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetNewCarWashService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_child_open_service_details';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<InnerMessage> getNewCarWashService({
    required String serviceType,
  }) async {
    try {
      // Add service_type as a query parameter
      final uri = Uri.parse('$baseUrl?service_type=$serviceType');

      final request = http.Request('GET', uri);
      final String? sid = await _secureStorage.read(key: 'sid');
      if (sid == null) {
        throw Exception('SID not found in secure storage');
      }

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final decoded = jsonDecode(responseBody) as Map<String, dynamic>;

        // Go down to message.message
        final innerJson = decoded['message']['message'] as Map<String, dynamic>;

        return InnerMessage.fromJson(innerJson);
      } else {
        throw Exception(
          'Failed to load new car wash services. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching new car wash services: $e');
    }
  }
}
