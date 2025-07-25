import 'package:champion_car_wash_app/modal/car_wash_tech/completed_car_modal.dart';
import 'package:champion_car_wash_app/service/car_wash_tech/completed_car_service.dart';
import 'package:flutter/material.dart';

class CompletedCarController extends ChangeNotifier {
  final CompletedCarWashService _service = CompletedCarWashService();
  CarwashCompletedModal? _completedCarModal;
  CarwashCompletedModal? get completedCarModal => _completedCarModal;

  bool _isLoading = false;
  String? _error;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchCompletedCarServiceData() async {
    setIsLoading(true);
    _error = null; // Reset error before fetching
    notifyListeners();

    try {
      _completedCarModal = await _service.getCompletedCarServiceData();
      _error = null;
    } catch (e) {
      setError(e.toString());
    } finally {
      setIsLoading(false);
    }
  }

  setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
