import 'dart:convert';
import 'dart:developer' as developer;

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_allbooking_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetAllbookingServ {
  final String url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_all_service_bookings';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<GetAllbookingModal> getallbooking() async {
    developer.log(
      '=== GetAllbookingService: Starting API Request ===',
      name: 'GetAllbookingService',
    );

    try {
      final request = http.Request('GET', Uri.parse(url));
      final String? sid = await _secureStorage.read(key: 'sid');

      developer.log(
        'Request URL: $url',
        name: 'GetAllbookingService',
      );

      if (sid == null) {
        developer.log(
          'ERROR: SID not found in secure storage',
          name: 'GetAllbookingService',
          error: 'SID is null',
        );
        throw Exception('SID not found in secure storage');
      }

      developer.log(
        'SID retrieved successfully: ${sid.substring(0, 10)}...',
        name: 'GetAllbookingService',
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      developer.log(
        'Request Headers: ${request.headers}',
        name: 'GetAllbookingService',
      );

      developer.log(
        'Sending HTTP GET request...',
        name: 'GetAllbookingService',
      );

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      developer.log(
        'Response Status Code: ${response.statusCode}',
        name: 'GetAllbookingService',
      );

      developer.log(
        'Response Body: $responseBody',
        name: 'GetAllbookingService',
      );

      if (response.statusCode == 200) {
        developer.log(
          'Parsing JSON response...',
          name: 'GetAllbookingService',
        );

        final jsonData = json.decode(responseBody);

        if (jsonData == null) {
          developer.log(
            'ERROR: JSON data is null',
            name: 'GetAllbookingService',
            error: 'Null JSON response',
          );
          throw Exception('Received null JSON response');
        }

        developer.log(
          'JSON parsed successfully. Creating GetAllbookingModal...',
          name: 'GetAllbookingService',
        );

        final modal = GetAllbookingModal.fromJson(jsonData);

        developer.log(
          'SUCCESS: All-booking list fetched. Count: ${modal.count}',
          name: 'GetAllbookingService',
        );

        return modal;
      } else {
        developer.log(
          'ERROR: Failed to load all-booking list',
          name: 'GetAllbookingService',
          error: 'Status Code: ${response.statusCode}, Body: $responseBody',
        );

        throw Exception(
          'Failed to load all-booking list. Status Code: ${response.statusCode}',
        );
      }
    } catch (e, stackTrace) {
      developer.log(
        'ERROR: Exception in getallbooking',
        name: 'GetAllbookingService',
        error: e,
        stackTrace: stackTrace,
      );

      throw Exception('Error fetching all-booking list: $e');
    }
  }
}
