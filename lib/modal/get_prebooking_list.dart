import 'dart:convert';

GetPreBookingList getPreBookingListFromJson(String str) =>
    GetPreBookingList.fromJson(json.decode(str));

String getPreBookingListToJson(GetPreBookingList data) =>
    json.encode(data.toJson());

class GetPreBookingList {
  final Message message;

  GetPreBookingList({required this.message});

  factory GetPreBookingList.fromJson(Map<String, dynamic> json) =>
      GetPreBookingList(message: Message.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class Message {
  final int successKey;
  final List<Datum> data;
  final int totalPreBookingCount;

  Message({
    required this.successKey,
    required this.data,
    required this.totalPreBookingCount,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    successKey: json['success_key'],
    data: List<Datum>.from(json['data'].map((x) => Datum.fromJson(x))),
    totalPreBookingCount: json['total pre_booking count'],
  );

  Map<String, dynamic> toJson() => {
    'success_key': successKey,
    'data': List<dynamic>.from(data.map((x) => x.toJson())),
    'total pre_booking count': totalPreBookingCount,
  };
}

class Datum {
  final String name;
  final String customerName;
  final String phone;
  final String regNumber;
  final DateTime date;
  final String time;
  final String branch;
  final String status;
  final List<Service> services;

  Datum({
    required this.name,
    required this.customerName,
    required this.phone,
    required this.regNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.status,
    required this.services,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json['name'],
    customerName: json['customer_name'],
    phone: json['phone'],
    regNumber: json['reg_number'],
    date: DateTime.parse(json['date']),
    time: json['time'],
    branch: json['branch'],
    status: json['status'],
    services: List<Service>.from(
      json['services'].map((x) => Service.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    'name': name,
    'customer_name': customerName,
    'phone': phone,
    'reg_number': regNumber,
    'date': date.toIso8601String().split('T').first,
    'time': time,
    'branch': branch,
    'status': status,
    'services': List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  final String serviceName;

  Service({required this.serviceName});

  factory Service.fromJson(Map<String, dynamic> json) =>
      Service(serviceName: json['service_name']);

  Map<String, dynamic> toJson() => {'service_name': serviceName};
}
