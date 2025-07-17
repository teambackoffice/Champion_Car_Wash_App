import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_oilbrand_modal.dart';
import 'package:http/http.dart' as http;

class GetOilbrandService {
  static Future<GetOilBrandList?> getOilBrandList() async {
    final uri = Uri.parse(
      "${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_all_oil_brand",
    );
    print(uri);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        print(response.body);
        final GetOilBrandList result = getOilBrandListFromJson(response.body);
        return result;
      } else if (response.statusCode == 401) {
        // You can optionally return an error message or handle unauthorized access
        final result = jsonDecode(response.body);
        return null;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
      return null;
    }
  }
}
