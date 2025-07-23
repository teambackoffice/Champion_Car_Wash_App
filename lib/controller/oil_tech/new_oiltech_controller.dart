import 'package:champion_car_wash_app/modal/oil_tech/new_oiltech_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/new_oiltech_service.dart';
import 'package:flutter/material.dart';

class NewOilTechController extends ChangeNotifier {
  final NewOilTechService _newOilTechService = NewOilTechService();
  NewOilModalClass? oilTechModalClass;
  String? error;
  bool isLoading = false;

  Future<void> getNewOilTechServices() async {
    setIsLoading(true);
    setError(null);
    notifyListeners();

    try {
      oilTechModalClass = await _newOilTechService.getNewOilTechService();
      setIsLoading(false);
    } catch (e) {
      setError(e.toString());
      setIsLoading(false);
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void setIsLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    error = value;
    notifyListeners();
  }
}
