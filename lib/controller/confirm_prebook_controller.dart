// controller/confirm_prebook_controller.dart

import 'package:champion_car_wash_app/service/confirm_prebook_service.dart';
import 'package:flutter/material.dart';

class ConfirmPrebookController extends ChangeNotifier {
  final ConfirmPrebookService _service = ConfirmPrebookService();

  bool _isLoading = false;
  String? _responseMessage;
  String? _error;

  bool get isLoading => _isLoading;
  String? get responseMessage => _responseMessage;
  String? get error => _error;

  Future<void> confirmPreBooking(String regNumber) async {
    _isLoading = true;
    _error = null;
    _responseMessage = null;
    notifyListeners();

    try {
      final result = await _service.confirmPreBooking(regNumber);
      _responseMessage = result ?? 'Unknown response';

      // Check if the response indicates an error
      if (_responseMessage!.toLowerCase().contains('error') ||
          _responseMessage!.toLowerCase().contains('exception')) {
        _error = _responseMessage;
      }
    } catch (e) {
      _error = e.toString();
      _responseMessage = 'Failed to confirm booking: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearState() {
    _responseMessage = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
