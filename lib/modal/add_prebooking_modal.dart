// To parse this JSON data, do
//
//     final addPreBookingList = addPreBookingListFromJson(jsonString);

import 'dart:convert';

AddPreBookingList addPreBookingListFromJson(String str) =>
    AddPreBookingList.fromJson(json.decode(str));

String addPreBookingListToJson(AddPreBookingList data) =>
    json.encode(data.toJson());

class AddPreBookingList {
  String customerName;
  String phone;
  String regNumber;
  DateTime date;
  String time;
  String branch;
  List<Service> services;

  AddPreBookingList({
    required this.customerName,
    required this.phone,
    required this.regNumber,
    required this.date,
    required this.time,
    required this.branch,
    required this.services,
  });

  factory AddPreBookingList.fromJson(Map<String, dynamic> json) =>
      AddPreBookingList(
        customerName: json["customer_name"],
        phone: json["phone"],
        regNumber: json["reg_number"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        branch: json["branch"],
        services: List<Service>.from(
          json["services"].map((x) => Service.fromJson(x)),
        ),
      );

  Map<String, dynamic> toJson() => {
    "customer_name": customerName,
    "phone": phone,
    "reg_number": regNumber,
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "branch": branch,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

class Service {
  String service;

  Service({required this.service});

  factory Service.fromJson(Map<String, dynamic> json) =>
      Service(service: json["service"]);

  Map<String, dynamic> toJson() => {"service": service};
}
