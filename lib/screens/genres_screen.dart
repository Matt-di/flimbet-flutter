import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:filmbet/components/genres.dart';
import 'package:filmbet/components/movie_carousel.dart';
import 'package:filmbet/constants.dart';
import 'package:filmbet/controllers/genre_controller.dart';
import 'package:filmbet/controllers/home_controller.dart';
import 'package:filmbet/models/movie.dart';
import 'package:filmbet/screens/movie_detail_screen.dart';
import 'package:filmbet/screens/movies_screen.dart';
import 'package:filmbet/widgets/primary_button.dart';
import 'package:transparent_image/transparent_image.dart';

class GenresScreen extends StatefulWidget {
  final homeController = Get.put(HomeController());
  final genreController = Get.put(GenreController());

  @override
  _GenreScreenState createState() => _GenreScreenState();
}

class _GenreScreenState extends State<GenresScreen> {
  TextEditingController controller = new TextEditingController(text: "Search");
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
                  Row(
                    children: [
                      Expanded(
                          flex: 2,
                          child: TextField(
                            controller: controller,
                            decoration: InputDecoration(
                              // fillColor: ColorUtils.COLOR_GRAY_AAAAAA[12],
                              filled: true,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 6, horizontal: 12),
                              border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                borderSide: BorderSide.none,
                              ),
                              hintText: 'Search movies...'.tr,
                              // hintStyle: ,
                              prefixIcon: Icon(Icons.search),
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: TextButton(
                            onPressed: () {
                              Get.to(
                                () => MoviesScreen(
                                    title:
                                        'Movie related to  ${controller.text}',
                                    search: controller.text),
                                preventDuplicates: false,
                              );
                            },

                            // label: 'Search',
                            child: Text(
                              "Search",
                            ),
                          ))
                    ],
                  ),
                  // SizedBox(
                  //   height: 40,
                  //   child: TextField(
                  //     onChanged: (value) {
                  //       Get.to(
                  //         () => MoviesScreen(title: 'Search', search: value),
                  //         preventDuplicates: false,
                  //       );
                  //     },
                  //     decoration: InputDecoration(
                  //       // fillColor: ColorUtils.COLOR_GRAY_AAAAAA[12],
                  //       filled: true,
                  //       contentPadding:
                  //           EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                  //       border: OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(8)),
                  //         borderSide: BorderSide.none,
                  //       ),
                  //       hintText: 'input_order_code'.tr,
                  //       // hintStyle: ,
                  //       prefixIcon: Icon(Icons.search),
                  //     ),
                  //     // style: TextStyleUtils.sizeText15Weight400().copyWith(color: ColorUtils.COLOR_GRAY_363636),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.all(14.0),
                  //   child: CupertinoSearchTextField(
                  //     style: TextStyle(color: dTextColor),
                  //     controller: controller,
                  //     onChanged: (value) {
                  //       Get.to(
                  //         () => MoviesScreen(title: 'Search', search: value),
                  //         preventDuplicates: false,
                  //       );
                  //       // Get.to(MoviesScreen(search: value));
                  //     },
                  //     onSubmitted: (value) {
                  //       Get.to(
                  //         () => MoviesScreen(title: 'Search', search: value),
                  //         preventDuplicates: false,
                  //       );
                  //     },
                  //     // autocorrect: true,
                  //   ),
                  // ),
                  SizedBox(
                    height: 25,
                  ),
                  Genres(genres: widget.genreController.genres),
                  Text("For You"),
                  // MovieCarousel(movies: homeController.showCaseMovie),
                  SizedBox(
                    height: 10,
                  ),
                  buildLandscapeMovieList(
                    title: 'Recent',
                    isLoading: widget.homeController.isLoadingNowPlaying.value,
                    movies: widget.homeController.nowPlayingMovies,
                  ),
                  // SizedBox(height: 20),
                  // buildPortraitMovieList(
                  //   title: 'Popular',
                  //   type: 'popular',
                  //   isLoading: widget.homeController.isLoadingPopular.value,
                  //   movies: widget.homeController.popularMovies,
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // buildPortraitMovieList(
                  //   title: 'Upcoming',
                  //   type: 'upcoming',
                  //   isLoading: widget.homeController.isLoadingUpcoming.value,
                  //   movies: widget.homeController.upcomingMovies,
                  // ),
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
            Text('${title}', style: TextStyle(fontSize: 20)),
            InkWell(
              onTap: () {
                Get.to(
                  () => MoviesScreen(title: '${title}', type: 'now_playing'),
                  preventDuplicates: false,
                );
              },
              child: Text(
                'Show All...',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          height: 260,
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return buildLandscapeMovieCard(movie: movies[index]);
                  },
                  separatorBuilder: (content, index) {
                    return SizedBox(width: 10);
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
                    Center(child: CircularProgressIndicator()),
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
                        style: TextStyle(fontSize: 17),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                    SizedBox(width: 5),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 22,
                        ),
                        Text(
                          '${movie.vote}',
                          style: TextStyle(fontSize: 15),
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
            Text('${title}', style: TextStyle(fontSize: 20)),
            InkWell(
              onTap: () {
                Get.to(
                  () => MoviesScreen(title: title, type: type),
                  preventDuplicates: false,
                );
              },
              child: Text(
                'Show All...',
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Container(
          height: 250,
          child: isLoading == true
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    return buildPortraitMovieCard(
                        movie: movies[index], context: context);
                  },
                  separatorBuilder: (content, index) {
                    return SizedBox(width: 10);
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
                  Center(child: CircularProgressIndicator()),
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
            SizedBox(height: 7),
            Text(
              '${movie.title}',
              style: TextStyle(fontSize: 15),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  } // end of buildLandscapeMovieCard

} //end of class
