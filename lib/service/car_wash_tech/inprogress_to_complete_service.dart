import 'package:champion_car_wash_app/service/car_wash_tech/inprogress_to_complete_service.dart';
import 'package:flutter/foundation.dart';

import 'car_wash_inprogress_to_complete_service.dart';

class CarWashInProgressToCompleteController with ChangeNotifier {
  final CarWashInprogressToCompleteService _service = CarWashInprogressToCompleteService();

  bool _isLoading = false;
  String? _errorMessage;
  Map<String, dynamic>? _responseData;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get responseData => _responseData;

  /// Call API
  Future<void> submitCarwash({
    required String serviceId,
    required int price,
    required int carwashTotal,
    required String inspectionType,
    required List<Map<String, dynamic>> answers,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _service.submitCarwashDetails(
        serviceId: serviceId,
        price: price,
        carwashTotal: carwashTotal,
        inspectionType: inspectionType,
        answers: answers,
      );

      _responseData = response;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
