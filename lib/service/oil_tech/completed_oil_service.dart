import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_tech/completed_oil_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CompletedOilService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_oil_child_completed_service';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  // Define methods for the service here
  Future<OilCompletedModal> getCompletedOilData() async {
    final String? sid = await _secureStorage.read(key: 'sid');
    if (sid == null) {
      throw Exception('SID not found in secure storage');
    }
    try {
      final uri = Uri.parse(baseUrl);
      final client = http.Client();
      final request = http.Request('GET', uri);
      request.headers['Cookie'] = 'sid=$sid';

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();
      client.close();

      if (response.statusCode == 200) {
        return oilCompletedModalFromJson(responseBody);
      } else {
        throw Exception(
          'Failed to load completed oil data. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load completed oil data: $e');
    }
  }
}
