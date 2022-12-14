
import 'dart:convert';

List<Genre> genreFromJson(String str) => List<Genre>.from(json.decode(str).map((x) => Genre.fromJson(x)));

String genreToJson(List<Genre> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Genre {
    Genre({
        required this.id,
        required this.name,
        required this.moviesCount,
    });

    String id;
    String name;
    int moviesCount;

    factory Genre.fromJson(Map<String, dynamic> json) => Genre(
        id: json["id"],
        name: json["name"],
        moviesCount: json["movies_count"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "movies_count": moviesCount,
    };
}