import 'package:at_tareeq/app/controllers/library_controller.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LibraryLecturesPage extends GetView<LibraryController> {
  const LibraryLecturesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(controller.libraryType.getTitle())),
      body: controller.obx(
        (state) => RefreshIndicator(
          onRefresh: () => controller.fetchModels(true),
          child: Obx(() {
            return VerticalLectureListView(
              lectures: state!.map((e) => e.lecture).toList(),
              label: '',
              isLoadingMore: controller.isLoadingMore,
              scrollController: controller.scroller,
              // onAddToFavorite: addToFavorite,
              // onAddToPlaylater: addToPlaylater,
            );
          }),
        ),
        onEmpty: const EmptyScreen(),
        onError: (error) => ErrorScreen(
          messsage: error,
          onRetry: () {
            controller.fetchModels(true);
          },
        ),
        onLoading: const LoadingScreen(),
      ),
    );
  }
}
