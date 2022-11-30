import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:filmbet/models/actor.dart';
import 'package:filmbet/models/basicResponse.dart';
import 'package:filmbet/models/movie.dart';
import 'package:filmbet/responses/actor_response.dart';
import 'package:filmbet/responses/movie_response.dart';
import 'package:filmbet/responses/related_movie_reponse.dart';
import 'package:filmbet/screens/register_screen.dart';
import 'package:filmbet/services/api.dart';

class MovieController extends GetxController {
  var isLoading = true.obs;
  var isLoadingPagination = false.obs;
  var isLoadingActors = true.obs;
  var isLoadingRelatedMovies = true.obs;
  var currentPage = 1.obs;
  var lastPage = 1.obs;
  var movies = <Movie>[];
  var actors = <Actor>[];
  var relatedMovies = <Movie>[];

  Future<void> getMovies({
    int page = 1,
    String? type,
    String? genreId,
    String? actorId,
    String? search,
  }) async {
    if (page == 1) {
      isLoading.value = true;
      currentPage.value = 1;
      movies.clear();
    }

    var response = await Api.getMovies(
        page: page,
        type: type,
        genreId: genreId,
        actorId: actorId,
        search: search);
    // print(response);
    var movieResponse = MovieResponse.fromJson(response.data);
    // final moves = movieFromJson(strData);

    // movies.addAll(movieResponse.movies);
    movies.addAll(movieResponse.movies);
    lastPage.value = movieResponse.lastPage;

    isLoading.value = false;
    isLoadingPagination.value = false;
  } //end of getMovies

  Future<void> getRentedMovies({
    int page = 1,
    // String? type,
    // String? genreId,
    // String? actorId,
    // String? search,
  }) async {
    if (page == 1) {
      isLoading.value = true;
      currentPage.value = 1;
      movies.clear();
    }

    var response = await Api.getMovies(page: page);
    // print(response);
    var movieResponse = MovieResponse.fromJson(response.data);
    // final moves = movieFromJson(strData);

    // movies.addAll(movieResponse.movies);
    movies.addAll(movieResponse.movies);
    lastPage.value = movieResponse.lastPage;

    isLoading.value = false;
    isLoadingPagination.value = false;
  } //end of getMovies

  Future<BasicResponse> rentMovie({required String movieId}) async {
    var response = await Api.rentMovie(movieId);
    BasicResponse basicResponse = basicResponseFromJson(response.toString());
    // if (response.data.registered == false) {
    //   Get.offAll(RegisterScreen());
    // }
    return basicResponse;
  }

  Future<void> getActors({required String movieId}) async {
    var response = await Api.getActors(movieId: movieId);
    var ddd =
        '[{"id":"2","name":"Mat","image":"mas"},{"id":"2","name":"Mat","image":"mas"},{"id":"2","name":"Mat","image":"mas"}]';
    var actorResponse = ActorResponse.fromJson(ddd);
    actors.clear();

    actors.addAll(actorResponse.actors);

    isLoadingActors.value = false;
  } //end of getActors

  Future<void> getRelatedMovies({required String movieId}) async {
    var response = await Api.getRelatedMovies(movieId: movieId);
    Logger().d("Related Movies => ${response}");
    var relatedMovieResponse = MovieResponse.fromJson(response.data);

    relatedMovies.clear();

    relatedMovies.addAll(relatedMovieResponse.movies);

    isLoadingRelatedMovies.value = false;
  } //end of getRelatedMovies
} //end of controller
