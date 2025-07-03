// To parse this JSON data, do
//
//     final getPreBookingList = getPreBookingListFromJson(jsonString);

import 'dart:convert';

GetPreBookingList getPreBookingListFromJson(String str) => GetPreBookingList.fromJson(json.decode(str));

String getPreBookingListToJson(GetPreBookingList data) => json.encode(data.toJson());

class GetPreBookingList {
    Message message;

    GetPreBookingList({
        required this.message,
    });

    factory GetPreBookingList.fromJson(Map<String, dynamic> json) => GetPreBookingList(
        message: Message.fromJson(json["message"]),
    );

    Map<String, dynamic> toJson() => {
        "message": message.toJson(),
    };
}

class Message {
    int successKey;
    List<Datum> data;

    Message({
        required this.successKey,
        required this.data,
    });

    factory Message.fromJson(Map<String, dynamic> json) => Message(
        successKey: json["success_key"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success_key": successKey,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String name;
    String customerName;
    String phone;
    String regNumber;
    DateTime date;
    String time;
    String branch;
    String status;

    Datum({
        required this.name,
        required this.customerName,
        required this.phone,
        required this.regNumber,
        required this.date,
        required this.time,
        required this.branch,
        required this.status,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        name: json["name"],
        customerName: json["customer_name"],
        phone: json["phone"],
        regNumber: json["reg_number"],
        date: DateTime.parse(json["date"]),
        time: json["time"],
        branch: json["branch"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "customer_name": customerName,
        "phone": phone,
        "reg_number": regNumber,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "time": time,
        "branch": branch,
        "status": status,
    };
}
