class GetNewBookingListModal {
  final bool success;
  final int count;
  final List<ServiceData> data;

  GetNewBookingListModal({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetNewBookingListModal.fromJson(Map<String, dynamic> json) {
    final message = json['message'] ?? {};
    return GetNewBookingListModal(
      success: message['success'] ?? false,
      count: message['count'] ?? 0,
      data:
          (message['data'] as List<dynamic>?)
              ?.map((e) => ServiceData.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ServiceData {
  final String serviceId;
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

  ServiceData({
    required this.serviceId,
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
    return ServiceData(
      serviceId: json['service_id'] ?? '',
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
      services:
          (json['services'] as List<dynamic>?)
              ?.map((e) => ServiceItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ServiceItem {
  final String serviceType;
  final String? washType;
  final String? oilBrand;
  final double price;

  ServiceItem({
    required this.serviceType,
    this.washType,
    this.oilBrand,
    required this.price,
  });

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceType: json['service_type'] ?? '',
      washType: json['wash_type'],
      oilBrand: json['oil_brand'],
      price: (json['price'] ?? 0).toDouble(),
    );
  }
}
