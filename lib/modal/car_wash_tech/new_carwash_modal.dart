// To parse this JSON data, do
//
//     final technicianModal = technicianModalFromJson(jsonString);

import 'dart:convert';

TechnicianModal technicianModalFromJson(String str) =>
    TechnicianModal.fromJson(json.decode(str));

String technicianModalToJson(TechnicianModal data) =>
    json.encode(data.toJson());

class TechnicianModal {
  OuterMessage message;

  TechnicianModal({required this.message});

  factory TechnicianModal.fromJson(Map<String, dynamic> json) =>
      TechnicianModal(message: OuterMessage.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class OuterMessage {
  InnerMessage message;

  OuterMessage({required this.message});

  factory OuterMessage.fromJson(Map<String, dynamic> json) =>
      OuterMessage(message: InnerMessage.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class InnerMessage {
  bool success;
  int count;
  List<Datum> data;

  InnerMessage({
    required this.success,
    required this.count,
    required this.data,
  });

  factory InnerMessage.fromJson(Map<String, dynamic> json) => InnerMessage(
    success: json['success'] ?? false, // <-- default false if null
    count: json['count'] ?? 0,
    data: json['data'] != null
        ? List<Datum>.from(json['data'].map((x) => Datum.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String serviceId;
  String customerName;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? branch;
  String make;
  String model;
  String carType;
  DateTime purchaseDate;
  String engineNumber;
  String chasisNumber;
  String registrationNumber;
  double fuelLevel;
  double lastServiceOdometer;
  double currentOdometerReading;
  double nextServiceOdometer;
  String? video;
  List<Service> services;
  String mainStatus;

  Datum({
    required this.serviceId,
    required this.customerName,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.branch,
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
    required this.mainStatus,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    serviceId: json['service_id'],
    customerName: json['customer_name'],
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    address: json['address'] ?? '',
    city: json['city'] ?? '',
    branch: json['branch'] ?? '',
    make: json['make'],
    model: json['model'],
    carType: json['car_type'],
    purchaseDate: DateTime.parse(json['purchase_date']),
    engineNumber: json['engine_number'],
    chasisNumber: json['chasis_number'],
    registrationNumber: json['registration_number'],
    fuelLevel: (json['fuel_level'] ?? 0).toDouble(),
    lastServiceOdometer: (json['last_service_odometer'] ?? 0).toDouble(),
    currentOdometerReading: (json['current_odometer_reading'] ?? 0).toDouble(),
    nextServiceOdometer: (json['next_service_odometer'] ?? 0).toDouble(),
    video: json['video'],
    services: List<Service>.from(
      json['services'].map((x) => Service.fromJson(x)),
    ),
    mainStatus: json['main_status'],
  );

  Map<String, dynamic> toJson() => {
    'service_id': serviceId,
    'customer_name': customerName,
    'phone': phone,
    'email': email,
    'address': address,
    'city': city,
    'branch': branch,
    'make': make,
    'model': model,
    'car_type': carType,
    'purchase_date':
        "${purchaseDate.year.toString().padLeft(4, '0')}-${purchaseDate.month.toString().padLeft(2, '0')}-${purchaseDate.day.toString().padLeft(2, '0')}",
    'engine_number': engineNumber,
    'chasis_number': chasisNumber,
    'registration_number': registrationNumber,
    'fuel_level': fuelLevel,
    'last_service_odometer': lastServiceOdometer,
    'current_odometer_reading': currentOdometerReading,
    'next_service_odometer': nextServiceOdometer,
    'video': video,
    'services': List<dynamic>.from(services.map((x) => x.toJson())),
    'main_status': mainStatus,
  };
}

class Service {
  String serviceType;
  String? status;
  double price;
  String? washType;
  String? oilBrand;
  double? oilQuantity;

  Service({
    required this.serviceType,
    required this.status,
    required this.price,
    required this.washType,
    this.oilBrand,
    required this.oilQuantity,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceType: json['service_type'],
    status: json['status'],
    price: (json['price'] ?? 0).toDouble(),
    washType: json['wash_type'],
    oilBrand: json['oil_brand'] ?? '',
    oilQuantity: json['oil_quantity'] != null
        ? (json['oil_quantity'] as num).toDouble()
        : null,
  );

  Map<String, dynamic> toJson() => {
    'service_type': serviceType,
    'status': status,
    'price': price,
    'wash_type': washType,
    'oil_brand': oilBrand,
    'oil_quantity': oilQuantity,
  };
}
