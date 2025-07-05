import 'dart:convert';

GetOilBrandList getOilBrandListFromJson(String str) =>
    GetOilBrandList.fromJson(json.decode(str));

String getOilBrandListToJson(GetOilBrandList data) =>
    json.encode(data.toJson());

class GetOilBrandList {
  Message message;

  GetOilBrandList({required this.message});

  factory GetOilBrandList.fromJson(Map<String, dynamic> json) =>
      GetOilBrandList(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  List<OilBrand> oilBrand;

  Message({required this.oilBrand});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    oilBrand: List<OilBrand>.from(
      json["oil brand"].map((x) => OilBrand.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "oil brand": List<dynamic>.from(oilBrand.map((x) => x.toJson())),
  };
}

class OilBrand {
  String name;
  double price;

  OilBrand({required this.name, required this.price});

  factory OilBrand.fromJson(Map<String, dynamic> json) =>
      OilBrand(name: json["name"], price: (json["price"] as num).toDouble());

  Map<String, dynamic> toJson() => {"name": name, "price": price};
}
