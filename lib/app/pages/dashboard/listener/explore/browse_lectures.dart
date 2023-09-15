import 'package:at_tareeq/app/controllers/browse_lectures_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/widgets/interests_list_tiles.dart';
import 'package:at_tareeq/app/widgets/organizations_list_tiles.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BrowseLectures extends GetView<BrowseLecturesController> {
  const BrowseLectures({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.status) {
        case ProcessingStatus.initial:
          return const LoadingScreen();
        case ProcessingStatus.success:
          return SingleChildScrollView(
            child: Column(
              children: [
                OrganizationsListTiles(
                  isLoadingMore: controller.isLoadingMoreOrganizations.value,
                  scrollController: controller.organizationsScrollController,
                  onTap: (org) {
                    Get.toNamed(Routes.USERLECTURES, arguments: {'user': org});
                  },
                  users: controller.organizations,
                  label: 'Organization/Uploaders',
                ),
                InterestsListTiles(
                  interests: controller.sections,
                  label: 'Interests',
                  onTap: (SectionOrInterest interest) {
                    Get.toNamed(Routes.INTERESTLECTURES,
                        arguments: {'interest': interest});
                  },
                ),
                // HorizontalLectureListTiles(
                //   label: 'For You',
                //   lectures: controller.forYouLectures,
                // ),
                // HorizontalLectureListTiles(
                //   label: 'Recomended',
                //   lectures: controller.recomendedLectures,
                // ),
                // HorizontalLectureListTiles(
                //   label: 'Popular',
                //   lectures: controller.popularLectures,
                // ),
                // SizedBox(
                // height: Get.height,
                // child:
                // Expanded(child: LectureList(filter: LecturesFilter.all)),
                // )
              ],
            ),
          );
        case ProcessingStatus.error:
          return ErrorScreen(
            onRetry: () {
              controller.fetchInitialData();
            },
          );
        case ProcessingStatus.loading:
          return const LoadingScreen();
      }
    });
  }
}
