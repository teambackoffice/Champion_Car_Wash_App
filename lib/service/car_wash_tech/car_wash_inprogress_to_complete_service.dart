import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:champion_car_wash_app/config/api_constants.dart';

class CarWashInProgressToCompleteService {
  final _storage = const FlutterSecureStorage();
  final String _baseUrl =
      '${ApiConstants.baseUrl}/api/method/carwash.Api.auth.submit_carwash_details';

  /// Submit Car wash details
  Future<Map<String, dynamic>?> submitCarWashDetails({
    required String serviceId,
    required int price,
    required int carWashTotal,
    required String inspectionType,
    required List<Map<String, dynamic>> answers,
  }) async {
    try {
      // Get stored sid
      String? sid = await _storage.read(key: 'sid');
      debugPrint('Stored SID: $sid');

      if (sid == null) {
        throw Exception('Session ID (sid) not found in storage');
      }

      var headers = {'Content-Type': 'application/json', 'Cookie': 'sid=$sid'};
      debugPrint('Request headers: $headers');

      var body = json.encode({
        'service_id': serviceId,
        'price': price,
        'carwash_total': carWashTotal,
        'inspection_type': inspectionType,
        'answers': answers,
      });
      debugPrint('Request body: $body');

      var request = http.Request('POST', Uri.parse(_baseUrl));
      request.body = body;
      request.headers.addAll(headers);

      debugPrint('Sending request to $_baseUrl ...');

      http.StreamedResponse response = await request.send();
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response headers: ${response.headers}');
      debugPrint('Request info: ${response.request}');

      final respStr = await response.stream.bytesToString();
      debugPrint('Response body: $respStr');

      if (response.statusCode == 200) {
        return json.decode(respStr);
      } else {
        throw Exception('Failed: ${response.reasonPhrase}');
      }
    } catch (e) {
      debugPrint('Error submitting car wash details: $e');
      throw Exception('Error submitting car wash details: $e');
    }
  }
}
