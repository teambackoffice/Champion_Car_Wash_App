import 'dart:developer' as developer;

import 'package:champion_car_wash_app/modal/get_allbooking_modal.dart';
import 'package:champion_car_wash_app/service/get_allbooking_service.dart';
import 'package:flutter/material.dart';

class GetAllbookingController extends ChangeNotifier {
  final GetAllbookingServ _service = GetAllbookingServ();

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
    developer.log(
      '=== GetAllbookingController: fetchBookingList called ===',
      name: 'GetAllbookingController',
    );

    // Only notify if we're not in the initial state
    if (allbooking != null || _error != null) {
      developer.log(
        'Not initial state - setting loading and notifying listeners',
        name: 'GetAllbookingController',
      );
      _isLoading = true;
      _error = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      developer.log(
        'Initial state - setting loading without notification',
        name: 'GetAllbookingController',
      );
      _isLoading = true;
      _error = null;
    }

    try {
      developer.log(
        'Calling service.getallbooking()...',
        name: 'GetAllbookingController',
      );

      allbooking = await _service.getallbooking();
      _error = null;

      developer.log(
        'SUCCESS: Received ${allbooking?.count ?? 0} bookings',
        name: 'GetAllbookingController',
      );
    } catch (e, stackTrace) {
      developer.log(
        'ERROR in fetchBookingList',
        name: 'GetAllbookingController',
        error: e,
        stackTrace: stackTrace,
      );

      _error = e.toString();
      allbooking = null;

      developer.log(
        'Error set: $_error',
        name: 'GetAllbookingController',
      );
    } finally {
      _isLoading = false;
      developer.log(
        'Setting isLoading=false and notifying listeners',
        name: 'GetAllbookingController',
      );
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    developer.log(
      'Clearing error',
      name: 'GetAllbookingController',
    );
    _error = null;
    notifyListeners();
  }
}
