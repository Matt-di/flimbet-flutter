import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as GET;
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

class Api {
  static final dio = Dio(
    BaseOptions(
      baseUrl: 'http://10.10.4.119:8000/',
      receiveDataWhenStatusError: true,
    ),
  );

  static void initializeInterceptors() {
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (request, handler) async {
        var token = await GetStorage().read('login_token');

        var headers = {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${token}',
        };

        request.headers.addAll(headers);
        print('${request.method} ${request.path}');
        print('${request.headers}');
        return handler.next(request); //continue
      },
      onResponse: (response, handler) {
        Logger().d('fetched => ${response.data}');
        // if (response.data['error'] == 1) throw response.data['message'];
        return handler.next(response); // continue
      },
      onError: (error, handler) {
        if (GET.Get.isDialogOpen == true) {
          GET.Get.back();
        }
        print('${error}');

        GET.Get.snackbar(
          'error'.tr,
          '${error.message}',
          snackPosition: GET.SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

        return handler.next(error); //continue
      },
    ));
  } // end of initializeInterceptor

  static Future<Response> getGenres() async {
    return dio.get('/api/genres');
  } //end of getGenres

  static Future<Response> getMovies({
    int page = 1,
    String? type,
    String? genreId,
    String? actorId,
    String? search,
  }) async {
    return dio.get('/api/movies', queryParameters: {
      'page': page,
      'type': type,
      'genre_id': genreId,
      'actor_id': actorId,
      "search": search
    });
  } //end of getMovies

  static Future<Response> getRentedMovies({
    int page = 1,
  }) async {
    return dio.get('/api/movies/rent', queryParameters: {'page': page});
  }

  static Future<Response> getShowcaseMovies({
    int page = 1,
  }) async {
    return dio.get('/api/movies/show', queryParameters: {'page': page});
  }

  static Future<Response> getActors({required String movieId}) async {
    return dio.get('/api/movies/${movieId}/actors');
  } //end of actors

  static Future<Response> getRelatedMovies({required String movieId}) async {
    return dio.get('/api/movies/${movieId}/related_movies');
  } //end of actors

  static Future<Response> login(
      {required Map<String, dynamic> loginData}) async {
    FormData formData = FormData.fromMap(loginData);
    return dio.post('/api/login', data: loginData);
  } //end of login

  static Future<Response> register(
      {required Map<String, dynamic> registerData}) async {
    FormData formData = FormData.fromMap(registerData);
    return dio.post('/api/register', data: formData);
  } //end of register

  static Future<Response> getUser() async {
    return dio.get('/api/user');
  }

  static Future<Response> rentMovie(String movieId) {
    final params = <String, dynamic>{'movie': movieId};
    return dio.get("/api/pay", queryParameters: params);
  } //end of getUser

  static Future<Response> getPrice() {
    return dio.get("/api/prices");
  }

  static Future<Response> subscribe(String id) {
    final params = <String, dynamic>{'price': id};
    return dio.get("/api/subscribe", queryParameters: params);
  }
} //end of api
