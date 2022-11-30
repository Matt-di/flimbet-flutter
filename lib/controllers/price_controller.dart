import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:filmbet/models/basicResponse.dart';
import 'package:filmbet/models/price.dart';
import 'package:filmbet/services/api.dart';

class PriceController extends GetxController {
  List<Price> prices = [];

  Future<void> getPrices() async {
    var response = await Api.getPrice();
    //var genreResponse = GenreResponse.fromJson(response.data);
    var strData = jsonEncode(response.data);
    final price = priceFromMap(strData);
    prices.clear();
    prices.addAll(price);
  }

  Future<BasicResponse> subscribe(String id) async {
    var response = await Api.subscribe(id);
    BasicResponse basicResponse = basicResponseFromJson(response.toString());
    return basicResponse;
  } //end of getGenres

} //end of controller
