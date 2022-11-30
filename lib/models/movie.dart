import 'dart:convert';

import 'package:filmbet/models/genre.dart';

List<Movie> movieFromJson(String str) =>
    List<Movie>.from(json.decode(str).map((x) => Movie.fromJson(x)));

class Movie {
  late String id;
  late String title;
  late String description;
  late String poster;
  late String banner;
  late String movieUrl;
  late String trailer;
  late String type;
  late String releaseDate;
  late double vote;
  late double rating;
  late double price;
  late bool rented;
  late int voteCount;
  List<Genre> genres = [];
  Movie.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    title = json["name"] ?? "";
    description = json["description"] ?? "";
    banner = json["image"];
    poster = json["image"] ?? "";
    trailer = json["trailer"] ?? "";
    type = json["type"];
    rented = json["rented"];
    movieUrl = json["movieUrl"] ?? "none";

    releaseDate = json["release_date"] ?? "2022";
    vote = json["rating"].toDouble();
    rating = json["rating"].toDouble();
    voteCount = json["rating"];
    price = json["price"].toDouble();
    json['genres'].forEach((genre) => genres.add(Genre.fromJson(genre)));
  }
} //end of model