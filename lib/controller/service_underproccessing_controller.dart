import 'dart:convert';

import 'package:champion_car_wash_app/service/service_underprogress_service.dart';
import 'package:flutter/material.dart';

class ServiceUnderproccessingController extends ChangeNotifier {
  final ServiceUnderprogressService _apiService = ServiceUnderprogressService();

  String? responseMessage;
  bool isLoading = false;

  Future<bool> markServiceInProgress(
    String serviceId,
    String serviceType,
  ) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await _apiService.updateServiceToInProgress(
        serviceId,
        serviceType,
      );

      if (response != null && response.statusCode == 200) {
        final data = jsonDecode(response.body);
        responseMessage = data.toString(); // or extract something specific
        debugPrint('Service updated successfully: $responseMessage');
        return true; // <-- Success
      } else {
        responseMessage = 'Error: ${response?.statusCode}';
        debugPrint('Failed to update service: ${response?.body}');
        return false; // <-- Failed
      }
    } catch (e) {
      responseMessage = 'Exception: $e';
      debugPrint('Exception occurred: $e');
      return false; // <-- Failed
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
