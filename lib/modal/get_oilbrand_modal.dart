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
  List<OilBrand> oilBrands;
  List<OilType> oilTypes;

  Message({required this.oilBrands, required this.oilTypes});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    oilBrands: List<OilBrand>.from(
      (json["oil_brands"] ?? []).map((x) => OilBrand.fromJson(x)),
    ),
    oilTypes: List<OilType>.from(
      (json["oil_types"] ?? []).map((x) => OilType.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "oil_brands": List<dynamic>.from(oilBrands.map((x) => x.toJson())),
    "oil_types": List<dynamic>.from(oilTypes.map((x) => x.toJson())),
  };
}

class OilBrand {
  String name;

  OilBrand({required this.name});

  factory OilBrand.fromJson(Map<String, dynamic> json) =>
      OilBrand(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}

class OilType {
  String name;

  OilType({required this.name});

  factory OilType.fromJson(Map<String, dynamic> json) =>
      OilType(name: json["name"]);

  Map<String, dynamic> toJson() => {"name": name};
}
