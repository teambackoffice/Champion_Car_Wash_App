import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/create_service_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CreateService {
  static const String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.create_service_by_supervisor';

  static const _storage = FlutterSecureStorage();

  Future<Map<String, dynamic>> createServiceWithCustomerVehicle(
    CreateServiceModal serviceModel,
  ) async {
    developer.log('API Base URL: $baseUrl', name: 'CreateService');
    try {
      // Read sid from secure storage
      String? sid = await _storage.read(key: 'sid');
      developer.log('SID from storage: $sid', name: 'CreateService');

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      // Add form fields
      final formData = serviceModel.toFormData();
      request.fields.addAll(formData);
      developer.log('Request Fields: $formData', name: 'CreateService');

      // Add video file if provided
      if (serviceModel.videoPath != null &&
          serviceModel.videoPath!.isNotEmpty) {
        if (await File(serviceModel.videoPath!).exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('video', serviceModel.videoPath!),
          );
          developer.log('Video file attached: ${serviceModel.videoPath}', name: 'CreateService');
        } else {
          developer.log('Video file does not exist at path: ${serviceModel.videoPath}', name: 'CreateService', level: 900); // Warning level
        }
      }

      // Add headers
      if (sid != null && sid.isNotEmpty) {
        request.headers['Cookie'] = 'sid=$sid';
        developer.log('Header Cookie set: sid=$sid', name: 'CreateService');
      }

      // Send request
      http.StreamedResponse response = await request.send();

      // Parse response
      String responseBody = await response.stream.bytesToString();
      developer.log('Response Status Code: ${response.statusCode}', name: 'CreateService');
      developer.log('Response Body: $responseBody', name: 'CreateService');

      final decodedBody = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        // Check for success message in response body
        if (decodedBody is Map<String, dynamic> &&
            decodedBody['message'] != null &&
            decodedBody['message']['success'] == true) {
          developer.log('Service created successfully', name: 'CreateService', level: 800); // Info level
          return {
            'success': true,
            'data': decodedBody,
            'message':
                decodedBody['message']['message'] ??
                'Service created successfully',
          };
        } else {
          // Handle cases where API returns 200 but operation failed
          developer.log('API returned 200 but operation failed: ${decodedBody['message']?['message']}', name: 'CreateService', level: 1000); // Severe level
          return {
            'success': false,
            'error':
                decodedBody['message']?['message'] ?? 'Unknown server error',
            'statusCode': response.statusCode,
            'message':
                decodedBody['message']?['message'] ??
                'Failed to create service',
          };
        }
      } else {
        // Handle non-200 status codes
        developer.log('API call failed with status code: ${response.statusCode}, reason: ${response.reasonPhrase}', name: 'CreateService', level: 1000); // Severe level
        return {
          'success': false,
          'error': response.reasonPhrase,
          'statusCode': response.statusCode,
          'message':
              decodedBody['message']?['message'] ?? 'Failed to create service',
        };
      }
    } catch (e, s) {
      developer.log('Exception caught during createServiceWithCustomerVehicle: $e', name: 'CreateService', error: e, stackTrace: s, level: 1000); // Severe level
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Network error occurred',
      };
    }
  }
}
