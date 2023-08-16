import 'package:at_tareeq/app/data/providers/api/interceptors/unauthorized_interceptor.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;

class ApiClient {
  // ApiClient._create();
  late Dio req = Dio(_options)..interceptors.add(UnAuthorizedInterceptor());
  // static final ApiClient _client = ApiClient._create();

  void init() {
    req = Dio(_options);
    req.interceptors.add(UnAuthorizedInterceptor());
  }

  // factory ApiClient() => _client;

  // static ApiClient getInstance() => get_x.Get.find<ApiClient>();

  Future<Response?> downloadFile(String url) async {
    try {
      var d = await Dio().get(url,
          options: Options(
            responseType: ResponseType.bytes,
            // followRedirects: false,
          ));
      return d;
    } catch (e) {
      return null;
    }
  }

  static String processError(DioError err) {
    if (err.response?.statusCode == 422) {
      var errorStr = '';
      err.response?.data['errors'].forEach((key, value) {
        if (value is List) {
          errorStr += '${value.join(' , ')}, ';
        }
      });
      return errorStr;
    }
    if (err.type == DioErrorType.unknown) {
      return extractTextBeforeFullStop(err.error ?? "unknown error");
      // err.error.toString().split('.').first;
    }
    return err.message ?? "unknown error";
  }

  void refreshToken() {
    _options.headers['Authorization'] =
        "Bearer ${SharedPreferencesHelper.getToken()}";
    init();
  }

  final BaseOptions _options = BaseOptions(
      baseUrl: apiUrl,
      // baseUrl: "http://127.0.0.1:8000/api/",
      connectTimeout: const Duration(seconds: 300),
      receiveTimeout: const Duration(seconds: 300),
      headers: {
        "Authorization": "Bearer ${SharedPreferencesHelper.getToken()}",
        "Content-Type": "application/json",
        "Accept": "application/json"
      });

  static void showErrorDialogue(DioError e) {
    final errorMessage = processError(e);
    get_x.Get.defaultDialog(
        title: "Network Error",
        middleText: errorMessage,
        actions: [
          TextButton(
            onPressed: () {
              get_x.Get.back();
            },
            child: const Text("Close"),
          ),
        ]);
  }
}
