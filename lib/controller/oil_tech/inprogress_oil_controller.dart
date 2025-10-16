import 'package:champion_car_wash_app/modal/oil_tech/inprogress_oil_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/inprogress_oil_service.dart';
import 'package:flutter/material.dart';

class InProgressOilController extends ChangeNotifier {
  final InProgressOilService _inProgressOilService = InProgressOilService();
  OilInProgressModal? _oilInProgressModal;
  bool _isLoading = false;
  String? _error;

  OilInProgressModal? get oilInProgressModal => _oilInProgressModal;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchInProgressOilServices() async {
    try {
      setIsLoading(true);
      _oilInProgressModal = await _inProgressOilService
          .getInProgressOilService();
      setIsLoading(false);
    } catch (e) {
      setError(e.toString());
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
