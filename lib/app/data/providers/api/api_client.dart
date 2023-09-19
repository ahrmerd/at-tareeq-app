import 'package:at_tareeq/app/data/providers/api/interceptors/require_update_interceptor.dart';
import 'package:at_tareeq/app/data/providers/api/interceptors/unauthorized_interceptor.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as get_x;

class ApiClient {
  // ApiClient._create();
  late Dio req = Dio(_options)
    ..interceptors.addAll(
        [UnAuthorizedInterceptor(), RequireUpdateOrMaintenanceInterceptor()]);
  // static final ApiClient _client = ApiClient._create();

  static final requestHeaders = {
    "Authorization": "Bearer ${SharedPreferencesHelper.getToken()}",
    "Content-Type": "application/json",
    "Accept": "application/json",
    "X-Client-Version": clientVersion
  };

  void init() {
    req = Dio(_options);
    req.interceptors.add(UnAuthorizedInterceptor());
    req.interceptors.add(RequireUpdateOrMaintenanceInterceptor());
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
    switch (err.type) {
      case DioErrorType.connectionError:
      case DioErrorType.connectionTimeout:
      case DioErrorType.unknown:
        return "Please Check Your Internet connection";
      case DioErrorType.sendTimeout:
        return "We are having problems sending your response";
      case DioErrorType.receiveTimeout:
        return "We are having problems recieving the response from the server";
      case DioErrorType.badCertificate:
        return "There is a problem validating your request";
      case DioErrorType.cancel:
        return "Your request was cancelled";
      case DioErrorType.badResponse:
        if (err.response?.statusCode == 422) {
          var errorStr = '';
          err.response?.data['errors'].forEach((key, value) {
            if (value is List) {
              errorStr += '${value.join(' , ')}, ';
            }
          });
          return errorStr;
        }
    }

    return err.message ??
        extractTextBeforeFullStop(err.error ?? "unknown error");
    // if (err.response?.statusCode == 422) {
    //   var errorStr = '';
    //   err.response?.data['errors'].forEach((key, value) {
    //     if (value is List) {
    //       errorStr += '${value.join(' , ')}, ';
    //     }
    //   });
    //   return errorStr;
    // }
    // if (err.type == DioErrorType.unknown) {
    //   return extractTextBeforeFullStop(err.error ?? "unknown error");
    //   // err.error.toString().split('.').first;
    // }
  }

  void refreshToken() {
    _options.headers['Authorization'] =
        "Bearer ${SharedPreferencesHelper.getToken()}";
    init();
  }

  final BaseOptions _options = BaseOptions(
      baseUrl: apiUrl,
      // baseUrl: "http://127.0.0.1:8000/api/",
      connectTimeout: const Duration(seconds: 60),
      receiveTimeout: const Duration(seconds: 60),
      headers: requestHeaders);

  static String getDioErrorMessage(DioError e) {
    if (e.type == DioErrorType.connectionTimeout) {
      return "Please Check Your Internet connection";
    }
    return processError(e);
  }

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
