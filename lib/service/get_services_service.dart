import 'dart:convert';
import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_services_modal.dart';
import 'package:http/http.dart' as http;

class CarWashService {
  static const String apiEndpoint =
      '${ApiConstants.baseUrl}/api/method/carwash.Api.auth.get_service_type';

  // Get service types from API
  Future<ServiceTypeResponse> getServiceTypes() async {
    try {
      final uri = Uri.parse(apiEndpoint);
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return ServiceTypeResponse.fromJson(jsonData);
      } else {
        return ServiceTypeResponse(
          serviceTypes: [],
          error: 'HTTP ${response.statusCode}: ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      return ServiceTypeResponse(serviceTypes: [], error: 'Network error: $e');
    }
  }

  // Alternative method using http.get for simpler usage
}
