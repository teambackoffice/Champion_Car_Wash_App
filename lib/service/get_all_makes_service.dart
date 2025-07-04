import 'dart:convert';
import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_all_makes_modal.dart';
import 'package:http/http.dart' as http;

class CarMakesService {
  static const String _baseUrl = '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_all_makes';
  

  Future<CarMakesResponse> getAllMakes() async {

    try {
      final uri = Uri.parse('$_baseUrl/get_all_makes');
      final request = http.Request('GET', uri);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final jsonData = json.decode(responseBody);
        return CarMakesResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load car makes: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching car makes: $e');
    }
  }

  Future<CarMakesResponse> refreshMakes() async {
    // In case you need to refresh or reload the data
    return await getAllMakes();
  }
}
