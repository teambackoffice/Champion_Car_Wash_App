// To parse this JSON data, do
//
//     final oilCompletedModal = oilCompletedModalFromJson(jsonString);

import 'dart:convert';

OilCompletedModal oilCompletedModalFromJson(String str) =>
    OilCompletedModal.fromJson(json.decode(str));

String oilCompletedModalToJson(OilCompletedModal data) =>
    json.encode(data.toJson());

class OilCompletedModal {
  Message message;

  OilCompletedModal({required this.message});

  factory OilCompletedModal.fromJson(Map<String, dynamic> json) =>
      OilCompletedModal(message: Message.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class Message {
  bool success;
  int count;
  List<Datum> data;

  Message({required this.success, required this.count, required this.data});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    success: json['success'],
    count: json['count'],
    data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'success': success,
    'count': count,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String serviceId;
  String mainStatus;
  String? customerName;
  String? phone;
  String? email;
  String? address;
  String? city;
  String? branch;
  String? make;
  String? model;
  String? carType;
  DateTime? purchaseDate;
  String? engineNumber;
  String? chasisNumber;
  String? registrationNumber;
  double? fuelLevel;
  double? lastServiceOdometer;
  double? currentOdometerReading;
  double? nextServiceOdometer;
  dynamic video;
  List<Service> services;

  Datum({
    required this.serviceId,
    required this.mainStatus,
    this.customerName,
    this.phone,
    this.email,
    this.address,
    this.city,
    this.branch,
    this.make,
    this.model,
    this.carType,
    this.purchaseDate,
    this.engineNumber,
    this.chasisNumber,
    this.registrationNumber,
    this.fuelLevel,
    this.lastServiceOdometer,
    this.currentOdometerReading,
    this.nextServiceOdometer,
    this.video,
    required this.services,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    serviceId: json['service_id'] ?? '',
    mainStatus: json['main_status'] ?? '',
    customerName: json['customer_name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    city: json['city'],
    branch: json['branch'],
    make: json['make'],
    model: json['model'],
    carType: json['car_type'],
    purchaseDate: json['purchase_date'] != null 
        ? DateTime.tryParse(json['purchase_date']) 
        : null,
    engineNumber: json['engine_number'],
    chasisNumber: json['chasis_number'],
    registrationNumber: json['registration_number'],
    fuelLevel: json['fuel_level']?.toDouble(),
    lastServiceOdometer: json['last_service_odometer']?.toDouble(),
    currentOdometerReading: json['current_odometer_reading']?.toDouble(),
    nextServiceOdometer: json['next_service_odometer']?.toDouble(),
    video: json['video'],
    services: json['services'] != null 
        ? List<Service>.from(json['services'].map((x) => Service.fromJson(x)))
        : [],
  );

  Map<String, dynamic> toJson() => {
    'service_id': serviceId,
    'main_status': mainStatus,
    'customer_name': customerName,
    'phone': phone,
    'email': email,
    'address': address,
    'city': city,
    'branch': branch,
    'make': make,
    'model': model,
    'car_type': carType,
    'purchase_date': purchaseDate != null
        ? "${purchaseDate!.year.toString().padLeft(4, '0')}-${purchaseDate!.month.toString().padLeft(2, '0')}-${purchaseDate!.day.toString().padLeft(2, '0')}"
        : null,
    'engine_number': engineNumber,
    'chasis_number': chasisNumber,
    'registration_number': registrationNumber,
    'fuel_level': fuelLevel,
    'last_service_odometer': lastServiceOdometer,
    'current_odometer_reading': currentOdometerReading,
    'next_service_odometer': nextServiceOdometer,
    'video': video,
    'services': List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  String? serviceType;
  String? status;
  String? oilBrand;

  Service({
    this.serviceType,
    this.status,
    this.oilBrand,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceType: json['service_type'],
    status: json['status'],
    oilBrand: json['oil_brand'],
  );

  Map<String, dynamic> toJson() => {
    'service_type': serviceType,
    'status': status,
    'oil_brand': oilBrand,
  };
}
