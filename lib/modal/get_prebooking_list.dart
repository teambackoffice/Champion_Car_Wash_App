// To parse this JSON data, do
//
//     final getPreBookingList = getPreBookingListFromJson(jsonString);

import 'dart:convert';

GetPreBookingList getPreBookingListFromJson(String str) =>
    GetPreBookingList.fromJson(json.decode(str));

String getPreBookingListToJson(GetPreBookingList data) =>
    json.encode(data.toJson());

class GetPreBookingList {
  Message message;

  GetPreBookingList({required this.message});

  factory GetPreBookingList.fromJson(Map<String, dynamic> json) =>
      GetPreBookingList(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  int successKey;
  List<Datum> data;
  int totalPreBookingCount;

  Message({
    required this.successKey,
    required this.data,
    required this.totalPreBookingCount,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    successKey: json["success_key"],
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    totalPreBookingCount: json["total pre_booking count"],
  );

  Map<String, dynamic> toJson() => {
    "success_key": successKey,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "total pre_booking count": totalPreBookingCount,
  };
}

class Datum {
  String name;
  CustomerName customerName;
  Phone phone;
  RegNumber regNumber;
  DateTime date;
  String time;
  Branch branch;
  String status;
  List<Service> services;

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
    name: json["name"],
    customerName: customerNameValues.map[json["customer_name"]]!,
    phone: phoneValues.map[json["phone"]]!,
    regNumber: regNumberValues.map[json["reg_number"]]!,
    date: DateTime.parse(json["date"]),
    time: json["time"],
    branch: branchValues.map[json["branch"]]!,
    status: json["status"]!,
    services: List<Service>.from(
      json["services"].map((x) => Service.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "customer_name": customerNameValues.reverse[customerName],
    "phone": phoneValues.reverse[phone],
    "reg_number": regNumberValues.reverse[regNumber],
    "date":
        "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "time": time,
    "branch": branchValues.reverse[branch],
    "status": status,
    "services": List<dynamic>.from(services.map((x) => x.toJson())),
  };
}

enum Branch { DUBAI, QATAR }

final branchValues = EnumValues({"Dubai": Branch.DUBAI, "Qatar": Branch.QATAR});

enum CustomerName { JOHN_DOE, QWE }

final customerNameValues = EnumValues({
  "John Doe": CustomerName.JOHN_DOE,
  "qwe": CustomerName.QWE,
});

enum Phone { THE_9090909090, THE_919876543210 }

final phoneValues = EnumValues({
  "9090909090": Phone.THE_9090909090,
  "+91 9876543210": Phone.THE_919876543210,
});

enum RegNumber { KL55_AB9932, TN01_AB1234 }

final regNumberValues = EnumValues({
  "KL55AB9932": RegNumber.KL55_AB9932,
  "TN01AB1234": RegNumber.TN01_AB1234,
});

class Service {
  ServiceName serviceName;

  Service({required this.serviceName});

  factory Service.fromJson(Map<String, dynamic> json) =>
      Service(serviceName: serviceNameValues.map[json["service_name"]]!);

  Map<String, dynamic> toJson() => {
    "service_name": serviceNameValues.reverse[serviceName],
  };
}

enum ServiceName { CAR_WASH, OIL_CHANGE }

final serviceNameValues = EnumValues({
  "Car Wash": ServiceName.CAR_WASH,
  "Oil Change": ServiceName.OIL_CHANGE,
});

enum Status { PENDING }

final statusValues = EnumValues({"Pending": Status.PENDING});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
