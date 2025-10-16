import 'package:champion_car_wash_app/modal/get_carwash_modal.dart';
import 'package:champion_car_wash_app/service/get_carwash_oil/get_carwash.dart';
import 'package:flutter/material.dart';

class CarwashServiceController extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  GetCarwashList? _carwashList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GetCarwashList? get carwashList => _carwashList;

  List<WashType> get washTypes => _carwashList?.message.washType ?? [];

  Future<void> fetchCarwashServices() async {
    // Only notify if we're not in the initial state
    if (_carwashList != null || _errorMessage != null) {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
    } else {
      // Initial load - set loading state without notifying
      _isLoading = true;
      _errorMessage = null;
    }

    try {
      final result = await GetCarwashService.getCarwashList();

      if (result != null) {
        _carwashList = result;
      } else {
        _errorMessage = 'Failed to fetch wash types.';
      }
    } catch (e) {
      _errorMessage = 'An error occurred: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
