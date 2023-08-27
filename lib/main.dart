import 'package:at_tareeq/app/my_app.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/dependancies.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.light.copyWith(
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        statusBarIconBrightness: Brightness.light,
        statusBarColor: primaryColor,
      ),
    );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Dependancies.init();
  FlutterNativeSplash.remove();
  runApp(const MyApp());
}
