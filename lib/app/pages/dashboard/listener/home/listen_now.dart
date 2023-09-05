import 'package:at_tareeq/app/controllers/listen_now_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/horizontal_lectures_list_tiles.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenNow extends GetView<ListenNowController> {
  const ListenNow({super.key});

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
                HorizontalLectureListTiles(
                  label: 'Recomended',
                  lectures: controller.recomendedLectures,
                ),
                HorizontalLectureListTiles(
                  label: 'Popular',
                  lectures: controller.popularLectures,
                ),
                VerticalLectureListView(
                  // isPrimary: false,
                  // onAddToFavorite: addToFavorite,
                  // onAddToPlaylater: addToPlaylater,
                  label: 'Lectures',
                  lectures: controller.latestLectures,
                ),
                // Expanded(child: ListenerLectureList(filter: LecturesFilter.all)),
                // )
              ],
            ),
          );
        case ProcessingStatus.error:
          return ErrorScreen(
            onRetry: () {
              controller.fetchLectures();
            },
          );
        case ProcessingStatus.loading:
          return const LoadingScreen();
      }
    });
  }
}
