import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
import 'package:at_tareeq/app/widgets/host_lecture_list.dart';
import 'package:flutter/material.dart';

class HostLibrary extends StatefulWidget {
  const HostLibrary({super.key});

  @override
  State<HostLibrary> createState() => _HostLibraryState();
}

class _HostLibraryState extends State<HostLibrary> {
  // late Future<bool> future;
  Paginator<Lecture> paginator =
      LectureRepository().paginator(customPath: 'lectures/user', perPage: 8);
  // VoidCallback? refresh;

  // future = getLectures();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Lectures')),
      body: PaginationBuilder(
        paginator: paginator,
        onSuccess: (scrollController, data, isFetchingMore, toRefresh) {
          // refresh = toRefresh;
          return HostLecturesList(
            isLoadingMore: isFetchingMore,
            scrollController: scrollController,
            lectures: data,
            onRefresh: () {
              toRefresh.call();
              // setState(() {});
            },
          );
        },
      ),

      // body: Builder(builder: (_) {
      //   switch (processingStatus) {
      //     case ProcessingStatus.initial:
      //     case ProcessingStatus.loading:
      //       return const LoadingScreen();
      //     case ProcessingStatus.error:
      //       return ErrorScreen(
      //         onRetry: refreshLectures,
      //       );
      //     case ProcessingStatus.success:
      //       return RefreshIndicator(
      //         // key: Key(widget.filter.toString()),
      //         onRefresh: refreshLectures,
      //         child: HostLecturesList(
      //           isLoadingMore: isFetchingMore,
      //           scrollController: scrollController,
      //           lectures: data,
      //           onRefresh: refreshLectures,
      //         ),
      //       );
      //   }
      // })

      // FutureBuilder(
      //     future: future,
      //     builder: (_, snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.waiting:
      //         case ConnectionState.none:
      //         case ConnectionState.active:
      //           return const LoadingScreen();
      //         case ConnectionState.done:
      //           if (snapshot.hasData) {
      //             return RefreshIndicator(
      //               // key: Key(widget.filter.toString()),
      //               onRefresh: refreshLectures,
      //               child: HostLecturesList(
      //                 scrollController: scrollController,
      //                 lectures: data,
      //                 onRefresh: refreshLectures,
      //               ),
      //             );
      //           }
      //           return ErrorScreen(
      //             onRetry: refreshLectures,
      //           );
      //       }
      //     }),
    );
  }
}

  // Future<bool> fetchLectures([bool isAfresh = false]) async {
  //   try {
  //     if (isAfresh) {
  //       setState(() {
  //         processingStatus = ProcessingStatus.loading;
  //       });
  //       data = await paginator.start();
  //       setState(() {
  //         processingStatus = ProcessingStatus.success;
  //       });
  //     } else if (paginator.hasRemainingData) {
  //       setState(() {
  //         isFetchingMore = true;
  //       });
  //       data.addAll(await paginator.fetchNext());
  //       setState(() {
  //         isFetchingMore = false;
  //       });
  //     }
  //     // setState(() {
  //     //   processingStatus = ProcessingStatus.success;
  //     // });
  //     return true;
  //     // return data;

  //     // return await LectureRepository()
  //     // .fetchModelsFromCustomPath('lectures/user');
  //   } on Exception catch (e) {
  //     final errorMessage = Dependancies.errorService.addError(exception: e);
  //     setState(() {
  //       processingStatus = ProcessingStatus.error;
  //     });
  //     return Future.error(errorMessage);
  //     // rethrow;
  // }
// }
