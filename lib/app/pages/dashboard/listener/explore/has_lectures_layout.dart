import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HasLecturesLayout extends StatelessWidget {
  final Widget hasInfoWidget;
  final HasLecturesController controller;
  const HasLecturesLayout(
      {super.key, required this.hasInfoWidget, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      // ),
      body: Stack(
        children: [
          // Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: MyButton(
          //       child: Icon(Icons.arrow_back_rounded),
          //       onTap: () {
          //         print('pressed');
          //         Get.back();
          //       },
          //     )),
          Column(
            children: [
              hasInfoWidget,
              const VerticalSpace(),
              Expanded(
                  child: RefreshIndicator(
                onRefresh: () => controller.fetchLectures(true),
                child: controller.obx(
                    (state) => Obx(() {
                          return VerticalLectureListView(
                            isLoadingMore: controller.isLoadingMore.value,
                            scrollController: controller.scroller,
                            // onAddToFavorite: (lecture) => addToFavorite(lecture),
                            // onAddToPlaylater: (lecture) => addToPlaylater(lecture),
                            label: 'Interest Lecture',
                            lectures: state ?? [],
                          );
                        }),
                    onEmpty: EmptyScreen(onRetry: () {
                      controller.fetchLectures(true);
                    }),
                    onLoading: const LoadingScreen(),
                    onError: (err) => ErrorScreen(
                          messsage: err,
                          onRetry: () {
                            // onRefresh();
                            controller.fetchLectures(true);
                          },
                        )),
              ))
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: MyButton(
                child: Icon(Icons.arrow_back_rounded),
                onTap: () {
                  print('pressed');
                  Get.back();
                },
              )),
        ],
      ),
    );
  }
}

abstract class HasLecturesController implements StateMixin<List<Lecture>> {
  late Paginator<Lecture> paginator;
  RxBool isLoadingMore = false.obs;
  List<Lecture> models = [];
  ScrollController? scroller;

  Future<void> fetchLectures(bool isAfresh);
}
