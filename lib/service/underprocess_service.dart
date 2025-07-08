import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UnderprocessService {
  final String url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_Inprogress_service_details';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<UnderprocessModal> getunderprocessing() async {
    try {
      // Get sid from secure storage
      final sid = await _secureStorage.read(key: 'sid');

      if (sid == null || sid.isEmpty) {
        throw Exception('Session ID (sid) not found in secure storage.');
      }

      // Create request with headers
      final request = http.Request('GET', Uri.parse(url));
      request.headers['Cookie'] = 'sid=$sid';

      // Send request and get response
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return UnderprocessModal.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load new-booking list. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching in-progress booking list: $e');
    }
  }
}
