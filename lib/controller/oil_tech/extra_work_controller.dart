import 'package:champion_car_wash_app/modal/oil_tech/extra_work_modal.dart';
import 'package:champion_car_wash_app/service/oil_tech/extra_work_service.dart';
import 'package:flutter/material.dart';

class ExtraWorkController extends ChangeNotifier {
  final ExtraWorkService _newExtraWorkService = ExtraWorkService();
  ExtraWorkModal? extraWorkModalClass;
  String? error;
  bool isLoading = false;

  Future<void> getExtraWorkServices() async {
    setIsLoading(true);
    setError(null);
    notifyListeners();

    try {
      extraWorkModalClass = await _newExtraWorkService.getExtraWork();
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
