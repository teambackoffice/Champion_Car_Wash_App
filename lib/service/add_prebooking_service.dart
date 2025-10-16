import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/add_prebooking_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AddPrebookingService {
  static Future<bool?> addPreBooking({
    required AddPreBookingList preBooking,
  }) async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.create_pre_booking',
    );

    final branch = await const FlutterSecureStorage().read(key: 'branch');
    final sid = await const FlutterSecureStorage().read(key: 'sid');

    // ✅ Fixed Cookie header syntax
    var headers = {
      'Content-Type': 'application/json',
      'Cookie': 'sid=$sid', // ✅ Fixed: removed extra quotes and space
    };

    // ✅ Use the model's toJson() method instead of manual encoding
    final bookingData = preBooking.toJson();

    // Override the branch from secure storage
    bookingData['branch'] = branch;

    final body = jsonEncode(bookingData); // ✅ Now this will work correctly

    try {
      final response = await http.post(
        uri,
        headers: headers, // ✅ Use the headers with SID
        body: body,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        if (response.statusCode == 401) {
          final result = jsonDecode(response.body);
          final String errorMessage = result['detail'] ?? 'Unauthorized access';
          throw Exception(errorMessage);
        } else {
          final result = jsonDecode(response.body);
          final String errorMessage =
              result['message'] ?? result['detail'] ?? 'Request failed';
          throw Exception(errorMessage);
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}
