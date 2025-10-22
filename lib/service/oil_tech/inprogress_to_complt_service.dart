import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class OilInprogressStatusService {
  final String _baseUrl =
      '${ApiConstants.baseUrl}/api/method/carwash.Api.auth.submit_oil_change_details';

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Submit oil change details
  Future<Map<String, dynamic>?> submitOilChangeDetails({
    required String serviceId,
    required int quantity,
    required int litres,
    required double price,
    required String subOilType,
    required double oilTotal,
    required List<Map<String, dynamic>> extraWork,
    required double extraWorksTotal,
    required String inspectionType,
    required List<Map<String, String>> answers,
  }) async {
    try {
      // 🔑 Get sid from secure storage
      String? sid = await _storage.read(key: 'sid');
      String? fullName = await _storage.read(key: 'full_name');
      String? userId = await _storage.read(key: 'user_id');

      if (sid == null) {
        throw Exception('Session ID (sid) not found in storage');
      }

      var headers = {
        'Content-Type': 'application/json',
        'Cookie':
            'full_name=${fullName ?? ""}; sid=$sid; system_user=yes; user_id=${userId ?? ""}; user_image=',
      };

      var body = {
        'service_id': serviceId,
        'quantity': quantity,
        'litres': litres,
        'price': price,
        'sub_oil_type': subOilType,
        'oil_total': oilTotal,
        'extra_work': extraWork,
        'extra_works_total': extraWorksTotal,
        'inspection_type': inspectionType,
        'answers': answers,
      };

      var request = http.Request('POST', Uri.parse(_baseUrl));
      request.headers.addAll(headers);
      request.body = json.encode(body);

      // 📝 Print Request Details
      print('========= API REQUEST =========');
      print('URL: $_baseUrl');
      print('Headers: $headers');
      print('Body: ${json.encode(body)}');
      print('==============================');

      http.StreamedResponse response = await request.send();

      String resBody = await response.stream.bytesToString();

      // 📝 Print Response Details
      print('========= API RESPONSE =========');
      print('Status Code: ${response.statusCode}');
      print('Reason: ${response.reasonPhrase}');
      print('Response Body: $resBody');
      print('===============================');

      if (response.statusCode == 200) {
        return json.decode(resBody);
      } else {
        // Parse error response
        try {
          final errorData = json.decode(resBody);
          String errorMessage = 'Server error: ${response.statusCode}';
          
          if (errorData is Map) {
            if (errorData.containsKey('exception')) {
              // Extract the actual error message from the exception
              final exception = errorData['exception'].toString();
              if (exception.contains('ValidationError:')) {
                errorMessage = exception.split('ValidationError:')[1].trim();
              } else {
                errorMessage = exception;
              }
            } else if (errorData.containsKey('message')) {
              errorMessage = errorData['message'].toString();
            }
          }
          
          print('❌ [API_ERROR] Parsed error: $errorMessage');
          
          // Return error in a structured format
          return {
            'success': false,
            'error': errorMessage,
            'status_code': response.statusCode,
          };
        } catch (parseError) {
          print('❌ [API_ERROR] Failed to parse error response: $parseError');
          return {
            'success': false,
            'error': 'Server error: ${response.statusCode} - ${response.reasonPhrase}',
            'status_code': response.statusCode,
          };
        }
      }
    } catch (e) {
      print('⚠️ Exception: $e');
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
