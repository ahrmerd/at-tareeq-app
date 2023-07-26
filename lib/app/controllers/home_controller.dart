import 'package:at_tareeq/app/dependancies.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // if (AuthService.getAuthServiceInstance().isSignedIn()) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Dependancies.authService().navigateToDashboardRoute();
    });
    // }
  }
}
