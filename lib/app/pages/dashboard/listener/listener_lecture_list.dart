import 'package:at_tareeq/app/controllers/lecture_list_controller.dart';
import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';

class ListenerLectureList extends StatefulWidget {
  final LecturesFilter filter;
  const ListenerLectureList({Key? key, required this.filter}) : super(key: key);

  @override
  State<ListenerLectureList> createState() => _ListenerLectureListState();
}

class _ListenerLectureListState extends State<ListenerLectureList> {
  LectureListController get controller => Get.find<LectureListController>();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchLectures(widget.filter);
    });
    // controller.fetchLectures(widget.filter);
  }

  @override
  Widget build(BuildContext context) {
    // controller.fetchLectures(filter);
    return controller.obx((state) {
      return RefreshIndicator(
          onRefresh: () {
            return controller.fetchLectures(widget.filter);
          },
          child: VerticalLectureListView(
            onAddToFavorite: addToFavorite,
            onAddToPlaylater: addToPlaylater,
            label: 'lectures',
            lectures: state ?? [],
          ));
    },
        onError: (error) => const ErrorScreen(),
        onLoading: const LoadingScreen(),
        onEmpty: const EmptyScreen());
  }
}
