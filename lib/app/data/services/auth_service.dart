import 'package:at_tareeq/app/data/models/user_type.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthService extends GetxService {
  final _signedIn = Rx(false);
  final ApiClient _apiClient = Get.find();
  bool get signedIn => _signedIn.value;

  // static AuthService getAuthServiceInstance() {
  //   return Get.find<AuthService>();
  // }

  Future<AuthService> init() async {
    _signedIn.value = isSignedIn();
    ever(_signedIn, handleAuthChanged);
    // if (_signedIn.value) {
    //   // navigateToAuthRoute();
    // }
    return this;
  }

  bool isSignedIn() {
    final token = SharedPreferencesHelper.getToken();
    return token != null && token.trim() != '';
  }

  Future<bool> checkAuth() async {
    return _signedIn.value;
  }

  void handleAuthChanged(bool isLoggedIn) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (isLoggedIn) {
        navigateToDashboardRoute();
      } else {
        Get.offAllNamed(Routes.LOGIN);
      }
    });
  }

  void navigateToDashboardRoute() {
    int userType = SharedPreferencesHelper.getuserType();
    if (userType == 0) {
      Get.offAllNamed(Routes.ONBOARDING);
    } else if (userType < ServerUserTypes.host) {
      Get.offAllNamed(Routes.LISTENERDASHBOARD);
    } else {
      Get.offAllNamed(Routes.HOSTDASHBOARD);
    }
  }

  static Future<void> signOut() async {
    Dependancies.authService().logout();
  }

  Future<void> logout() async {
    Get.defaultDialog(
        title: 'Loading', content: const CircularProgressIndicator());
    await _apiClient.req.post('logout');
    await SharedPreferencesHelper.clearUserData();
    _signedIn.value = false;

    // _googleSignIn.signOut();
  }

  Future<dio.Response> loginFromData(Map<String, dynamic> data) async {
    final res = await _apiClient.req.post('login', data: data);

    await loginLocally(res.data);
    return res;
  }
  // Future<dio.Response> login(
  //     {required String credential,
  //     required String password,
  //     bool useUsername = false}) async {
  //   final data = {
  //     'password': password,
  //   };
  //   useUsername ? data['username'] = credential : data['email'] = credential;
  //   final res = await _apiClient.req.post('login', data: data);

  //   loginLocally(res.data);

  //   return res;
  // }

  // Future<dio.Response> register({
  //   required String name,
  //   required String email,
  //   required String username,
  //   required String phone,
  //   required String password,
  // }) async {
  //   final data = {
  //     'name': name,
  //     'email': email,
  //     'phone': phone,
  //     'username': username,
  //     'password': password,
  //     'password_confirmation': password,
  //   };
  //   final res = await _apiClient.req.post('register', data: data);
  //   await loginLocally(res.data);
  //   return res;
  // }

  Future<dio.Response?> registerFromData(
      {required Map<String, dynamic> data}) async {
    // try {
    final res = await _apiClient.req.post('register', data: data);
    print(res);

    await loginLocally(res.data);
    return res;
    // } catch (e) {

    // print(e);
    // }
    // return null;
  }

  Future loginLocally(dynamic data) async {
    if (kDebugMode) {
      print(data);
    }
    Map<String, dynamic> userdetails = data['data'];
    var token = data['token'];

    await SharedPreferencesHelper.saveUserDetails(
        id: userdetails['id'],
        name: userdetails['name'],
        email: userdetails['email'],
        userType: dynamicIntParsing(userdetails['type']),
        token: token);
    _apiClient.refreshToken();
    // Get.delete<ApiClient>();
    // Get.put<ApiClient>(ApiClient());
    _signedIn.value = true;
  }
}
