import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/add_prebooking_modal.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddPrebookingService {
  static Future<bool?> addPreBooking({
    required AddPreBookingList preBooking,
  }) async {

    final uri = Uri.parse(
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.create_pre_booking',
    );

    var branch = await const FlutterSecureStorage().read(key: 'branch');
    final sid = await const FlutterSecureStorage().read(key: 'sid');

    // Handle "Not Assigned" branch
    if (branch == null || branch == 'Not Assigned') {
      branch = 'Qatar';
    }

    // ✅ Fixed Cookie header syntax
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'sid=$sid', // ✅ Fixed: removed extra quotes and space
    };

    // ✅ Use the model's toJson() method instead of manual encoding
    final bookingData = preBooking.toJson();

    // Override the branch from secure storage
    bookingData['branch'] = branch;

    debugPrint('📤 REQUEST URL: $uri');
   debugPrint('📤 REQUEST BODY: ${jsonEncode(bookingData)}');

    final body = jsonEncode(bookingData); // ✅ Now this will work correctly


    try {
      final response = await http.post(
        uri,
        headers: headers, // ✅ Use the headers with SID
        body: body,
      );

     debugPrint('📥 RESPONSE STATUS: ${response.statusCode}');
     debugPrint('📥 RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 401) {
          final result = jsonDecode(response.body);
          final String errorMessage = result['detail'] ?? 'Unauthorized access';
          throw Exception(errorMessage);
        } else {
          final result = jsonDecode(response.body);
          String errorMessage = 'Request failed';

          // Handle nested message structure
          if (result['message'] != null) {
            if (result['message'] is Map) {
              errorMessage = result['message']['message'] ??
                           result['message']['error'] ??
                           'Request failed';
            } else if (result['message'] is String) {
              errorMessage = result['message'];
            }
          } else if (result['detail'] != null) {
            errorMessage = result['detail'];
          }

          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
