import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:filmbet/controllers/welcome_controller.dart';

class WelcomeScreen extends StatelessWidget {
  final welcomeController = Get.put(WelcomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: welcomeController.screens[welcomeController.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: welcomeController.currentIndex.value,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.movie),
              label: 'Movie',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box),
              label: 'Account',
            ),
          ],
          onTap: (index) {
            welcomeController.currentIndex.value = index;
          },
        ),
      );
    });
  }
}
