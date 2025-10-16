// To parse this JSON data, do
//
//     final newOilModalClass = newOilModalClassFromJson(jsonString);

import 'dart:convert';

NewOilModalClass newOilModalClassFromJson(String str) =>
    NewOilModalClass.fromJson(json.decode(str));

String newOilModalClassToJson(NewOilModalClass data) =>
    json.encode(data.toJson());

class NewOilModalClass {
  Message message;

  NewOilModalClass({required this.message});

  factory NewOilModalClass.fromJson(Map<String, dynamic> json) =>
      NewOilModalClass(message: Message.fromJson(json['message']));

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
  String customerName;
  String phone;
  String email;
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
  String? video;
  List<Service> services;

  Datum({
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

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    serviceId: json['service_id'],
    customerName: json['customer_name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    city: json['city'],
    branch: json['branch'],
    make: json['make'],
    model: json['model'],
    carType: json['car_type'],
    purchaseDate: DateTime.parse(json['purchase_date']),
    engineNumber: json['engine_number'],
    chasisNumber: json['chasis_number'],
    registrationNumber: json['registration_number'],
    fuelLevel: json['fuel_level'],
    lastServiceOdometer: json['last_service_odometer'],
    currentOdometerReading: json['current_odometer_reading'],
    nextServiceOdometer: json['next_service_odometer'],
    video: json['video'],
    services: List<Service>.from(
      json['services'].map((x) => Service.fromJson(x)),
    ),
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
  };
}

class Service {
  String serviceType;
  String? status;
  String? oilBrand;

  Service({required this.serviceType, required this.status, this.oilBrand});

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
