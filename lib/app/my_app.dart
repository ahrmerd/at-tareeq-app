import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:at_tareeq/app/pages/onboarding.dart';
import 'package:at_tareeq/core/themes/app_theme.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/routes/pages.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
    );
    return GetMaterialApp(
      title: 'At-Tareek',
      transitionDuration: 300.milliseconds,
      defaultTransition: Transition.rightToLeft,
      theme: AppTheme.lightTheme,
      initialRoute: Pages.initial,
      getPages: Pages.routes,
    );
  }
}

// Future<void> initializApp() async {
//   await SharedPreferencesHelper.init();
//   // await AuthService.signOut();
//   Get.put(ApiClient());
//   await Get.putAsync(() => AuthService().init());
// }
