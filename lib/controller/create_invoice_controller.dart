import 'package:champion_car_wash_app/service/create_invoice_service.dart';
import 'package:flutter/material.dart';

class SalesInvoiceController extends ChangeNotifier {
  bool isLoading = false;
  String? responseMessage;

  Future<void> submitInvoice({
    required String customer,
    required String serviceId,
    required List<Map<String, dynamic>> items,
  }) async {
    isLoading = true;
    responseMessage = null;
    notifyListeners();

    try {
      final response = await CreateInvoiceService.createSalesInvoice(
        customer: customer,
        serviceId: serviceId,
        items: items,
      );

      if (response != null && response.statusCode == 200) {
        responseMessage = 'Invoice created successfully!';
        debugPrint(response.body); // or parse JSON here
      } else {
        responseMessage =
            'Error: ${response?.statusCode} ${response?.reasonPhrase}';
      }
    } catch (e) {
      responseMessage = 'Exception: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
