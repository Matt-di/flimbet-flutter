import 'dart:convert';

import '../models/user.dart';

UserResponse userResponseFromMap(String str) =>
    UserResponse.fromMap(json.decode(str));

class UserResponse {
  UserResponse({required this.user, this.token});

  User user;
  String? token;

  factory UserResponse.fromMap(Map<String, dynamic> json) =>
      UserResponse(user: User.fromMap(json["user"]), token: json['token']);
}
