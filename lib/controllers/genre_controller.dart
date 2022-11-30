import 'dart:convert';

import 'package:get/get.dart';
import 'package:filmbet/models/genre.dart';
import 'package:filmbet/responses/genre_response.dart';
import 'package:filmbet/services/api.dart';

class GenreController extends GetxController {
  var genres = <Genre>[].obs;

  Future<void> getGenres() async {
    var response = await Api.getGenres();
    //var genreResponse = GenreResponse.fromJson(response.data);
    var strData = jsonEncode(response.data);
    final gener = genreFromJson(strData);

    genres.clear();
    genres.addAll(gener);
  } //end of getGenres

} //end of controller
