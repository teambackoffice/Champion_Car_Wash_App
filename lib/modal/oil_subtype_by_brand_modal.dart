// To parse this JSON data, do
//
//     final oilSubtypesbyBrandModal = oilSubtypesbyBrandModalFromJson(jsonString);

import 'dart:convert';

OilSubtypesbyBrandModal oilSubtypesbyBrandModalFromJson(String str) =>
    OilSubtypesbyBrandModal.fromJson(json.decode(str));

String oilSubtypesbyBrandModalToJson(OilSubtypesbyBrandModal data) =>
    json.encode(data.toJson());

class OilSubtypesbyBrandModal {
  Message message;

  OilSubtypesbyBrandModal({required this.message});

  factory OilSubtypesbyBrandModal.fromJson(Map<String, dynamic> json) =>
      OilSubtypesbyBrandModal(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  String status;
  String brand;
  List<Subtype> subtypes;
  int code;

  Message({
    required this.status,
    required this.brand,
    required this.subtypes,
    required this.code,
  });

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    status: json["status"],
    brand: json["brand"],
    subtypes: List<Subtype>.from(
      json["subtypes"].map((x) => Subtype.fromJson(x)),
    ),
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "brand": brand,
    "subtypes": List<dynamic>.from(subtypes.map((x) => x.toJson())),
    "code": code,
  };
}

class Subtype {
  String name;
  String oilType;
  String packageType;
  double price;
  dynamic itemCode;

  Subtype({
    required this.name,
    required this.oilType,
    required this.packageType,
    required this.price,
    required this.itemCode,
  });

  factory Subtype.fromJson(Map<String, dynamic> json) => Subtype(
    name: json["name"],
    oilType: json["oil_type"],
    packageType: json["package_type"],
    price: json["price"],
    itemCode: json["item_code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "oil_type": oilType,
    "package_type": packageType,
    "price": price,
    "item_code": itemCode,
  };
}
