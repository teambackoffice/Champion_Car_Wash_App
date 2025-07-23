import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/car_wash_tech/new_carwash_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class GetNewCarWashService {
  final String Url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_carwash_open_services';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<CarWashNewModalClass> getNewCarWashService() async {
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
        return CarWashNewModalClass.fromJson(jsonData);
      } else {
        throw Exception(
          'Failed to load new car wash services. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching new car wash services: $e');
    }
  }
}
