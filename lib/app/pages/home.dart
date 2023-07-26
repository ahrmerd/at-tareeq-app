import 'package:at_tareeq/app/controllers/home_controller.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomColor.appBlue,
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height / 2,
          width: MediaQuery.of(context).size.width / 2,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/named.png'), fit: BoxFit.scaleDown),
          ),
        ),
      ),
    );
  }
}
