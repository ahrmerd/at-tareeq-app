import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/browse_lectures.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/home/listen_now.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/listener_lecture_list.dart';
import 'package:at_tareeq/app/widgets/my_tab_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerController extends GetxController
    with GetSingleTickerProviderStateMixin {
  TabController? tabController;
  final bottomNavTabIndex = 0.obs;

  final TextEditingController searchController = TextEditingController();

  void changeTabIndex(int index) {
    bottomNavTabIndex.value = index;
  }

  // final List<MyBottomNavigationItem> bottomNavItems = [
  //   MyBottomNavigationItem(
  //       bottomNavBarItem:
  //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
  //       child: Container(
  //         child: Text('ok'),
  //       )
  //       // child: ListenerHome(),
  //       ),
  //   MyBottomNavigationItem(
  //       bottomNavBarItem:
  //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
  //       // child: ListenerHome(),
  //       child: Container(child: Text('ok'))),
  //   MyBottomNavigationItem(
  //       bottomNavBarItem:
  //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
  //       child: Container(child: Text('ok'))
  //       // child: ListenerHome(),
  //       )
  // ];

  final List<MyTab> homeTabs = const [
    MyTab(tab: Tab(text:'Listen Now'), tabView: ListenNow()),
    MyTab(
        tab: Tab(text: ('Routine Lecture')),
        tabView: ListenerLectureList(
          // key: GlobalObjectKey('Routine Lecture'),
          filter: LecturesFilter.routine,
        )),
    MyTab(
        tab: Tab(text: ('Special Lecture')),
        tabView: ListenerLectureList(
          // key: GlobalObjectKey('Special Lecture'),
          filter: LecturesFilter.special,
        )),
    // MyTab(tab: Tab(child: ), tabView: )
  ];

  final List<MyTab> exploreTabs = const [
    MyTab(
      tab: Tab(text: ('Browse Lectures'),
      ),
      tabView: BrowseLectures(),
    ),
    MyTab(
        tab: Tab(text: ('New Lectures'),
        ),
        tabView: ListenerLectureList(
          filter: LecturesFilter.latest,
        )),
    MyTab(
        tab: Tab(text: ('Most Downloaded Lecture'),
        ),
        tabView: ListenerLectureList(
          filter: LecturesFilter.popular,
        )),
  ];

  @override
  void onInit() {
    tabController = TabController(length: homeTabs.length, vsync: this);
    // tabController.
    super.onInit();
  }
}
