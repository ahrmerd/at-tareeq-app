import 'package:at_tareeq/app/controllers/library_controller.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
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
        (state) => VerticalLectureListView(
          lectures: state!,
          label: '',
          onAddToFavorite: addToFavorite,
          onAddToPlaylater: addToPlaylater,
        ),
        onEmpty: const EmptyScreen(),
        onError: (error) => const ErrorScreen(),
        onLoading: const LoadingScreen(),
      ),
    );
  }
}
