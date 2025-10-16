import 'dart:convert';
import 'dart:developer' as developer;

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/service_counts_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

/// Service for fetching service and prebooking counts
/// Used on the home screen to display dashboard counts
class ServiceCountsService {
  final String _url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_service_and_prebooking_counts';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  /// Fetch service and prebooking counts from API
  /// Returns [ServiceCountsResponse] with all count details
  /// Throws [Exception] if API call fails
  Future<ServiceCountsResponse> getServiceCounts() async {
    developer.log(
      '=== ServiceCountsService: Starting API Request ===',
      name: 'ServiceCountsService',
    );

    try {
      final request = http.Request('GET', Uri.parse(_url));
      final String? sid = await _secureStorage.read(key: 'sid');

      developer.log(
        'Request URL: $_url',
        name: 'ServiceCountsService',
      );

      if (sid == null) {
        developer.log(
          'ERROR: SID not found in secure storage',
          name: 'ServiceCountsService',
          error: 'SID is null',
        );
        throw Exception('Session not found. Please login again.');
      }

      developer.log(
        'SID retrieved successfully: ${sid.substring(0, 10)}...',
        name: 'ServiceCountsService',
      );

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      developer.log(
        'Request Headers: ${request.headers}',
        name: 'ServiceCountsService',
      );

      // Send HTTP request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      developer.log(
        'Response Status Code: ${response.statusCode}',
        name: 'ServiceCountsService',
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        developer.log(
          'Response Body: ${response.body}',
          name: 'ServiceCountsService',
        );

        if (jsonData['message'] != null) {
          final countsResponse =
              ServiceCountsResponse.fromJson(jsonData['message']);

          developer.log(
            'Service Counts Retrieved Successfully:',
            name: 'ServiceCountsService',
          );
          developer.log(
            '  - Prebooking Count: ${countsResponse.counts.prebookingCount}',
            name: 'ServiceCountsService',
          );
          developer.log(
            '  - Open Service Count: ${countsResponse.counts.openServiceCount}',
            name: 'ServiceCountsService',
          );
          developer.log(
            '  - In Progress Count: ${countsResponse.counts.inprogressServiceCount}',
            name: 'ServiceCountsService',
          );
          developer.log(
            '  - Completed Count: ${countsResponse.counts.completedServiceCount}',
            name: 'ServiceCountsService',
          );

          return countsResponse;
        } else {
          developer.log(
            'ERROR: Invalid response format - missing message field',
            name: 'ServiceCountsService',
            error: 'Invalid response',
          );
          throw Exception('Invalid response format from server');
        }
      } else if (response.statusCode == 401) {
        developer.log(
          'ERROR: Unauthorized - Session expired',
          name: 'ServiceCountsService',
          error: 'Status: 401',
        );
        throw Exception('Session expired. Please login again.');
      } else if (response.statusCode == 403) {
        developer.log(
          'ERROR: Forbidden - Insufficient permissions',
          name: 'ServiceCountsService',
          error: 'Status: 403',
        );
        throw Exception('Access denied. Insufficient permissions.');
      } else if (response.statusCode == 404) {
        developer.log(
          'ERROR: Not Found - Invalid endpoint',
          name: 'ServiceCountsService',
          error: 'Status: 404',
        );
        throw Exception('Service endpoint not found.');
      } else if (response.statusCode >= 500) {
        developer.log(
          'ERROR: Server error',
          name: 'ServiceCountsService',
          error: 'Status: ${response.statusCode}',
        );
        throw Exception('Server error. Please try again later.');
      } else {
        developer.log(
          'ERROR: Unexpected status code: ${response.statusCode}',
          name: 'ServiceCountsService',
          error: 'Response: ${response.body}',
        );
        throw Exception(
          'Failed to fetch service counts: ${response.statusCode}',
        );
      }
    } catch (e) {
      developer.log(
        'ERROR: Exception occurred',
        name: 'ServiceCountsService',
        error: e.toString(),
      );

      // Re-throw if already our custom exception
      if (e is Exception) {
        rethrow;
      }

      // Wrap other errors
      throw Exception('Network error: ${e.toString()}');
    }
  }

  /// Refresh service counts
  /// Alias for [getServiceCounts] for consistency with other services
  Future<ServiceCountsResponse> refreshCounts() async {
    return await getServiceCounts();
  }
}
