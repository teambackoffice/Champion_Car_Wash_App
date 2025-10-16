import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_carwash_modal.dart';
import 'package:http/http.dart' as http;

class GetCarwashService {
  static Future<GetCarwashList?> getCarwashList() async {
    final uri = Uri.parse(
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_wash_type',
    );

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final GetCarwashList result = getCarwashListFromJson(response.body);
        return result;
      } else if (response.statusCode == 401) {
        // You can optionally return an error message or handle unauthorized access
        final result = jsonDecode(response.body);
        return null;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
