import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_tech/new_oiltech_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class NewOilTechService {
  final String Url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_oil_open_services';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<NewOilModalClass> getNewOilTechService() async {
    try {
      final request = http.Request('GET', Uri.parse(Url));
      final String? sid = await _secureStorage.read(key: 'sid');
      if (sid == null) {
        throw Exception('SID not found in secure storage');
      }

      request.headers['Cookie'] = 'sid=$sid';

      final response = await http.Client().send(request);
      final responseBody = await response.stream.bytesToString();

      // ✅ Print status code and full JSON response

      if (response.statusCode == 200) {
        return newOilModalClassFromJson(responseBody);
      } else {
        throw Exception('Failed to load new oil tech services');
      }
    } catch (e) {
      throw Exception('Failed to load new oil tech services: $e');
    }
  }
}
