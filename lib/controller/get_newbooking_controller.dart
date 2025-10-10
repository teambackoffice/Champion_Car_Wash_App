import 'package:champion_car_wash_app/modal/get_newbooking_modal.dart';
import 'package:champion_car_wash_app/service/get_new_booking_list_service.dart';
import 'package:flutter/material.dart';

class GetNewbookingController extends ChangeNotifier {
  final GetNewBookingListService _service = GetNewBookingListService();

  GetNewBookingListModal? _bookingList;
  bool _isLoading = false;
  String? _error;

  // Getters
  GetNewBookingListModal? get bookingList => _bookingList;
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ServiceData> get bookingData => _bookingList?.data ?? [];

  // Fetch booking list
  Future<void> fetchBookingList() async {
    // Only notify if we're not in the initial state
    if (_bookingList != null || _error != null) {
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _error = null;
    }

    try {
      _bookingList = await _service.getnewbookinglist();
      _error = null;
    } catch (e) {
      _error = e.toString();
      _bookingList = null;
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
