import 'dart:convert';
import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_make_modal.dart';
import 'package:http/http.dart' as http;

class CarModelsService {
  static const String _baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth';

  Future<CarModelsResponse> getModelsByMake(String make) async {
    try {
      final uri = Uri.parse('$_baseUrl.get_models_by_make?make=$make');

      final request = http.Request('GET', uri);

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();

        final jsonData = json.decode(responseBody);

        final modelResponse = CarModelsResponse.fromJson(jsonData);

        return modelResponse;
      } else {
        throw Exception('Failed to load car models: ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('Error fetching car models: $e');
    }
  }
}
