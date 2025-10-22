import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/oil_tech/inspection_list_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class InspectionListService {
  final String baseUrl =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_inspection_questions';
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  Future<InspectionListModal> getInspectionList(String inspectionType) async {
    print('🔍 [INSPECTION_SERVICE] Starting getInspectionList for type: $inspectionType');
    
    // Convert inspection type to proper format for API
    String apiInspectionType = _formatInspectionType(inspectionType);
    print('🔍 [INSPECTION_SERVICE] Formatted inspection type for API: $apiInspectionType');
    
    final String? sid = await _secureStorage.read(key: 'sid');
    print('🔍 [INSPECTION_SERVICE] Retrieved SID from storage: ${sid != null ? 'Found' : 'Not found'}');

    if (sid == null) {
      print('❌ [INSPECTION_SERVICE] SID not found in secure storage');
      throw Exception('SID not found in secure storage');
    }

    try {
      final uri = Uri.parse(baseUrl).replace(queryParameters: {
        'inspection_type': apiInspectionType,
      });
      print('🔍 [INSPECTION_SERVICE] Making request to: $uri');

      final client = http.Client();
      final request = http.Request('GET', uri);
      request.headers['Cookie'] = 'sid=$sid';
      
      print('🔍 [INSPECTION_SERVICE] Request headers: ${request.headers}');

      final response = await client.send(request);
      final responseBody = await response.stream.bytesToString();
      client.close();

      print('🔍 [INSPECTION_SERVICE] Response status: ${response.statusCode}');
      print('🔍 [INSPECTION_SERVICE] Response body: $responseBody');

      if (response.statusCode == 200) {
        try {
          final result = inspectionListModalFromJson(responseBody);
          print('🔍 [INSPECTION_SERVICE] Successfully parsed response');
          print('🔍 [INSPECTION_SERVICE] Questions count: ${result.message.questions.length}');
          return result;
        } catch (parseError) {
          print('❌ [INSPECTION_SERVICE] Error parsing response: $parseError');
          throw Exception('Failed to parse inspection list response: $parseError');
        }
      } else {
        print('❌ [INSPECTION_SERVICE] HTTP error: ${response.statusCode} - ${response.reasonPhrase}');
        throw Exception(
          'Failed to load inspection list. Status: ${response.statusCode}, Body: $responseBody',
        );
      }
    } catch (e) {
      print('❌ [INSPECTION_SERVICE] Exception in getInspectionList: $e');
      throw Exception('Failed to load inspection list: $e');
    }
  }

  /// Format inspection type for API compatibility
  String _formatInspectionType(String inspectionType) {
    switch (inspectionType.toLowerCase()) {
      case 'oil change':
        return 'Oil Change';
      case 'car wash':
        return 'Car Wash';
      default:
        // Capitalize first letter of each word
        return inspectionType
            .split(' ')
            .map((word) => word.isEmpty ? '' : word[0].toUpperCase() + word.substring(1).toLowerCase())
            .join(' ');
    }
  }
}
