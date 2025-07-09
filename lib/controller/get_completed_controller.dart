import 'package:champion_car_wash_app/modal/get_completed_modal.dart';
import 'package:champion_car_wash_app/service/get_completed_services.dart';
import 'package:flutter/material.dart';

class GetCompletedController extends ChangeNotifier {
  final GetCompletedServices _service = GetCompletedServices();

  GetCompletedModal? completedservices;
  bool _isLoading = false;
  String? _error;

  // Getters
  GetCompletedModal? get completed => completedservices;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CompletedServiceData> get bookingData => completedservices?.data ?? [];

  // Fetch booking list
  Future<void> fetchcompletedlist() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      completedservices = await _service.getcompleted();
      _error = null;
    } catch (e) {
      _error = e.toString();
      completedservices = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
}
