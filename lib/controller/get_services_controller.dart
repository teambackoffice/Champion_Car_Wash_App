import 'package:champion_car_wash_app/modal/get_services_modal.dart';
import 'package:champion_car_wash_app/service/get_services_service.dart';
import 'package:flutter/foundation.dart';

class ServiceTypeController extends ChangeNotifier {
  final CarWashService _service = CarWashService();

  List<ServiceType> _serviceTypes = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  List<ServiceType> get serviceTypes => _serviceTypes;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasError => _error != null;
  bool get hasData => _serviceTypes.isNotEmpty;

  // Load service types
  Future<void> loadServiceTypes() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _service.getServiceTypes();

      if (response.error != null) {
        _setError(response.error!);
      } else {
        _serviceTypes = response.serviceTypes;
      }
    } catch (e) {
      _setError('Unexpected error: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Refresh service types
  Future<void> refreshServiceTypes() async {
    await loadServiceTypes();
  }

  // Get service type by name
  ServiceType? getServiceTypeByName(String name) {
    try {
      return _serviceTypes.firstWhere(
        (service) => service.name.toLowerCase() == name.toLowerCase(),
      );
    } catch (e) {
      return null;
    }
  }

  // Filter service types
  List<ServiceType> filterServiceTypes(String query) {
    if (query.isEmpty) return _serviceTypes;

    return _serviceTypes
        .where(
          (service) =>
              service.name.toLowerCase().contains(query.toLowerCase()) ||
              (service.description?.toLowerCase().contains(
                    query.toLowerCase(),
                  ) ??
                  false),
        )
        .toList();
  }

  // Clear all data
  void clearData() {
    _serviceTypes.clear();
    _clearError();
    notifyListeners();
  }

  // Private helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
