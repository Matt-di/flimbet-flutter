import 'dart:convert';

import 'package:filmbet/models/actor.dart';

class ActorResponse {
  late List<Actor> actors = [];

  ActorResponse.fromJson(String json) {
    jsonDecode(json).forEach((actor) => actors.add(Actor.fromJson(actor)));
  }
} //end of response
