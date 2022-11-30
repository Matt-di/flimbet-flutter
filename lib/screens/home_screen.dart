import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:filmbet/components/genres.dart';
import 'package:filmbet/components/movie_carousel.dart';
import 'package:filmbet/controllers/genre_controller.dart';
import 'package:filmbet/controllers/home_controller.dart';
import 'package:filmbet/models/movie.dart';
import 'package:filmbet/screens/movie_detail_screen.dart';
import 'package:filmbet/screens/movies_screen.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatelessWidget {
  final homeController = Get.put(HomeController());
  final genreController = Get.put(GenreController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   leading: Icon(Icons.menu),
      //   title: Text("Filmbet"),
      //   actions: [Icon(Icons.access_alarm)],
      // ),
      body: Obx(() {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text(
                    "Welcome Back",
                    style: TextStyle(fontSize: 25),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Genres(genres: genreController.genres),
                  const Text("For You"),
                  MovieCarousel(movies: homeController.showCaseMovie),
                  const SizedBox(
                    height: 10,
                  ),
                  buildLandscapeMovieList(
                    title: 'Recent',
                    isLoading: homeController.isLoadingNowPlaying.value,
                    movies: homeController.nowPlayingMovies,
                  ),
                  const SizedBox(height: 20),
                  buildPortraitMovieList(
                    title: 'Popular',
                    type: 'popular',
                    isLoading: homeController.isLoadingPopular.value,
                    movies: homeController.popularMovies,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  buildPortraitMovieList(
                    title: 'Upcoming',
                    type: 'upcoming',
                    isLoading: homeController.isLoadingUpcoming.value,
                    movies: homeController.upcomingMovies,
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  Widget buildLandscapeMovieList({
    required String title,
    required bool isLoading,
    required List<Movie> movies,
  }) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${title}', style: const TextStyle(fontSize: 20)),
            InkWell(
              onTap: () {
                Get.to(
                  () => MoviesScreen(title: '${title}', type: 'now_playing'),
                  preventDuplicates: false,
                );
              },
              child: const Text(
                'Show All...',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 260,
          child: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return buildLandscapeMovieCard(movie: movies[index]);
                  },
                  separatorBuilder: (content, index) {
                    return const SizedBox(width: 10);
                  },
                ),
        ),
      ],
    );
  } // end of buildLandscapeMovieList

  Widget buildLandscapeMovieCard({required Movie movie}) {
    return InkWell(
      onTap: () {
        Get.to(
          () => MovieDetailScreen(movie: movie),
          preventDuplicates: false,
        );
      },
      child: Container(
        height: double.infinity, //260
        width: 340,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 200, //255 - 55 = 200
                child: Stack(
                  children: <Widget>[
                    const Center(child: CircularProgressIndicator()),
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: '${movie.banner}',
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '${movie.title}',
                        style: const TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: <Widget>[
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 22,
                        ),
                        Text(
                          '${movie.vote}',
                          style: const TextStyle(fontSize: 15),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  } // end of buildLandscapeMovieCard

  Widget buildPortraitMovieList({
    required String title,
    required String type,
    required bool isLoading,
    required List<Movie> movies,
  }) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('${title}', style: const TextStyle(fontSize: 20)),
            InkWell(
              onTap: () {
                Get.to(
                  () => MoviesScreen(title: title, type: type),
                  preventDuplicates: false,
                );
              },
              child: const Text(
                'Show All...',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          height: 250,
          child: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return buildPortraitMovieCard(
                        movie: movies[index], context: context);
                  },
                  separatorBuilder: (content, index) {
                    return const SizedBox(width: 10);
                  },
                ),
        ),
      ],
    );
  } // end of buildLandscapeMovieList

  Widget buildPortraitMovieCard(
      {required Movie movie, required BuildContext context}) {
    return InkWell(
      onTap: () {
        Get.to(
          () => MovieDetailScreen(movie: movie),
          preventDuplicates: false,
        );
      },
      child: Container(
        height: double.infinity, //255
        width: MediaQuery.of(context).size.width * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 210, //255 - 55 = 200
              child: Stack(
                children: <Widget>[
                  const Center(child: CircularProgressIndicator()),
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${movie.poster}',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 7),
            Text(
              '${movie.title}',
              style: const TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  } // end of buildLandscapeMovieCard

} //end of class
