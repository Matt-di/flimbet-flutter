// To parse this JSON data, do
//
//     final price = priceFromMap(jsonString);

import 'dart:convert';

List<Price> priceFromMap(String str) =>
    List<Price>.from(json.decode(str).map((x) => Price.fromMap(x)));

String priceToMap(List<Price> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Price {
  Price({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.month,
  });

  String id;
  String name;
  String description;
  int price;
  int month;

  factory Price.fromMap(Map<String, dynamic> json) => Price(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        month: json["month"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "description": description,
        "price": price,
        "month": month,
      };
}
