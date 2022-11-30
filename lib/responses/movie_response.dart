import 'package:logger/logger.dart';
import 'package:filmbet/models/movie.dart';

class MovieResponse {
  List<Movie> movies = [];
  late int lastPage;

  MovieResponse.fromJson(Map<String, dynamic> json) {
    // Logger().d("decoding in response${json['movies']}");
    // movies = List<Movie>.from(
    //     json['movies']['data'].map((movie) => Movie.fromJson(movie)));
    json['movies']['data']
        .forEach((movie) => movies.add(Movie.fromJson(movie)));
    lastPage = json['movies']['meta']['last_page'];
  }
} //end of response
