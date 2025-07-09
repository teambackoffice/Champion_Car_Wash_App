import 'package:champion_car_wash_app/modal/create_invoice_modal.dart';
import 'package:champion_car_wash_app/service/create_invoice_service.dart';
import 'package:flutter/material.dart';

class SalesInvoiceController with ChangeNotifier {
  bool isLoading = false;
  String? responseMessage;

  Future<void> submitInvoice(CreateInvoiceModal requestData) async {
    isLoading = true;
    responseMessage = null;
    notifyListeners();

    try {
      final response = await CreateInvoiceService.createSalesInvoice(
        requestData,
      );

      if (response?.statusCode == 200) {
        responseMessage = 'Invoice created successfully!';
        print(response!.body); // or parse response if needed
      } else {
        responseMessage = 'Error: ${response?.reasonPhrase}';
      }
    } catch (e) {
      responseMessage = 'Exception: $e';
    }

    isLoading = false;
    notifyListeners();
  }
}
