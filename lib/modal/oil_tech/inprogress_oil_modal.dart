// To parse this JSON data, do
//
//     final oilInProgressModal = oilInProgressModalFromJson(jsonString);

import 'dart:convert';

OilInProgressModal oilInProgressModalFromJson(String str) =>
    OilInProgressModal.fromJson(json.decode(str));

String oilInProgressModalToJson(OilInProgressModal data) =>
    json.encode(data.toJson());

class OilInProgressModal {
  Message message;

  OilInProgressModal({required this.message});

  factory OilInProgressModal.fromJson(Map<String, dynamic> json) =>
      OilInProgressModal(message: Message.fromJson(json['message']));

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
  String address;
  String city;
  String branch;
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
  dynamic video;
  List<Service> services;

  Datum({
    required this.serviceId,
    required this.mainStatus,
    this.customerName,
    this.phone,
    this.email,
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        serviceId: json['service_id']?.toString() ?? '',
        mainStatus: json['main_status']?.toString() ?? '',
        customerName: json['customer_name']?.toString(),
        phone: json['phone']?.toString(),
        email: json['email']?.toString(),
        address: json['address']?.toString() ?? '',
        city: json['city']?.toString() ?? '',
        branch: json['branch']?.toString() ?? '',
        make: json['make']?.toString() ?? '',
        model: json['model']?.toString() ?? '',
        carType: json['car_type']?.toString() ?? '',
        purchaseDate: DateTime.parse(json['purchase_date']),
        engineNumber: json['engine_number']?.toString() ?? '',
        chasisNumber: json['chasis_number']?.toString() ?? '',
        registrationNumber: json['registration_number']?.toString() ?? '',
        fuelLevel: (json['fuel_level'] ?? 0).toDouble(),
        lastServiceOdometer: (json['last_service_odometer'] ?? 0).toDouble(),
        currentOdometerReading: (json['current_odometer_reading'] ?? 0).toDouble(),
        nextServiceOdometer: (json['next_service_odometer'] ?? 0).toDouble(),
        video: json['video'],
        services: List<Service>.from(
          (json['services'] as List? ?? []).map((x) => Service.fromJson(x)),
        ),
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
  };
}

class Service {
  String serviceType;
  String? status;
  String? oilBrand;

  Service({
    required this.serviceType,
    required this.status,
    required this.oilBrand,
  });

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    serviceType: json['service_type']?.toString() ?? '',
    status: json['status']?.toString(),
    oilBrand: json['oil_brand']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'service_type': serviceType,
    'status': status,
    'oil_brand': oilBrand,
  };
}
