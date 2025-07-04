import 'package:champion_car_wash_app/modal/get_make_modal.dart';
import 'package:champion_car_wash_app/service/get_makes_service.dart';
import 'package:flutter/material.dart';

class CarModelsController extends ChangeNotifier {
  final CarModelsService _service = CarModelsService();
  
  List<CarModel> _models = [];
  String _errorMessage = '';
  bool _isLoading = false;
  String _currentMake = '';

  // Getters
  List<CarModel> get models => _models;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get hasData => _models.isNotEmpty;
  String get currentMake => _currentMake;

  // Methods
  Future<void> fetchModelsByMake(String make) async {
    if (make.isEmpty) {
      _clearModels();
      return;
    }

    // Don't fetch if same make and already has data
    if (_currentMake == make && _models.isNotEmpty) {
      return;
    }

    _isLoading = true;
    _errorMessage = '';
    _currentMake = make;
    notifyListeners();
    
    try {
      final response = await _service.getModelsByMake(make);
      _models = response.models;
      _errorMessage = '';
    } catch (e) {
      _models = [];
      _errorMessage = e.toString();
      debugPrint('Error fetching car models: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _clearModels() {
    _models = [];
    _currentMake = '';
    _errorMessage = '';
    _isLoading = false;
    notifyListeners();
  }

  
  

  void clearData() {
    _clearModels();
  }
}