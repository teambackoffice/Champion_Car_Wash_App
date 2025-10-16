import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_prebooking_list.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetPrebookingListService {
  final String url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_pre_booking_list';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<GetPreBookingList> getPreBookingList() async {
    try {
      final request = http.Request('GET', Uri.parse(url));
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
        return GetPreBookingList.fromJson(jsonData);
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
