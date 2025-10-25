import 'package:champion_car_wash_app/service/oil_tech/inprogress_to_complt_service.dart';
import 'package:flutter/material.dart';

class OilInprogressStatusServiceController with ChangeNotifier {
  final OilInProgressStatusService _service = OilInProgressStatusService();

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
    print('🔧 [OIL_STATUS_CONTROLLER] Starting submitOilChange');
    print('🔧 [OIL_STATUS_CONTROLLER] Service ID: $serviceId');
    print('🔧 [OIL_STATUS_CONTROLLER] Quantity: $quantity, Litres: $litres');
    print('🔧 [OIL_STATUS_CONTROLLER] Price: $price, Sub Oil Type: $subOilType');
    print('🔧 [OIL_STATUS_CONTROLLER] Oil Total: $oilTotal');
    print('🔧 [OIL_STATUS_CONTROLLER] Extra Work Items: ${extraWork.length}');
    print('🔧 [OIL_STATUS_CONTROLLER] Extra Works Total: $extraWorksTotal');
    print('🔧 [OIL_STATUS_CONTROLLER] Inspection Type: $inspectionType');
    print('🔧 [OIL_STATUS_CONTROLLER] Answers: ${answers.length} items');
    
    for (int i = 0; i < answers.length; i++) {
      print('🔧 [OIL_STATUS_CONTROLLER] Answer $i: ${answers[i]}');
    }
    
    _isLoading = true;
    notifyListeners();

    try {
      print('🔧 [OIL_STATUS_CONTROLLER] Calling service submitOilChangeDetails...');
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
      
      print('🔧 [OIL_STATUS_CONTROLLER] Service call completed');
      print('🔧 [OIL_STATUS_CONTROLLER] Response: $_response');
      
    } catch (e) {
      print('❌ [OIL_STATUS_CONTROLLER] Error in submitOilChange: $e');
      _response = null;
    }

    _isLoading = false;
    notifyListeners();
    print('🔧 [OIL_STATUS_CONTROLLER] submitOilChange completed');
  }
}
