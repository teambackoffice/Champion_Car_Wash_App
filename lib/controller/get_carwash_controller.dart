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
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await GetCarwashService.getCarwashList();

      if (result != null) {
        _carwashList = result;
      } else {
        _errorMessage = "Failed to fetch wash types.";
      }
    } catch (e) {
      _errorMessage = "An error occurred: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
