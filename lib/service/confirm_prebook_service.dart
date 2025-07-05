// services/pre_booking_service.dart

import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:http/http.dart' as http;

class ConfirmPrebookService {
  static const String _url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.prebooking_confirm';

  Future<String?> confirmPreBooking(String regNumber) async {
    var headers = {
      'Content-Type': 'application/json',
      'Cookie':
          'full_name=najath; sid=1dff10109e3c4dc2775e36a72941aefcf58fc564275ee21d17341b75; system_user=no; user_id=najath%40gmail.com; user_image=',
    };

    var request = http.Request(
      'POST',
      Uri.parse('$_url?pre_book_id=$regNumber'),
    );

    request.body = json.encode({"pre_book_id": regNumber});

    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final jsonResponse = json.decode(body);

        // Handle the response properly
        if (jsonResponse is Map<String, dynamic>) {
          return jsonResponse['message']?.toString() ?? 'Success';
        } else {
          return jsonResponse.toString();
        }
      } else {
        return 'Error: ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Exception: $e';
    }
  }
}
