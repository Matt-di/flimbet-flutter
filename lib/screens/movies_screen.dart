import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:filmbet/components/movie_card.dart';
import 'package:filmbet/controllers/movie_controller.dart';
import 'package:filmbet/models/movie.dart';
import 'package:filmbet/screens/movie_detail_screen.dart';
import 'package:filmbet/services/api.dart';
import 'package:transparent_image/transparent_image.dart';

class MoviesScreen extends StatefulWidget {
  final String? title;
  final String? type;
  final String? genreId;
  final String? search;
  late bool url = false;

  MoviesScreen(
      {this.title, this.type, this.genreId, this.url = false, this.search});

  @override
  _MoviesScreenState createState() => _MoviesScreenState();
}

class _MoviesScreenState extends State<MoviesScreen> {
  final movieController = Get.put(MovieController());
  final scrollController = ScrollController();

  @override
  void initState() {
    if (widget.url) {
      movieController.getRentedMovies();
    } else
      movieController.getMovies(
        search: widget.search,
        genreId: widget.genreId,
        type: widget.type,
      );

    scrollController.addListener(() {
      var sControllerOffset = scrollController.offset;
      var sControllerMax = scrollController.position.maxScrollExtent - 100;
      var isLoadingPagination = movieController.isLoadingPagination.value;
      var hasMorePages =
          movieController.currentPage.value < movieController.lastPage.value;

      if (sControllerOffset > sControllerMax &&
          isLoadingPagination == false &&
          hasMorePages) {
        movieController.isLoadingPagination.value = true;
        movieController.currentPage.value++;

        movieController.getMovies(
          page: movieController.currentPage.value,
          type: widget.type,
          genreId: widget.genreId,
        );
      }
    });
    super.initState();
  } //end of init state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title ?? "Movies"),
      ),
      body: Obx(() {
        return movieController.isLoading.value == true
            ? Center(child: CircularProgressIndicator())
            : Container(
                padding: const EdgeInsets.all(10),
                child: RefreshIndicator(
                  onRefresh: () {
                    return movieController.getMovies(
                      page: 1,
                      genreId: widget.genreId,
                      type: widget.type,
                    );
                  },
                  child: SingleChildScrollView(
                    controller: scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: movieController.movies.isEmpty
                        ? Text("No Movies found")
                        : Column(
                            children: [
                              GridView.builder(
                                  restorationId: "movie_grid",
                                  scrollDirection: Axis.vertical,
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        (MediaQuery.of(context).size.width ~/
                                                180)
                                            .toInt(),
                                    mainAxisSpacing: 10,
                                  ),
                                  dragStartBehavior: DragStartBehavior.start,
                                  itemCount: movieController.movies.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return MovieCard(
                                        movie: movieController.movies[index]);
                                  }),
                              Visibility(
                                visible:
                                    movieController.isLoadingPagination.value,
                                child: Container(
                                  padding: const EdgeInsets.all(5),
                                  width: 40,
                                  height: 40,
                                  child: const Center(
                                      child: CircularProgressIndicator()),
                                ),
                              ),
                            ],
                          ),
                    // myWidget(context),
                    // ListView.separated(
                    //   scrollDirection: Axis.vertical,
                    //   shrinkWrap: true,
                    //   physics: NeverScrollableScrollPhysics(),
                    //   itemCount: movieController.movies.length,
                    //   itemBuilder: (context, index) {
                    //     return buildMovieItem(
                    //         movieController.movies[index]);
                    //   },
                    //   separatorBuilder: (content, index) {
                    //     return SizedBox(height: 15);
                    //   },
                    // ),
                    //   Visibility(
                    //     visible: movieController.isLoadingPagination.value,
                    //     child: Container(
                    //       padding: const EdgeInsets.all(5),
                    //       width: 40,
                    //       height: 40,
                    //       child: Center(child: CircularProgressIndicator()),
                    //     ),
                    //   ),
                    // ],
                  ),
                ),
                // )
              );
      }),
    );
  } //end of build

  Widget buildMovieItem(Movie movie) {
    return InkWell(
      onTap: () {
        Get.to(
          () => MovieDetailScreen(movie: movie),
          preventDuplicates: false,
        );
      },
      child: SizedBox(
        height: double.infinity, //260
        width: 340,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: double.infinity,
                height: 250, //255 - 55 = 200
                child: Stack(
                  children: <Widget>[
                    Center(child: CircularProgressIndicator()),
                    FadeInImage.memoryNetwork(
                      placeholder: kTransparentImage,
                      image: movie.banner,
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
                        movie.title,
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
  } // end of movieItem
} //end of class
