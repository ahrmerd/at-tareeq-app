import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/home/listener_home.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/listener_explore.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/library/listener_library.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/profile/listener_profile.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerDashboard extends GetView<ListenerController> {
  const ListenerDashboard({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      bottomNavigationBar: Obx(() {
        return Container(
          decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(18), topLeft: Radius.circular(18)
          ),
        ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18), topRight: Radius.circular(18),
          ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.shifting,
              iconSize: 28,

                          // backgroundColor: primaryColor,
            selectedItemColor: lightColor,
            unselectedItemColor: Colors.blueGrey.withOpacity(.8),
            // unselectedIconTheme: const IconThemeData(color: darkColor),
            // selectedIconTheme: const IconThemeData(color: lightColor),
              
                currentIndex: controller.bottomNavTabIndex.value,
                onTap: controller.changeTabIndex,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_outlined), label: 'Home',
                    backgroundColor: primaryColor
                    ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.search_outlined), label: 'Explore',
                    backgroundColor: primaryColor

                      ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.video_library), label: 'Library', 
                    backgroundColor: primaryColor
                      ),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person_outline), label: 'Profile',
                    backgroundColor: primaryColor
                      ),
                ]),
          ),
        );
      }),
      body: Obx(() => Stack(
        children: [
          IndexedStack(
            index: controller.bottomNavTabIndex.value,
            children: [
              ListenerHome(),
              ListenerExplore(),
              const ListenerLibrary(),
              const ListenerProfile(),
            ],
          )
        ],
      )),
    ));
  }
}
