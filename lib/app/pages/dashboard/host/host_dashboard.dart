import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_home.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_library.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_profile.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostDashboard extends GetView<HostController> {
  const HostDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Obx(() {
        return BottomNavigationBar(
            currentIndex: controller.bottomNavTabIndex.value,
            onTap: controller.changeTabIndex,
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.video_library), label: 'Library'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ]);
      }),
      body: Obx(() => IndexedStack(
            index: controller.bottomNavTabIndex.value,
            children: [
              HostHome(),
              HostLibrary(),
              HostProfile(),
            ],
          )),
    ));
  }
}
