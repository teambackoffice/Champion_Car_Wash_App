class UnderprocessModal {
  final bool success;
  final int count;
  final List<ServiceCars> data;

  UnderprocessModal({
    required this.success,
    required this.count,
    required this.data,
  });

  factory UnderprocessModal.fromJson(Map<String, dynamic> json) {
    return UnderprocessModal(
      success: json['message']['success'] ?? false,
      count: json['message']['count'] ?? 0,
      data: (json['message']['data'] as List)
          .map((e) => ServiceCars.fromJson(e))
          .toList(),
    );
  }
}

class ServiceCars {
  final String serviceId;
  final String mainStatus;
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
  final List<ServiceItem> services;

  ServiceCars({
    required this.serviceId,
    required this.mainStatus,
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
    this.video,
    required this.services,
  });

  factory ServiceCars.fromJson(Map<String, dynamic> json) {
    return ServiceCars(
      serviceId: json['service_id'] ?? '',
      mainStatus: json['main status'] ?? '',
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
      fuelLevel: (json['fuel_level'] ?? 0).toDouble(),
      lastServiceOdometer: (json['last_service_odometer'] ?? 0).toDouble(),
      currentOdometerReading: (json['current_odometer_reading'] ?? 0)
          .toDouble(),
      nextServiceOdometer: (json['next_service_odometer'] ?? 0).toDouble(),
      video: json['video'],
      services: (json['services'] as List)
          .map((e) => ServiceItem.fromJson(e))
          .toList(),
    );
  }
}

class ServiceItem {
  final String serviceType;
  final String? washType;
  final String? oilBrand;
  final String? status;

  ServiceItem({
    required this.serviceType,
    this.washType,
    this.oilBrand,
    this.status,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceType: json['service_type'] ?? '',
      washType: json['wash_type'],
      oilBrand: json['oil_brand'],
      status: json['status'],
    );
  }
}
