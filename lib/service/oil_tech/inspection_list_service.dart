import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_tech/inspection_list_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InspectionListService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_inspection_questions';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<InspectionListModal> getInspectionList(String inspectionType) async {
    final String? sid = await _secureStorage.read(key: 'sid');

    if (sid == null) {
      print('❌ SID not found in secure storage');
      throw Exception('SID not found in secure storage');
    }

    try {
      final uri = Uri.parse('$baseUrl?inspection_type=$inspectionType');

      print('🔹 Fetching Inspection List...');
      print('🔹 URL: $uri');
      print('🔹 SID: $sid');
      print('🔹 Inspection Type: $inspectionType');

      final client = http.Client();
      final request = http.Request('GET', uri);
      request.headers['Cookie'] = 'sid=$sid';

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();
      client.close();

      print('🔹 Status Code: ${response.statusCode}');
      print('🔹 Response Body: $responseBody');

      if (response.statusCode == 200) {
        print('✅ Successfully fetched inspection list.');
        return inspectionListModalFromJson(responseBody);
      } else {
        print(
          '❌ Failed to fetch inspection list. Status: ${response.statusCode}',
        );
        throw Exception(
          'Failed to load inspection list. Status: ${response.statusCode}',
        );
      }
    } catch (e) {
      print('❌ Error occurred while fetching inspection list: $e');
      throw Exception('Failed to load inspection list: $e');
    }
  }
}
