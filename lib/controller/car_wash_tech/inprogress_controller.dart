import 'package:champion_car_wash_app/modal/car_wash_tech/inprogress_modal.dart';
import 'package:champion_car_wash_app/service/car_wash_tech/inprogress_service.dart';
import 'package:flutter/material.dart';

class InprogressCarWashController extends ChangeNotifier {
  final InprogressCarWashService _service = InprogressCarWashService();
  CarwashInProgressModal? _carWashInProgressModal;

  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;
  CarwashInProgressModal? get carWashInProgressModal => _carWashInProgressModal;

  Future<void> fetchInProgressServices() async {
    setIsLoading(true);

    try {
      _carWashInProgressModal = await _service.getInProgressCarWashService();
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
