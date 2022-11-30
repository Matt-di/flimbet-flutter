import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:filmbet/controllers/base_controller.dart';
import 'package:filmbet/controllers/genre_controller.dart';
import 'package:filmbet/controllers/price_controller.dart';
import 'package:filmbet/models/user.dart';
import 'package:filmbet/responses/user_response.dart';
import 'package:filmbet/screens/welcome_screen.dart';
import 'package:filmbet/services/api.dart';

class AuthController extends GetxController with BaseController {
  final genreController = Get.put(GenreController());
  final priceController = Get.put(PriceController());
  late User user;
  var isLoggedIn = false.obs;

  @override
  void onInit() async {
    await genreController.getGenres();
    await priceController.getPrices();
    redirect();
    super.onInit();
  }

  Future<void> redirect() async {
    var token = await GetStorage().read('login_token');
    if (token != null) {
      getUser();
    }

    Get.off(() => WelcomeScreen());
  } //end of redirect

  Future<void> login({required Map<String, dynamic> loginData}) async {
    showLoading();
    var response = await Api.login(loginData: loginData);
    var userResponse = UserResponse.fromMap(response.data);

    await GetStorage().write('login_token', userResponse.token);
    user = userResponse.user;
    isLoggedIn.value = true;

    hideLoading();

    Get.offAll(() => WelcomeScreen());
  } //end of login

  Future<void> register({required Map<String, dynamic> registerData}) async {
    showLoading();
    var response = await Api.register(registerData: registerData);
    var userResponse = userResponseFromMap(response.data);

    await GetStorage().write('login_token', userResponse.token);
    user = userResponse.user;
    isLoggedIn.value = true;

    hideLoading();

    Get.offAll(() => WelcomeScreen());
  } //end of login

  Future<void> logout() async {
    await GetStorage().remove('login_token');
    isLoggedIn.value = false;
    Get.offAll(() => WelcomeScreen());
  } //end of logout

  Future<void> getUser() async {
    var response = await Api.getUser();
    var userResponse = userResponseFromMap(response.data);
    user = userResponse.user;
    isLoggedIn.value = true;
  } //end of getUser
} //end of controller
