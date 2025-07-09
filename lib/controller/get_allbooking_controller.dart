import 'package:champion_car_wash_app/modal/get_allbooking_modal.dart';
import 'package:champion_car_wash_app/service/get_allbooking_service.dart';
import 'package:flutter/material.dart';

class GetAllbookingController extends ChangeNotifier {
  final GetAllbookingService _service = GetAllbookingService();

  GetAllbookingModal? allbooking;
  bool _isLoading = false;
  String? _error;

  // Getters
  GetAllbookingModal? get allbookings => allbooking;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ServiceData> get bookingData => allbooking?.data ?? [];

  // Fetch booking list
  Future<void> fetchBookingList() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      allbooking = await _service.getallbooking();
      _error = null;
    } catch (e) {
      _error = e.toString();
      allbooking = null;
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
