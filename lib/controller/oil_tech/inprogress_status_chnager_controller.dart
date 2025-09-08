import 'package:champion_car_wash_app/service/oil_tech/inprogress_to_complt_service.dart';
import 'package:flutter/material.dart';

class OilInprogressStatusServiceController with ChangeNotifier {
  final OilInprogressStatusService _service = OilInprogressStatusService();

  bool _isLoading = false;
  Map<String, dynamic>? _response;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get response => _response;

  Future<void> submitOilChange({
    required String serviceId,
    required int quantity,
    required int litres,
    required double price,
    required String subOilType,
    required double oilTotal,
    required List<Map<String, dynamic>> extraWork,
    required double extraWorksTotal,
    required String inspectionType,
    required List<Map<String, String>> answers,
  }) async {
    _isLoading = true;
    notifyListeners();

    _response = await _service.submitOilChangeDetails(
      serviceId: serviceId,
      quantity: quantity,
      litres: litres,
      price: price,
      subOilType: subOilType,
      oilTotal: oilTotal,
      extraWork: extraWork,
      extraWorksTotal: extraWorksTotal,
      inspectionType: inspectionType,
      answers: answers,
    );

    _isLoading = false;
    notifyListeners();
  }
}
