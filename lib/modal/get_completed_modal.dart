class GetCompletedModal {
  final bool success;
  final int count;
  final List<CompletedServiceData> data;

  GetCompletedModal({
    required this.success,
    required this.count,
    required this.data,
  });

  factory GetCompletedModal.fromJson(Map<String, dynamic> json) {
    return GetCompletedModal(
      success: json['success'] ?? false, // Handle null with default value
      count: json['count'] ?? 0, // Handle null with default value
      data: json['data'] != null
          ? (json['data'] as List)
                .map((e) => CompletedServiceData.fromJson(e))
                .toList()
          : [], // Handle null data array
    );
  }
}

class CompletedServiceData {
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
  final List<ConpletedServiceItem> services;

  CompletedServiceData({
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
    this.video,
    required this.services,
  });

  factory CompletedServiceData.fromJson(Map<String, dynamic> json) {
    return CompletedServiceData(
      serviceId: json['service_id'],
      customerName: json['customer_name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      city: json['city'],
      branch: json['branch'],
      make: json['make'] ?? '',
      model: json['model'],
      carType: json['car_type'] ?? '',
      purchaseDate: json['purchase_date'],
      engineNumber: json['engine_number'],
      chasisNumber: json['chasis_number'],
      registrationNumber: json['registration_number'],
      fuelLevel: (json['fuel_level'] as num).toDouble(),
      lastServiceOdometer: (json['last_service_odometer'] as num).toDouble(),
      currentOdometerReading: (json['current_odometer_reading'] as num)
          .toDouble(),
      nextServiceOdometer: (json['next_service_odometer'] as num).toDouble(),
      video: json['video'],
      services: (json['services'] as List)
          .map((e) => ConpletedServiceItem.fromJson(e))
          .toList(),
    );
  }
}

class ConpletedServiceItem {
  final String serviceType;
  final String washType;
  final String? oilBrand;
  final double price;

  ConpletedServiceItem({
    required this.serviceType,
    required this.washType,
    this.oilBrand,
    required this.price,
  });

  factory ConpletedServiceItem.fromJson(Map<String, dynamic> json) {
    return ConpletedServiceItem(
      serviceType: json['service_type'],
      washType: json['wash_type'],
      oilBrand: json['oil_brand'],
      price: (json['price'] as num).toDouble(),
    );
  }
}
