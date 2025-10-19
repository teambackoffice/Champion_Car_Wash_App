import 'dart:convert';
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
    print(baseUrl);
    try {
      // Read sid from secure storage
      String? sid = await _storage.read(key: 'sid');
      print('SID from storage: $sid');

      var request = http.MultipartRequest('POST', Uri.parse(baseUrl));

      // Add form fields
      final formData = serviceModel.toFormData();
      request.fields.addAll(formData);
      print('Request Fields: $formData');

      // Add video file if provided
      if (serviceModel.videoPath != null &&
          serviceModel.videoPath!.isNotEmpty) {
        if (await File(serviceModel.videoPath!).exists()) {
          request.files.add(
            await http.MultipartFile.fromPath('video', serviceModel.videoPath!),
          );
          print('Video file attached: ${serviceModel.videoPath}');
        } else {
          print('Video file does not exist at path: ${serviceModel.videoPath}');
        }
      }

      // Add headers
      if (sid != null && sid.isNotEmpty) {
        request.headers['Cookie'] = 'sid=$sid';
        print('Header Cookie set: sid=$sid');
      }

      // Send request
      http.StreamedResponse response = await request.send();

      // Parse response
      String responseBody = await response.stream.bytesToString();
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: $responseBody');

      final decodedBody = jsonDecode(responseBody);

      if (response.statusCode == 200) {
        // Check for success message in response body
        if (decodedBody is Map<String, dynamic> &&
            decodedBody['message'] != null &&
            decodedBody['message']['success'] == true) {
          return {
            'success': true,
            'data': decodedBody,
            'message': decodedBody['message']['message'] ??
                'Service created successfully',
          };
        } else {
          // Handle cases where API returns 200 but operation failed
          return {
            'success': false,
            'error':
                decodedBody['message']?['message'] ?? 'Unknown server error',
            'statusCode': response.statusCode,
            'message':
                decodedBody['message']?['message'] ?? 'Failed to create service',
          };
        }
      } else {
        // Handle non-200 status codes
        return {
          'success': false,
          'error': response.reasonPhrase,
          'statusCode': response.statusCode,
          'message': decodedBody['message']?['message'] ?? 'Failed to create service',
        };
      }
    } catch (e) {
      print('Exception caught: $e');
      return {
        'success': false,
        'error': e.toString(),
        'message': 'Network error occurred',
      };
    }
  }
}
