import 'package:champion_car_wash_app/modal/car_wash_tech/new_carwash_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/new_oiltech_service.dart';
import 'package:flutter/material.dart';

class NewOilTechController extends ChangeNotifier {
  final NewOilTechService _newOilTechService = NewOilTechService();
  InnerMessage? innerMessage;
  String? error;
  bool isLoading = false;

  Future<void> getNewOilTechServices({required String serviceType}) async {
    setIsLoading(true);
    setError(null);
    notifyListeners();

    try {
      innerMessage = await _newOilTechService.getNewOilTechService(
        serviceType: serviceType,
      );
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
