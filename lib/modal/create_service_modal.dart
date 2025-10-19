import 'dart:convert';

class ServiceItem {
  final String serviceType;
  final String? washType;
  final String? oilBrand;
  final String? oilType;
  final double? price;

  ServiceItem({
    required this.serviceType,
    this.washType,
    this.oilBrand,
    this.oilType,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'service_type': serviceType,
      if (washType != null) 'wash_type': washType,
      if (oilBrand != null) 'oil_brand': oilBrand,
      if (oilType != null) 'oil_type': oilType,
      'price': price,
    };
  }

  factory ServiceItem.fromJson(Map<String, dynamic> json) {
    return ServiceItem(
      serviceType: json['service_type'],
      washType: json['wash_type'],
      oilBrand: json['oil_brand'],
      oilType: json['oil_type'],
      price: json['price'].toDouble(),
    );
  }
}

class CreateServiceModal {
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
  final String fuelLevel;
  final String lastServiceOdometer;
  final String currentOdometerReading;
  final String nextServiceOdometer;
  final List<ServiceItem> services;
  final String? videoPath;
  final String serviceTotal;

  CreateServiceModal({
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
    required this.services,
    this.videoPath,
    required this.serviceTotal,
  });

  Map<String, String> toFormData() {
    return {
      'customer_name': customerName,
      'customer_phone': phone,
      'email': email,
      'address': address,
      'city': city,
      'branch': branch,
      'make': make,
      'model': model,
      'car_type': carType,
      'purchase_date': purchaseDate,
      'engine_number': engineNumber,
      'chasis_number': chasisNumber,
      'registration_number': registrationNumber,
      'fuel_level': fuelLevel,
      'last_service_odometer': lastServiceOdometer,
      'current_odometer_reading': currentOdometerReading,
      'next_service_odometer': nextServiceOdometer,
      'services': jsonEncode(services.map((s) => s.toJson()).toList()),
      'service_total': serviceTotal,
    };
  }
}
