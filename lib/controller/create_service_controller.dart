import 'package:champion_car_wash_app/modal/create_service_modal.dart';
import 'package:champion_car_wash_app/service/create_service.dart';
import 'package:flutter/foundation.dart';

enum ServiceStatus { idle, loading, success, error }

class CarWashController extends ChangeNotifier {
  final CreateService _apiService = CreateService();

  ServiceStatus _status = ServiceStatus.idle;
  String? _message;
  String? _errorMessage;
  Map<String, dynamic>? _responseData;

  // Getters
  ServiceStatus get status => _status;
  String? get message => _message;
  String? get errorMessage => _errorMessage;
  Map<String, dynamic>? get responseData => _responseData;

  bool get isLoading => _status == ServiceStatus.loading;
  bool get isSuccess => _status == ServiceStatus.success;
  bool get isError => _status == ServiceStatus.error;

  // Methods
  Future<void> createService(CreateServiceModal serviceModel) async {
    _setStatus(ServiceStatus.loading);
    _clearMessages();

    try {
      final result = await _apiService.createServiceWithCustomerVehicle(
        serviceModel,
      );

      if (result['success']) {
        _responseData = result['data'];
        _message = result['message'];
        _setStatus(ServiceStatus.success);
      } else {
        _errorMessage = result['message'];
        _setStatus(ServiceStatus.error);
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred: $e';
      _setStatus(ServiceStatus.error);
    }
  }

  void _setStatus(ServiceStatus status) {
    _status = status;
    notifyListeners();
  }

  void _clearMessages() {
    _message = null;
    _errorMessage = null;
    _responseData = null;
  }

  void reset() {
    _status = ServiceStatus.idle;
    _clearMessages();
    notifyListeners();
  }
}
