import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_newbooking_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetNewBookingListService {
  final String Url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_open_service_details';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<GetNewBookingListModal> getnewbookinglist() async {
    try {
      final request = http.Request('GET', Uri.parse(Url));
      final String? sid = await _secureStorage.read(key: 'sid');

      if (sid == null) {
        throw Exception('SID not found in secure storage');
      }

      request.headers.addAll({
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      });

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return GetNewBookingListModal.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load new-booking list. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching pre-booking list: $e');
    }
  }
}
