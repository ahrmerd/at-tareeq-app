import 'package:at_tareeq/app/data/models/onboarding_page_item.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class OnBoardingController extends GetxController {
  final onPageIndex = 0.obs;

  bool get isLastPage => onPageIndex.value == onBoardingPages.length - 1;
  final pageController = PageController();

  void navigateToNext() {
    Get.offNamed(Routes.SELECTUSER);
  }

  Future<void> forward() async {
    if (isLastPage) {
      navigateToNext();
    } else {
      await pageController.nextPage(
          duration: 300.milliseconds, curve: Curves.linear);
    }
  }

  bool isCurrentPage(int index) {
    return onPageIndex.value == index;
  }

  List<OnBoardingPageItem> onBoardingPages = [
    OnBoardingPageItem(
        imageAsset: 'assets/images/Asset1.png',
        name: 'Listen to Lectures',
        description:
            'Have access to lecturers from your favourite lecturers, mosques, or organizations around you'),
    OnBoardingPageItem(
        imageAsset: 'assets/images/Asset2.png',
        name: 'Upload/Record Lectures',
        description:
            'Be it organization, mosque, or lecturer. you can upload lectures for your audience'),
    OnBoardingPageItem(
        imageAsset: 'assets/images/Asset3.png',
        name: 'Be Notified of a Lecture',
        description: 'Get notified of a lecture happening in your location'),
  ];
}
