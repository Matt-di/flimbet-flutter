import 'dart:convert';

BasicResponse basicResponseFromJson(String str) =>
    BasicResponse.fromJson(jsonDecode(str));

class BasicResponse {
  late String message;
  late bool status;

  BasicResponse({
    required this.message,
    required this.status,
  });

  factory BasicResponse.fromJson(Map<String, dynamic> json) => BasicResponse(
        message: json["message"],
        status: json["success"],
      );
}
