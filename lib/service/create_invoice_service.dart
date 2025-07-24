import 'dart:convert';

import 'package:champion_car_wash_app/config/api_constants.dart';
import 'package:champion_car_wash_app/modal/create_invoice_modal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class CreateInvoiceService {
  static const String _url =
      '${ApiConstants.baseUrl}api/method/carwash.Api.auth.create_sales_invoice';
  static final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static Future<http.Response?> createSalesInvoice(
    CreateInvoiceModal requestData,
  ) async {
    print(_url);
    try {
      // Get SID from secure storage
      final sid = await _storage.read(key: 'sid');

      if (sid == null) {
        throw Exception("User session ID (sid) not found in secure storage.");
      }

      // Print all items before sending
      for (var item in requestData.items) {
        print(
          'Item -> Code: ${item.itemCode}, Qty: ${item.qty}',

          //  Price: ${item.price},
        );
      }

      final headers = {
        'Content-Type': 'application/json',
        'Cookie': 'sid=$sid',
      };

      final body = json.encode(requestData.toJson());

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
