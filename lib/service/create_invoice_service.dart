import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CreateInvoiceService {
  static const String _url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.create_sales_invoice';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  /// Create Sales Invoice API
  static Future<http.Response?> createSalesInvoice({
    required String customer,
    required String serviceId,
    required List<Map<String, dynamic>> items,
  }) async {
    print(_url);
    try {
      // Get SID from secure storage
      final sid = await _storage.read(key: 'sid');

      if (sid == null) {
        throw Exception("User session ID (sid) not found in secure storage.");
      }

      // Print all items before sending
      for (var item in items) {
        print(
          'Item -> Code: ${item['item_code']}, Qty: ${item['qty']}, Price: ${item['price']}',
        );
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = json.encode({
        "customer": customer,
        "service_id": serviceId,
        "items": items,
      });

      print('Sending Invoice Request Body: $body');

      final response = await http.post(
        Uri.parse(_url),
        headers: headers,
        body: body,
      );

      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      return response;
    } catch (e) {
      print('Error while creating sales invoice: $e');
      return null;
    }
  }
}
