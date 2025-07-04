import 'package:champion_car_wash_app/modal/get_all_makes_modal.dart';
import 'package:champion_car_wash_app/service/get_all_makes_service.dart';
import 'package:flutter/material.dart';

class CarMakesController extends ChangeNotifier {
  final CarMakesService _service = CarMakesService();
  
  List<CarMake> _makes = [];
  String _errorMessage = '';

  // Getters
  List<CarMake> get makes => _makes;
  String get errorMessage => _errorMessage;
  bool get hasData => _makes.isNotEmpty;

  // Methods
  Future<void> fetchMakes() async {
    
    try {
      final response = await _service.getAllMakes();
      _makes = response.makes;
    } catch (e) {
      _errorMessage = e.toString();
      debugPrint('Error fetching car makes: $e');
    }
  }

  

  

  CarMake? findMakeByName(String name) {
    try {
      return _makes.firstWhere(
        (make) => make.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  List<CarMake> searchMakes(String query) {
    if (query.isEmpty) return _makes;
    
    return _makes.where((make) =>
      make.name.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }


}
