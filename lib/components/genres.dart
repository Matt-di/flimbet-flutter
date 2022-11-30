import 'package:flutter/material.dart';
import 'package:filmbet/models/genre.dart';
import 'package:get/get.dart';

import '../../../constants.dart';
import '../controllers/genre_controller.dart';
import '../screens/movies_screen.dart';

class Genres extends StatelessWidget {
  final RxList<Genre> genres;
  Genres({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: kDefaultPadding / 2),
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        itemBuilder: (context, index) =>
            GenreCard(genre: genres[index], index: index),
      ),
    );
  }
}

class GenreCard extends StatelessWidget {
  final Genre genre;
  final int index;

  const GenreCard({Key? key, required this.genre, required this.index})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => {
        Get.to(
          () => MoviesScreen(title: '${genre.name}', genreId: genre.id),
          preventDuplicates: false,
        ),
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: kDefaultPadding),
        padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding,
          vertical: kDefaultPadding / 4, // 5 padding top and bottom
        ),
        decoration: BoxDecoration(
          color: Colors.primaries[index],
          border: Border.all(color: Colors.black26),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          genre.name,
          style: TextStyle(color: dTextColor.withOpacity(0.8), fontSize: 16),
        ),
      ),
    );
  }
}
