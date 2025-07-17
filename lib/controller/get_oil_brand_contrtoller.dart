import 'package:champion_car_wash_app/modal/get_oilbrand_modal.dart';
import 'package:champion_car_wash_app/service/get_carwash_oil/get_oilbrand_service.dart';
import 'package:flutter/material.dart';

class GetOilBrandContrtoller extends ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;
  GetOilBrandList? _getOilBrandList;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  GetOilBrandList? get oilBrand => _getOilBrandList;

  List<OilBrand> get oilbrand => _getOilBrandList?.message.oilBrands ?? [];

  Future<void> fetchOilBrandServices() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await GetOilbrandService.getOilBrandList();

      if (result != null) {
        _getOilBrandList = result;
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
