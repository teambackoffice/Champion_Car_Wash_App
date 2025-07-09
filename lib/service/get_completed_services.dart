import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_completed_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetCompletedServices {
  final String Url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_completed_service_details';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<GetCompletedModal> getcompleted() async {
    try {
      final request = http.Request('GET', Uri.parse(Url));
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('Authentication required. Please login again.');
      }

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        try {
          final jsonData = json.decode(responseBody);

          // Check if the response structure is as expected
          if (jsonData is Map<String, dynamic>) {
            // The actual data is nested inside the 'message' object
            if (jsonData.containsKey('message') &&
                jsonData['message'] is Map<String, dynamic>) {
              return GetCompletedModal.fromJson(jsonData['message']);
            } else {
              // Fallback: try parsing directly if 'message' key doesn't exist
              return GetCompletedModal.fromJson(jsonData);
            }
          } else {
            throw Exception(
              'Invalid response format: Expected object, got ${jsonData.runtimeType}',
            );
          }
        } catch (e) {
          throw Exception('Failed to parse response: $e');
        }
      } else if (response.statusCode == 401) {
        throw Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 403) {
        throw Exception(
          'Access forbidden. You don\'t have permission to view this data.',
        );
      } else if (response.statusCode == 404) {
        throw Exception(
          'Service not found. The API endpoint may have changed.',
        );
      } else if (response.statusCode >= 500) {
        throw Exception('Server error. Please try again later.');
      } else {
        throw Exception(
          'Failed to load completed services. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow; // Re-throw custom exceptions
      } else {
        throw Exception(
          'Network error: Please check your internet connection. $e',
        );
      }
    }
  }
}
