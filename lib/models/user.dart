class User {
  late String id;
  late String name;
  late String lastname;
  late String email;
  late dynamic image;
  late int rented;
  late int rentActive;
  late bool isSubscribed;
  late int subPayment;
  late int payed;
  late List<Subscription> subscriptions;

  User();
  User.fromMap(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    lastname = json["lastname"];
    email = json["email"];
    image = json["image"];
    rented = json["rented"];
    rentActive = json["rentActive"];
    isSubscribed = json["isSubscribed"];
    subPayment = json["subPayment"];
    payed = json["payed"];
    subscriptions = List<Subscription>.from(
        json["subscriptions"].map((x) => Subscription.fromMap(x)));
  }
}

class Subscription {
  Subscription({
    required this.id,
    required this.status,
    required this.endAt,
  });

  String id;
  int status;
  DateTime endAt;

  factory Subscription.fromMap(Map<String, dynamic> json) => Subscription(
        id: json["id"],
        status: json["status"],
        endAt: DateTime.parse(json["end_at"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "status": status,
        "end_at":
            "${endAt.year.toString().padLeft(4, '0')}-${endAt.month.toString().padLeft(2, '0')}-${endAt.day.toString().padLeft(2, '0')}",
      };
}
