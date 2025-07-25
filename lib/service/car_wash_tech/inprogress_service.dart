import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/car_wash_tech/inprogress_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InprogressCarWashService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_carwash_child_inprogress_services';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<CarwashInProgressModal> getInProgressCarWashService() async {
    try {
      final request = http.Request('GET', Uri.parse(baseUrl));
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
        return carwashInProgressModalFromJson(responseBody);
      } else {
        throw Exception(
          'Failed to load in-progress car wash services. Status Code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error fetching in-progress car wash services: $e');
    }
  }
}
