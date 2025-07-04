import 'dart:convert';
import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/get_prebooking_list.dart';
import 'package:http/http.dart' as http;

class GetPrebookingListService {
  final String Url = '${ApiConstants.baseUrl}api/method/carwash.Api.auth.get_pre_booking_list';
  
  final Map<String, String> headers = {
    'Cookie': 'full_name=vijila; sid=a98594523055a318970eff80c6de962870f03bc371964b170708d7a2; system_user=no; user_id=vijila%40gmail.com; user_image='
  };

  Future<GetPreBookingList> getPreBookingList() async {
    try {
      final request = http.Request('GET', Uri.parse(Url));
      request.headers.addAll(headers);
      
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonData = json.decode(responseBody);
        return GetPreBookingList.fromJson(jsonData);
      } else {
        throw Exception('Failed to load pre-booking list. Status Code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching pre-booking list: $e');
    }
  }
}