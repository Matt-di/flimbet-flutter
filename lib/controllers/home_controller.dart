import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:filmbet/models/movie.dart';
import 'package:filmbet/responses/movie_response.dart';
import 'package:filmbet/screens/movies_screen.dart';
import 'package:filmbet/services/api.dart';

class HomeController extends GetxController {
  var isLoadingNowPlaying = true.obs;
  var isLoadingUpcoming = true.obs;
  var isLoadingPopular = true.obs;

  var nowPlayingMovies = <Movie>[];
  var showCaseMovie = <Movie>[];
  var popularMovies = <Movie>[];
  var upcomingMovies = <Movie>[];

  @override
  void onInit() {
    getShowCaseMovie();
    getNowPlayingMovies();
    getPopularMovies();
    getUpcomingMovies();
    super.onInit();
  } //end of on init

  Future<void> getShowCaseMovie() async {
    isLoadingNowPlaying.value = true;

    showCaseMovie.clear();
    var response = await Api.getShowcaseMovies();
    var movieResponse = MovieResponse.fromJson(response.data);

    showCaseMovie.addAll(movieResponse.movies);
    isLoadingNowPlaying.value = false;
  } //end of getNowPlayingMovies

  Future<void> getRelatedMovies({required String movieId}) async {
    var response = await Api.getRelatedMovies(movieId: movieId);
    Logger().d("Related Movies => ${response}");
    var relatedMovieResponse = MovieResponse.fromJson(response.data);

    showCaseMovie.clear();

    showCaseMovie.addAll(relatedMovieResponse.movies);

    // isLoadingRelatedMovies.value = false;
  } //end of getRelatedMovies

  Future<void> getNowPlayingMovies() async {
    isLoadingNowPlaying.value = true;

    nowPlayingMovies.clear();
    var response = await Api.getMovies(type: 'now_playing');
    var movieResponse = MovieResponse.fromJson(response.data);

    nowPlayingMovies.addAll(movieResponse.movies);
    isLoadingNowPlaying.value = false;
  } //end of getNowPlayingMovies

  Future<void> getPopularMovies() async {
    isLoadingPopular.value = true;

    popularMovies.clear();
    var response = await Api.getMovies(type: 'popular');
    var movieResponse = MovieResponse.fromJson(response.data);

    popularMovies.addAll(movieResponse.movies);
    isLoadingPopular.value = false;
  } //end of getTrendingMovies

  Future<void> getUpcomingMovies() async {
    isLoadingUpcoming.value = true;

    upcomingMovies.clear();
    var response = await Api.getMovies(type: 'upcoming');
    var movieResponse = MovieResponse.fromJson(response.data);

    upcomingMovies.addAll(movieResponse.movies);
    isLoadingUpcoming.value = false;
  }

  // Future<void> searchMovies(String value) async {
  //   isLoadingUpcoming.value = true;
  //   upcomingMovies.clear();
  //   var response = await Api.getMovies(type: 'upcoming');
  //   var movieResponse = MovieResponse.fromJson(response.data);

  //   upcomingMovies.addAll(movieResponse.movies);
  //   isLoadingUpcoming.value = false;
  // } //end of getTrendingMovies
} //end of controller
