// To parse this JSON data, do
//
//     final extraWorkModal = extraWorkModalFromJson(jsonString);

import 'dart:convert';

ExtraWorkModal extraWorkModalFromJson(String str) =>
    ExtraWorkModal.fromJson(json.decode(str));

String extraWorkModalToJson(ExtraWorkModal data) => json.encode(data.toJson());

class ExtraWorkModal {
  Message message;

  ExtraWorkModal({required this.message});

  factory ExtraWorkModal.fromJson(Map<String, dynamic> json) =>
      ExtraWorkModal(message: Message.fromJson(json['message']));

  Map<String, dynamic> toJson() => {'message': message.toJson()};
}

class Message {
  String status;
  List<ExtraDetail> extraDetails;
  int code;

  Message({
    required this.status,
    required this.extraDetails,
    required this.code,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    status: json['status'],
    extraDetails: List<ExtraDetail>.from(
      json['extra details'].map((x) => ExtraDetail.fromJson(x)),
    ),
    code: json['code'],
  );

  Map<String, dynamic> toJson() => {
    'status': status,
    'extra details': List<dynamic>.from(extraDetails.map((x) => x.toJson())),
    'code': code,
  };
}

class ExtraDetail {
  String name;
  double price;

  ExtraDetail({required this.name, required this.price});

  factory ExtraDetail.fromJson(Map<String, dynamic> json) =>
      ExtraDetail(name: json['name'], price: json['price']);

  Map<String, dynamic> toJson() => {'name': name, 'price': price};
}
