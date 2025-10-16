import 'package:champion_car_wash_app/modal/oil_tech/completed_oil_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/completed_oil_service.dart';
import 'package:flutter/material.dart';

class CompletedOilController extends ChangeNotifier {
  final CompletedOilService _completedOilService = CompletedOilService();
  OilCompletedModal? _oilCompletedModal;
  bool _isLoading = false;
  String? _error;
  OilCompletedModal? get oilCompletedModal => _oilCompletedModal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<OilCompletedModal> fetchCompletedOilData() async {
    try {
      setIsLoading(true);
      _oilCompletedModal = await _completedOilService.getCompletedOilData();
      setIsLoading(false);
      return _oilCompletedModal!;
    } catch (e) {
      setError(e.toString());
      rethrow; // Re-throw the error to handle it in the UI if needed
    } finally {
      setIsLoading(false);
    }
  }

  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
