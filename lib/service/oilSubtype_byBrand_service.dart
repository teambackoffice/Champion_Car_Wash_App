import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_subtype_by_brand_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class OilsubtypeBybrandService {
  final String _baseUrl =
      '${ApiConstants.baseUrl}/api/method/carwash.Api.auth.get_oil_subtypes_by_brand';

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<Message> getOilSubtypesByBrand(String brand) async {
    final String? sid = await _secureStorage.read(key: 'sid');
    if (sid == null) {
      throw Exception('SID not found in secure storage');
    }
    try {
      final uri = Uri.parse('$_baseUrl?brand=$brand');
      final client = http.Client();
      final request = http.Request('GET', uri);
      request.headers['Cookie'] = 'sid=$sid';

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();
      client.close();

      if (response.statusCode == 200) {
        return oilSubtypesbyBrandModalFromJson(responseBody).message;
      } else {
        throw Exception(
          'Failed to load oil subtypes by brand. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Failed to load oil subtypes by brand: $e');
    }
  }
}
