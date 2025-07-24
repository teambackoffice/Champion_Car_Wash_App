import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_tech/extra_work_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ExtraWorkService {
  final String url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_extra_work';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<ExtraWorkModal> getExtraWork() async {
    final token = await _secureStorage.read(key: 'token');
    final String? sid = await _secureStorage.read(key: 'sid');

    if (sid == null) {
      throw Exception('SID not found in secure storage');
    }

    try {
      final request = http.Request('GET', Uri.parse(url));
      request.headers['Cookie'] = 'sid=$sid';

      final response = await http.Client().send(request);
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        return extraWorkModalFromJson(responseBody);
      } else {
        throw Exception(
          'Failed to load extra work. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load extra work: $e');
    }
  }
}
