import 'package:champion_car_wash_app/modal/car_wash_tech/new_carwash_modal.dart';
import 'package:champion_car_wash_app/service/car_wash_tech/new_carwash_service.dart';
import 'package:flutter/material.dart';

class GetNewCarWashController extends ChangeNotifier {
  final GetNewCarWashService _newCarWashService = GetNewCarWashService();
  CarWashNewModalClass? _carWashNewModalClass;

  bool _isLoading = false;
  String? _error;

  // Public getters
  bool get isLoading => _isLoading;
  String? get error => _error;
  CarWashNewModalClass? get carWashNewModalClass => _carWashNewModalClass;

  // Method to fetch data
  Future<CarWashNewModalClass> getNewCarWashServices() async {
    setIsLoading(true);
    setError(null);

    try {
      _carWashNewModalClass = await _newCarWashService.getNewCarWashService();
      setIsLoading(false);
      _carWashNewModalClass = _carWashNewModalClass;
    } catch (e) {
      setError(e.toString());
      setIsLoading(false);
      throw Exception('Error fetching new car wash services: $_error');
    }
    return _carWashNewModalClass!;
  }

  // Setters with notifyListeners
  void setIsLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    _error = value;
    notifyListeners();
  }
}
