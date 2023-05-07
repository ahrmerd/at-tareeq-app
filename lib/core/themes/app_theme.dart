import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';

// titleTextStyle: TextStyle(
//     color: primaryDarkColor,
//     fontSize: 20,
//     fontWeight: FontWeight.w500)

class AppTheme {
  static final VisualDensity _visualDensity =
      VisualDensity.adaptivePlatformDensity;

  static final commonTheme = ThemeData(
    brightness: Brightness.light,
    visualDensity: _visualDensity,
    primaryColor: primaryColor,
    // iconTheme: const IconThemeData(color: primaryColor),
    // primarySwatch: ,
    appBarTheme: const AppBarTheme(elevation: 0),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: primaryDarkColor,
      unselectedItemColor: primaryLightColor,
      showSelectedLabels: true,
      showUnselectedLabels: false,
    ),
  );

  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    // iconTheme: IconThemeData(color: primaryColor),
    appBarTheme: commonTheme.appBarTheme.copyWith(
      toolbarTextStyle: const TextStyle(color: primaryColor),
      foregroundColor: primaryColor,
      color: Colors.white,
    ),
    tabBarTheme: TabBarTheme(
      indicatorColor: primaryColor, // set the indicator color
    ),
    scaffoldBackgroundColor: lightColor,
    // colorScheme: ColorScheme.light(background: Colors.red),
    iconTheme: commonTheme.iconTheme,
    bottomNavigationBarTheme: commonTheme.bottomNavigationBarTheme.copyWith(),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    appBarTheme: commonTheme.appBarTheme.copyWith(
      color: Colors.black,
    ),
    iconTheme: commonTheme.iconTheme,
    bottomNavigationBarTheme: commonTheme.bottomNavigationBarTheme.copyWith(),
  );
}
