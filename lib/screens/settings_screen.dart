import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:filmbet/controllers/auth_controller.dart';
import 'package:filmbet/controllers/price_controller.dart';
import 'package:filmbet/screens/favorite_screen.dart';
import 'package:filmbet/screens/login_screen.dart';
import 'package:filmbet/screens/movies_screen.dart';
import 'package:filmbet/screens/register_screen.dart';
import 'package:filmbet/widgets/primary_button.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../models/basicResponse.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  final authController = Get.find<AuthController>();
  final priceController = Get.find<PriceController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(children: <Widget>[buildTopBanner(), buildSettingItems()]),
    );
  }

  Widget buildTopBanner() {
    return Container(
      height: 250,
      color: Colors.amber,
      child: Center(
        child: Text('Account',
            style: TextStyle(fontSize: 25, color: Colors.black)),
      ),
    );
  } // end of TopBanner

  Widget buildSettingItems() {
    return Container(
        padding: const EdgeInsets.all(15),
        child: authController.isLoggedIn.value == true
            ? Column(
                children: <Widget>[
                  if (!authController.user.isSubscribed)
                    ListTile(
                      leading: Icon(Icons.no_accounts),
                      title: Text('Subscribe'),
                      onTap: () {
                        Get.dialog(
                          showDialogSub(),
                        );
                        // authController.logout();
                      },
                    ),
                  if (!authController.user.isSubscribed &&
                      authController.user.rentActive > 1)
                    ListTile(
                      leading: Icon(Icons.move_up_outlined),
                      title: Text('My List'),
                      onTap: () {
                        Get.to(
                          () => MoviesScreen(title: "My Movies", url: true),
                          preventDuplicates: false,
                        );
                        // authController.logout();
                      },
                    ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text('Favorite movies'),
                    onTap: () {
                      Get.to(
                        () => FavoriteScreen(),
                        preventDuplicates: false,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text('Logout'),
                    onTap: () {
                      Get.dialog(
                        Dialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(15),
                            height: 150,
                            width: 300,
                            child: Column(
                              children: <Widget>[
                                Text('Confirm logout',
                                    style: TextStyle(fontSize: 20)),
                                SizedBox(height: 15),
                                Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: PrimaryButton(
                                        label: 'Yes',
                                        onPress: () {
                                          authController.logout();
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: PrimaryButton(
                                        label: 'No',
                                        onPress: () {
                                          Get.back();
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                      // authController.logout();
                    },
                  ),
                ],
              )
            : Column(
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text('Login'),
                    onTap: () {
                      Get.to(
                        () => LoginScreen(),
                        preventDuplicates: false,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person_add),
                    title: Text('Register'),
                    onTap: () {
                      Get.to(
                        () => RegisterScreen(),
                        preventDuplicates: false,
                      );
                    },
                  ),
                ],
              ));
  }

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
              child: const Text('Cancel         '),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Dialog showDialogSub() {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        padding: const EdgeInsets.all(15),
        child: ListView.separated(
          shrinkWrap: true, //just set this property
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          itemCount: priceController.prices.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () async {
                var response = await priceController
                    .subscribe(priceController.prices[index].id);
                if (response.status) {
                  Navigator.pop(context);
                  _showMyDialog(response.message);
                }
              },
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(priceController.prices[index].name,
                                  style: TextStyle(fontSize: 20)),
                              Text(
                                  "For ETB ${priceController.prices[index].price}")
                            ],
                          ),
                        ),
                        Text(priceController.prices[index].description,
                            style: TextStyle(fontSize: 15)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextButton(
                      child: const Text('SUBSCRIBE'),
                      onPressed: () async {
                        var response = await priceController
                            .subscribe(priceController.prices[index].id);
                        if (response.status) {
                          _showMyDialog(response.message);
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          },
          separatorBuilder: (content, index) {
            return SizedBox(width: 10);
          },
        ),
      ),
    );
  } // end of SettingItems
} //end of widget
