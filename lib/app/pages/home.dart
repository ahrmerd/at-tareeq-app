import 'package:at_tareeq/app/controllers/home_controller.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: primaryColor,
      child: Center(
        child: Image.asset('assets/splash.png'),
      ),
    );
  }
}
