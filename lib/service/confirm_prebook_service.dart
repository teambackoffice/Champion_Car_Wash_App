// services/pre_booking_service.dart

import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:http/http.dart' as http;

class ConfirmPrebookService {
  static const String _url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.prebooking_confirm';

  Future<String?> confirmPreBooking(String regNumber) async {
    var request = http.Request(
      'POST',
      Uri.parse('$_url?pre_book_id=$regNumber'),
    );
    print(request);

    request.body = json.encode({'pre_book_id': regNumber});

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        print(response.statusCode);
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
      print(e);
      return 'Exception: $e';
    }
  }
}
