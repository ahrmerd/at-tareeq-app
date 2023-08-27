import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';

class ListenerLectureList extends StatefulWidget {
  final LecturesFilter filter;
  const ListenerLectureList({Key? key, required this.filter}) : super(key: key);

  @override
  State<ListenerLectureList> createState() => _ListenerLectureListState();
}

class _ListenerLectureListState extends State<ListenerLectureList> {
  // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      // GlobalKey<RefreshIndicatorState>();
  // LectureListController get controller => Get.find<LectureListController>();
  late Future<List<Lecture>> future;

  @override
  initState() {
    future = getLectures();
    super.initState();
    // controller.fetchLectures(widget.filter);
  }

  Future<List<Lecture>> getLectures() {
    return fetchLectures(widget.filter);
    // return LectureRepository().fetchModels();
  }

  Future<void> refreshLectures() async {
    setState(() {
      future = getLectures();
    });
    await Future.wait([
    future
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (_, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
            case ConnectionState.active:
              return const LoadingScreen();
            case ConnectionState.done:
              if (snapshot.hasData) {
                return RefreshIndicator(
                  key: Key(widget.filter.toString()),
                  onRefresh: refreshLectures,
                  child: VerticalLectureListView(
                      label: 'Lectures',
                      lectures: snapshot.data!,
                      // onAddToFavorite: addToFavorite,
                      // onAddToPlaylater: addToPlaylater
                      ),
                );
              }
              return ErrorScreen(
                onReturn: refreshLectures,
              );
          }
        });
    // // controller.fetchLectures(filter);
    // return controller.obx((state) {
    //   return RefreshIndicator(
    //       onRefresh: () {
    //         return controller.fetchLectures(widget.filter);
    //       },
    //       child: VerticalLectureListView(
    //         onAddToFavorite: addToFavorite,
    //         onAddToPlaylater: addToPlaylater,
    //         label: 'lectures',
    //         lectures: state ?? [],
    //       ));
    // },
    //     onError: (error) => const ErrorScreen(),
    //     onLoading: const LoadingScreen(),
    //     onEmpty: const EmptyScreen());
  }
}

Future<List<Lecture>> fetchLectures(LecturesFilter filter) async {
  try {
    switch (filter) {
      case LecturesFilter.all:
        return LectureRepository().fetchModels();
      case LecturesFilter.routine:
        return LectureRepository().fetchModels();
      case LecturesFilter.special:
        return LectureRepository().fetchModels();
      case LecturesFilter.latest:
        return LectureRepository().fetchModels();
      case LecturesFilter.popular:
        return await LectureRepository().fetchModels();
    }
  } on DioError catch (e) {
    ApiClient.showErrorDialogue(e);
    // return [];
    rethrow;
  } catch (err) {
    showErrorDialogue();
    rethrow;
  }
}
