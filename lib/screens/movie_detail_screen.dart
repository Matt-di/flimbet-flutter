import 'dart:async';
import 'dart:io';
import 'package:filmbet/screens/register_screen.dart';
import 'package:filmbet/screens/webapp_scree.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:filmbet/models/actor.dart';
import 'package:filmbet/models/movie.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:video_player/video_player.dart';

import '../controllers/movie_controller.dart';
import '../widgets/primary_button.dart';
import 'actor_screen.dart';

class MovieDetailScreen extends StatefulWidget {
  final Movie movie;

  MovieDetailScreen({required this.movie});

  @override
  _MovieDetailScreenState createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  final movieController = Get.find<MovieController>();
  late VideoPlayerController videoPlayerController;
  late ChewieController chewieController;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    movieController.getActors(movieId: widget.movie.id);
    movieController.getRelatedMovies(movieId: widget.movie.id);
    loadVideoPlayer();
  } //end of init state

  loadVideoPlayer() {
    if (widget.movie.rented) {
      videoPlayerController =
          VideoPlayerController.network(widget.movie.movieUrl);
    } else {
      videoPlayerController =
          VideoPlayerController.network(widget.movie.trailer);
    }
    chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 16 / 9,
      autoInitialize: true,
      autoPlay: false,
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Column(
            children: [
              Text(
                "Cant load the video",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: 280,
            flexibleSpace: FlexibleSpaceBar(
              background: buildTopBanner(movie: widget.movie),
            ),
          ),
          SliverToBoxAdapter(
            child: Obx(() {
              return Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    buildDetails(movie: widget.movie),
                    const SizedBox(height: 18),
                    buildActors(),
                    const SizedBox(height: 18),
                    buildRelatedMovies(),
                  ],
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget buildTopBanner({required Movie movie}) {
    return Expanded(
      child: Chewie(
        controller: chewieController,
      ),
    );
  } // end of TopBanner

  Widget buildDetails({required Movie movie}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Details',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        SizedBox(height: 10),
        Text(
          '${movie.description}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            height: 1.3,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: <Widget>[
            Container(
              width: 120,
              child: Text(
                'Release date:',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text('${movie.releaseDate}',
                style: TextStyle(color: Colors.grey[400])),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: <Widget>[
            Container(
              width: 120,
              child: Text(
                'Renting Price:',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Text(
              '${movie.price}',
              style: TextStyle(color: Colors.grey[400]),
            ),
          ],
        ),
        SizedBox(height: 10),
        !movie.rented
            ? Container(
                width: 120,
                child: PrimaryButton(
                  label: 'Rent',
                  onPress: () async {
                    var response =
                        await movieController.rentMovie(movieId: movie.id);
                    Logger().d("Payment", response.status);
                    if (response.status == true)
                      _showMyDialog(response.message);
                    else {
                      _showModalRegister();
                    }
                    // Get.off(() => PayScreen(url: response.message));
                  },
                ))
            : Container(
                width: 120,
                child: PrimaryButton(
                  label: 'Play',
                  onPress: () {
                    Logger().d("Button Play");
                  },
                )),
      ],
    );
  }

  Future<void> _showModalRegister() {
    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Please registered first to rent a movie',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  child: const Text('Register'),
                  onPressed: () => {
                    Navigator.pop(context),
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterScreen()))
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  } // end of Details

  Future<void> _showMyDialog(String url) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          content: Scaffold(
            // backgroundColor: Colors.green,
            // appBar: AppBar(
            //   title: const Text('Payment Page'),
            //   // This drop down menu demonstrates that Flutter widgets can be shown over the web view.
            //   actions: <Widget>[Icon(Icons.close)],
            // ),
            body: WebView(
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              // onWebViewCreated: (WebViewController webViewController) {
              //   _controller = webViewController;
              // },
              onProgress: (int progress) {
                print('WebView is loading (progress : $progress%)');
              },
              navigationDelegate: (NavigationRequest request) {
                if (request.url.startsWith('https://www.youtube.com/')) {
                  print('blocking navigation to $request}');
                  return NavigationDecision.prevent;
                }
                print('allowing navigation to $request');
                return NavigationDecision.navigate;
              },
              onPageStarted: (String url) {
                print('Page started loading: $url');
              },
              onPageFinished: (String url) {
                print('Page finished loading: $url');
                if (url.contains('/callback')) {
                  // if JavaScript is enabled, you can use
                  // var html = _controller?.evaluateJavascript(
                  //     "window.document.getElementsByTagName('html')[0].outerHTML;");

                  Logger().d("Response callback${url}");
                }
              },
              gestureNavigationEnabled: true,
              backgroundColor: const Color(0x00000000),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close         '),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildActors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Actors',
          style: TextStyle(
            fontSize: 20,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 50,
          child: movieController.isLoadingActors.value
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: movieController.actors.length,
                  itemBuilder: (context, index) {
                    return buildActorItem(actor: movieController.actors[index]);
                  },
                  separatorBuilder: (content, index) {
                    return const SizedBox(width: 15);
                  },
                ),
        ),
      ],
    );
  } // end of Actors

  Widget buildActorItem({required Actor actor}) {
    return InkWell(
      onTap: () {
        Get.to(
          () => ActorScreen(actor: actor),
          preventDuplicates: false,
        );
      },
      child: Container(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Container(
            //   width: 150,
            //   height: 200,
            //   child: Stack(
            //     // alignment: Alignment.bottomLeft,
            //     children: <Widget>[
            //       Center(child: CircularProgressIndicator()),
            //       FadeInImage.memoryNetwork(
            //         placeholder: kTransparentImage,
            //         image: '${actor.image}',
            //         fit: BoxFit.cover,
            //         width: double.infinity,
            //         height: double.infinity,
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(height: 5),
            Text(
              '${actor.name}',
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  } // end of Actor

  Widget buildRelatedMovies() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Related movies',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10),
        Container(
          height: 370,
          child: movieController.isLoadingRelatedMovies.value
              ? Center(child: CircularProgressIndicator())
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: movieController.relatedMovies.length ~/ 2,
                  itemBuilder: (context, index) {
                    int relatedMoviesLength =
                        movieController.relatedMovies.length ~/ 2;
                    return Column(
                      children: <Widget>[
                        //0 .. 4
                        buildRelatedMovieItem(
                            movie: movieController.relatedMovies[index]),
                        SizedBox(height: 20),
                      ],
                    );
                  },
                  separatorBuilder: (content, index) {
                    return SizedBox(width: 10);
                  },
                ),
        )
      ],
    );
  } // end of RelatedMovie

  Widget buildRelatedMovieItem({required Movie movie}) {
    return InkWell(
      onTap: () {
        Get.to(
          () => MovieDetailScreen(movie: movie),
          preventDuplicates: false,
        );
      },
      child: Container(
        width: 350,
        height: 170,
        child: Row(
          children: <Widget>[
            Container(
              width: 120,
              height: double.infinity,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: <Widget>[
                  Center(child: CircularProgressIndicator()),
                  FadeInImage.memoryNetwork(
                    placeholder: kTransparentImage,
                    image: '${movie.poster}',
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${movie.title}',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Icon(Icons.star, color: Colors.amber),
                      Text('${movie.vote}'),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    '${movie.description}',
                    style: TextStyle(fontSize: 13, color: Colors.grey[400]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Wrap(
                    spacing: 5,
                    runSpacing: -13,
                    children: [
                      ...movie.genres.take(3).map(
                        (genre) {
                          return Chip(
                            label: Text('${genre.name}',
                                style: TextStyle(fontSize: 11)),
                          );
                        },
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  } // end of RelatedMovieItem
} //end of widget
