import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/home/listener_home.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/listener_explore.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/library/listener_library.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/profile/listener_profile.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerDashboard extends GetView<ListenerController> {
  const ListenerDashboard({Key? key}) : super(key: key);
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
                  icon: Icon(Icons.search), label: 'Explore'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.video_library), label: 'Library'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person), label: 'Profile'),
            ]);
      }),
      body: Obx(() => IndexedStack(
            index: controller.bottomNavTabIndex.value,
            children: [
              ListenerHome(),
              ListenerExplore(),
              ListenerLibrary(),
              ListenerProfile(),
            ],
          )),
    ));
  }
}
