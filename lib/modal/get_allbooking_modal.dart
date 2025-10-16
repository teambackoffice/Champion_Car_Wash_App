class GetAllbookingModal {
  final bool success;
  final int count;
  final List<ServiceData> data;

  GetAllbookingModal({
    required this.success,
    required this.count,
    required this.data,
  });
  factory GetAllbookingModal.fromJson(Map<String, dynamic> json) {
    final message = json['message'];

    if (message == null) {
      throw Exception('Invalid JSON structure: message field is null');
    }

    return GetAllbookingModal(
      success: message['success'] ?? false,
      count: message['count'] ?? 0,
      data: List<ServiceData>.from(
        (message['data'] ?? []).map((x) => ServiceData.fromJson(x)),
      ),
    );
  }
}

class ServiceData {
  final String serviceId;
  final String status;
  final String customerName;
  final String phone;
  final String email;
  final String address;
  final String city;
  final String branch;
  final String make;
  final String model;
  final String carType;
  final String purchaseDate;
  final String engineNumber;
  final String chasisNumber;
  final String registrationNumber;
  final double fuelLevel;
  final double lastServiceOdometer;
  final double currentOdometerReading;
  final double nextServiceOdometer;
  final String? video;
  final List<GetAllServiceItem> services;

  ServiceData({
    required this.serviceId,
    required this.status,
    required this.customerName,
    required this.phone,
    required this.email,
    required this.address,
    required this.city,
    required this.branch,
    required this.make,
    required this.model,
    required this.carType,
    required this.purchaseDate,
    required this.engineNumber,
    required this.chasisNumber,
    required this.registrationNumber,
    required this.fuelLevel,
    required this.lastServiceOdometer,
    required this.currentOdometerReading,
    required this.nextServiceOdometer,
    required this.video,
    required this.services,
  });

  factory ServiceData.fromJson(Map<String, dynamic> json) {
    try {
      final serviceData = ServiceData(
        serviceId: json['service_id'] ?? '',
        status: json['status'] ?? '',
        customerName: json['customer_name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        address: json['address'] ?? '',
        city: json['city'] ?? '',
        branch: json['branch'] ?? '',
        make: json['make'] ?? '',
        model: json['model'] ?? '',
        carType: json['car_type'] ?? '',
        purchaseDate: json['purchase_date'] ?? '',
        engineNumber: json['engine_number'] ?? '',
        chasisNumber: json['chasis_number'] ?? '',
        registrationNumber: json['registration_number'] ?? '',
        fuelLevel: (json['fuel_level'] as num?)?.toDouble() ?? 0.0,
        lastServiceOdometer: (json['last_service_odometer'] as num?)?.toDouble() ?? 0.0,
        currentOdometerReading: (json['current_odometer_reading'] as num?)?.toDouble() ?? 0.0,
        nextServiceOdometer: (json['next_service_odometer'] as num?)?.toDouble() ?? 0.0,
        video: json['video'],
        services: List<GetAllServiceItem>.from(
          (json['services'] ?? []).map((x) => GetAllServiceItem.fromJson(x)),
        ),
      );

      return serviceData;
    } catch (e) {
      rethrow;
    }
  }
}

class GetAllServiceItem {
  final String serviceType;
  final String? washType;
  final String? oilBrand;
  final double price;

  GetAllServiceItem({
    required this.serviceType,
    this.washType,
    this.oilBrand,
    required this.price,
  });

  factory GetAllServiceItem.fromJson(Map<String, dynamic> json) {

    try {
      final item = GetAllServiceItem(
        serviceType: json['service_type'] ?? '',
        washType: json['wash_type'],
        oilBrand: json['oil_brand'],
        price: (json['price'] as num?)?.toDouble() ?? 0.0,
      );

      return item;
    } catch (e) {
      rethrow;
    }
  }
}
