import 'package:champion_car_wash_app/modal/oil_subtype_by_brand_modal.dart';
import 'package:champion_car_wash_app/service/oil_subtype_by_brand_service.dart';
import 'package:flutter/material.dart';

class OilsubtypeBybrandController extends ChangeNotifier {
  final OilsubtypeBybrandService _service = OilsubtypeBybrandService();

  bool isLoading = false;
  String? error;
  List<Subtype> oilSubtypes = [];

  Future<void> fetchOilSubtypesByBrand(String brand) async {
    setisLoading(true);

    try {
      final message = await _service.getOilSubtypesByBrand(brand);
      oilSubtypes = message.subtypes;
    } catch (e) {
      setError(e.toString());
    } finally {
      setisLoading(false);
    }
  }

  void setisLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void setError(String? value) {
    error = value;
    notifyListeners();
  }
}
