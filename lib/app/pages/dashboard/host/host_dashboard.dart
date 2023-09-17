import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_home.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_library.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_profile.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'host_home2.dart';

class HostDashboard extends StatefulWidget {
  const HostDashboard({Key? key}) : super(key: key);

  @override
  State<HostDashboard> createState() => _HostDashboardState();
}

class _HostDashboardState extends State<HostDashboard> {
  // final HostController controller = Get.find();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
          backgroundColor: primaryColor,
          selectedItemColor: lightColor,
          unselectedItemColor: darkColor.withOpacity(.8),
          // unselectedIconTheme: IconThemeData(color: Colors.grey),
          // selectedIconTheme: const IconThemeData(color: lightColor),
          currentIndex: _currentIndex,
          onTap: _changeTabIndex,
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_outlined), label: 'Home'),
            BottomNavigationBarItem(
                icon: Icon(Icons.video_library_outlined), label: 'Library'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outlined), label: 'Profile'),
          ]),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          HostHome(),
          HostLibrary(),
          HostProfile(),
        ],
      ),
    );
  }

  _changeTabIndex(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}



// class HostDashboard extends GetView<HostController> {
//   const HostDashboard({Key? key}) : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       bottomNavigationBar: Obx(() {
//         return BottomNavigationBar(
//             backgroundColor: primaryColor,
//             selectedItemColor: lightColor,
//             unselectedItemColor: darkColor.withOpacity(.8),
//             // unselectedIconTheme: IconThemeData(color: Colors.grey),
//             // selectedIconTheme: const IconThemeData(color: lightColor),
//             currentIndex: controller.bottomNavTabIndex.value,
//             onTap: controller.changeTabIndex,
//             items: const [
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.home_outlined), label: 'Home'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.video_library_outlined), label: 'Library'),
//               BottomNavigationBarItem(
//                   icon: Icon(Icons.person_outlined), label: 'Profile'),
//             ]);
//       }),
//       body: Obx(() => IndexedStack(
//             index: controller.bottomNavTabIndex.value,
//             children: const [
//               HostHome(),
//               HostLibrary(),
//               HostProfile(),
//             ],
//           )),
//     );
//   }
// }
