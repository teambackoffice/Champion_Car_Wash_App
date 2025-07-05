import 'dart:convert';

GetCarwashList getCarwashListFromJson(String str) =>
    GetCarwashList.fromJson(json.decode(str));

String getCarwashListToJson(GetCarwashList data) => json.encode(data.toJson());

class GetCarwashList {
  Message message;

  GetCarwashList({required this.message});

  factory GetCarwashList.fromJson(Map<String, dynamic> json) =>
      GetCarwashList(message: Message.fromJson(json["message"]));

  Map<String, dynamic> toJson() => {"message": message.toJson()};
}

class Message {
  List<WashType> washType;

  Message({required this.washType});

  factory Message.fromJson(Map<String, dynamic> json) => Message(
    washType: List<WashType>.from(
      json["wash type"].map((x) => WashType.fromJson(x)),
    ),
  );

  Map<String, dynamic> toJson() => {
    "wash type": List<dynamic>.from(washType.map((x) => x.toJson())),
  };
}

class WashType {
  String name;
  double price;

  WashType({required this.name, required this.price});

  factory WashType.fromJson(Map<String, dynamic> json) =>
      WashType(name: json["name"], price: (json["price"] as num).toDouble());

  Map<String, dynamic> toJson() => {"name": name, "price": price};
}
