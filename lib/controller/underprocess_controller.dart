import 'package:champion_car_wash_app/modal/underprocess_modal.dart';
import 'package:champion_car_wash_app/service/underprocess_service.dart';
import 'package:flutter/material.dart';

class UnderProcessingController extends ChangeNotifier {
  final UnderprocessService _service = UnderprocessService();

  UnderprocessModal? _underProcessData;
  bool _isLoading = false;
  String? _errorMessage;

  // Add service status management
  final Map<String, Map<String, String>> _serviceStatuses = {};

  UnderprocessModal? get underProcessData => _underProcessData;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch in-progress bookings
  Future<void> fetchUnderProcessingBookings() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final result = await _service.getunderprocessing();
      _underProcessData = result;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Optionally, get count of bookings
  int get bookingCount => _underProcessData?.count ?? 0;

  /// Optionally, get list of service cars
  List<ServiceCars> get serviceCars => _underProcessData?.data ?? [];

  // Service Status Management Methods

  /// Get service status for a specific booking and service
  String getServiceStatus(String bookingId, String serviceType) {
    if (!_serviceStatuses.containsKey(bookingId)) {
      _serviceStatuses[bookingId] = {};
    }
    return _serviceStatuses[bookingId]![serviceType] ?? 'Select Status';
  }

  /// Set service status for a specific booking and service
  void setServiceStatus(String bookingId, String serviceType, String status) {
    if (!_serviceStatuses.containsKey(bookingId)) {
      _serviceStatuses[bookingId] = {};
    }
    _serviceStatuses[bookingId]![serviceType] = status;
    notifyListeners(); // This will update the UI automatically
  }

  /// Check if any service has started for a booking
  bool hasAnyServiceStarted(String bookingId) {
    // Find the booking by serviceId (which seems to be the unique identifier)
    ServiceCars? booking = serviceCars.firstWhere(
      (car) => car.serviceId == bookingId,
      orElse: () => ServiceCars(
        serviceId: '',
        customerName: '',
        phone: '',
        email: '',
        address: '',
        city: '',
        branch: '',
        make: '',
        model: '',
        carType: '',
        purchaseDate: '',
        engineNumber: '',
        chasisNumber: '',
        registrationNumber: '',
        fuelLevel: 0.0,
        lastServiceOdometer: 0.0,
        currentOdometerReading: 0.0,
        nextServiceOdometer: 0.0,
        services: [],
        mainStatus: '',
      ),
    );

    if (booking.serviceId.isNotEmpty) {
      for (ServiceItem service in booking.services) {
        String status = getServiceStatus(bookingId, service.serviceType);
        if (status == 'Started' || status == 'Complete') {
          return true;
        }
      }
    }
    return false;
  }

  /// Check if all services are complete for a booking
  bool areAllServicesComplete(String bookingId) {
    ServiceCars? booking = serviceCars.firstWhere(
      (car) => car.serviceId == bookingId,
      orElse: () => ServiceCars(
        serviceId: '',
        customerName: '',
        phone: '',
        email: '',
        address: '',
        city: '',
        branch: '',
        make: '',
        model: '',
        carType: '',
        purchaseDate: '',
        engineNumber: '',
        chasisNumber: '',
        registrationNumber: '',
        fuelLevel: 0.0,
        lastServiceOdometer: 0.0,
        currentOdometerReading: 0.0,
        nextServiceOdometer: 0.0,
        services: [],
        mainStatus: '',
      ),
    );

    if (booking.serviceId.isNotEmpty && booking.services.isNotEmpty) {
      for (ServiceItem service in booking.services) {
        String status = getServiceStatus(bookingId, service.serviceType);
        if (status != 'Complete') {
          return false;
        }
      }
      return true; // All services are complete
    }
    return false; // No services or booking not found
  }

  /// Get all booking IDs that have started services
  List<String> getBookingsWithStartedServices() {
    List<String> startedBookings = [];
    for (ServiceCars booking in serviceCars) {
      if (hasAnyServiceStarted(booking.serviceId)) {
        startedBookings.add(booking.serviceId);
      }
    }
    return startedBookings;
  }

  /// Get all booking IDs that have completed all services
  List<String> getCompletedBookings() {
    List<String> completedBookings = [];
    for (ServiceCars booking in serviceCars) {
      if (areAllServicesComplete(booking.serviceId)) {
        completedBookings.add(booking.serviceId);
      }
    }
    return completedBookings;
  }

  /// Clear status for a specific booking (useful when booking is completed/invoiced)
  void clearBookingStatus(String bookingId) {
    _serviceStatuses.remove(bookingId);
    notifyListeners();
  }

  /// Clear all statuses (useful for logout or data reset)
  void clearAllStatuses() {
    _serviceStatuses.clear();
    notifyListeners();
  }

  /// Get all service statuses (for debugging or export)
  Map<String, Map<String, String>> getAllServiceStatuses() {
    return Map.from(_serviceStatuses);
  }

  /// Update service status and return updated booking state
  Map<String, dynamic> updateServiceStatusWithState(
    String bookingId,
    String serviceType,
    String status,
  ) {
    setServiceStatus(bookingId, serviceType, status);

    return {
      'hasStarted': hasAnyServiceStarted(bookingId),
      'allComplete': areAllServicesComplete(bookingId),
      'currentStatus': status,
    };
  }

  /// Get booking by service ID
  ServiceCars? getBookingById(String serviceId) {
    try {
      return serviceCars.firstWhere((car) => car.serviceId == serviceId);
    } catch (e) {
      return null;
    }
  }

  /// Get service status summary for a booking
  Map<String, String> getBookingServiceStatuses(String bookingId) {
    ServiceCars? booking = getBookingById(bookingId);
    Map<String, String> statuses = {};

    if (booking != null) {
      for (ServiceItem service in booking.services) {
        statuses[service.serviceType] = getServiceStatus(
          bookingId,
          service.serviceType,
        );
      }
    }

    return statuses;
  }

  /// Get progress percentage for a booking (0-100)
  double getBookingProgress(String bookingId) {
    ServiceCars? booking = getBookingById(bookingId);
    if (booking == null || booking.services.isEmpty) return 0.0;

    int completedServices = 0;
    for (ServiceItem service in booking.services) {
      String status = getServiceStatus(bookingId, service.serviceType);
      if (status == 'Complete') {
        completedServices++;
      }
    }

    return (completedServices / booking.services.length) * 100;
  }
}
