import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:filmbet/screens/movie_detail_screen.dart';
import '../../../constants.dart';
import '../models/movie.dart';

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({Key? key, required this.movie}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
      child: OpenContainer(
        closedElevation: 0,
        openElevation: 0,
        closedBuilder: (context, action) => buildMovieCard(context),
        openBuilder: (context, action) => MovieDetailScreen(movie: movie),
      ),
    );
  }

  Column buildMovieCard(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Container(
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              boxShadow: const [kDefaultShadow],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  movie.poster,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Center(
          heightFactor: 0.6,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(movie.title,
                style: const TextStyle(fontSize: 14, color: kTextColor)),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.star,
              color: Colors.amber,
              size: 22,
            ),
            const SizedBox(width: kDefaultPadding / 2),
            Text(
              "Rate ${movie.rating}",
              style: const TextStyle(fontSize: 13, color: kTextColor),
            ),
            const SizedBox(width: kDefaultPadding),
            Text(
              movie.releaseDate,
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.bold, color: kTextColor),
            )
          ],
        ),
      ],
    );
  }
}
