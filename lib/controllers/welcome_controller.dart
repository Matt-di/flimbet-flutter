import 'package:get/get.dart';
import 'package:filmbet/screens/genres_screen.dart';
import 'package:filmbet/screens/home_screen.dart';
import 'package:filmbet/screens/movies_screen.dart';
import 'package:filmbet/screens/all_movie_screen.dart';
import 'package:filmbet/screens/settings_screen.dart';

class WelcomeController extends GetxController {
  var currentIndex = 0.obs;
  var screens = [
    HomeScreen(),
    GenresScreen(),
    MoviesScreen(),
    SettingsScreen(),
  ];
} //end of controller
