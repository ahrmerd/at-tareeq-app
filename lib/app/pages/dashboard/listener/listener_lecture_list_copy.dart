// import 'package:at_tareeq/app/controllers/pagination_controller.dart';
// import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
// import 'package:at_tareeq/app/data/enums/processing_status.dart';
// import 'package:at_tareeq/app/data/models/lecture.dart';
// import 'package:at_tareeq/app/data/providers/api/api_client.dart';
// import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
// import 'package:at_tareeq/app/data/repositories/repository.dart';
// import 'package:at_tareeq/app/dependancies.dart';
// import 'package:at_tareeq/app/pages/async_data_builder.dart';
// import 'package:at_tareeq/app/pages/pagination_builder.dart';
// import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
// import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
// import 'package:at_tareeq/core/utils/dialogues.dart';
// import 'package:at_tareeq/core/utils/helpers.dart';
// import 'package:dio/dio.dart';
// // import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';

// class ListenerLectureList extends StatefulWidget {
//   final LecturesFilter filter;
//   const ListenerLectureList({Key? key, required this.filter}) : super(key: key);

//   @override
//   State<ListenerLectureList> createState() => _ListenerLectureListState();
// }

// class _ListenerLectureListState extends State<ListenerLectureList> {
//   // final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
//   // GlobalKey<RefreshIndicatorState>();
//   // LectureListController get controller => Get.find<LectureListController>();
//   late Future<List<Lecture>> future;
//   ProcessingStatus processingStatus = ProcessingStatus.initial;

//   @override
//   initState() {
//     setUp();
//     fetchModels(true);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PaginationBuilder<Lecture>(
//       paginator: paginator,
//       onSuccess: (scoller, data, isFetchingMore) {
//         // return Placeholder();
//         return VerticalLectureListView(
//           label: 'Lectures',
//           lectures: data as List<Lecture>,
//           isLoadingMore: isFetchingMore,
//           scrollController: scroller,
//         );
//       },
//       // ontest: ({tre = false}) => 1
//     );

//     // AsyncDataBuilder(
//     //   onRefresh: () async {
//     //     fetchModels(true);
//     //   },
//     //   status: processingStatus,
//     //   content: VerticalLectureListView(
//     //     label: 'Lectures',
//     //     lectures: models,
//     //     isLoadingMore: isLoadingMore,
//     //     scrollController: scroller,
//     //     // onAddToFavorite: addToFavorite,
//     //     // onAddToPlaylater: addToPlaylater
//     //   ),
//     // );
//   }

//   @override
//   List<Lecture> models = [];

//   @override
//   late Paginator<Lecture> paginator;

//   @override
//   ScrollController? scroller;

//   @override
//   Future<void> fetchModels(bool isAfresh) async {
//     try {
//       if (isAfresh) {
//         setState(() {
//           processingStatus = ProcessingStatus.loading;
//         });
//         // change(null, status: RxStatus.loading());
//         // List<Lectumodels = [];
//         models = await paginator.start();
//       } else {
//         setState(() {
//           _isLoadingMore = true;
//         });
//         models.addAll(await paginator.fetchNext());
//         setState(() {
//           _isLoadingMore = false;
//         });
//       }
//       setState(() {
//         processingStatus = ProcessingStatus.success;
//       });
//     } on Exception catch (e) {
//       Dependancies.errorService.addError(exception: e);
//       setState(() {
//         processingStatus = ProcessingStatus.success;
//       });
//     }
//   }

//   @override
//   bool get isLoadingMore => _isLoadingMore;
//   bool _isLoadingMore = false;

//   void setUp() {
//     String url = 'lectures';
//     Map<String, dynamic> query = {};
//     switch (widget.filter) {
//       case LecturesFilter.all:
//         break;
//       case LecturesFilter.routine:
//         url = 'lectures/special';
//         break;
//       case LecturesFilter.special:
//         url = 'lectures/routine';
//         break;
//       case LecturesFilter.latest:
//         url = 'lectures';
//         query['sort'] = '-created_at';
//         break;
//       case LecturesFilter.popular:
//         url = 'lectures';
//         query['sort'] = '-downloaded';
//         break;
//     }
//     paginator = LectureRepository()
//         .paginator(customPath: url, perPage: 10, query: query);
//     scroller = addOnScollFetchMore(() {
//       fetchModels(false);
//     });
//     // fetchLectures(true);
//   }
// }

// // Future<List<Lecture>> fetchLectures(LecturesFilter filter) async {
// //   try {
// //     switch (filter) {
// //       case LecturesFilter.all:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.routine:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.special:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.latest:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.popular:
// //         return await LectureRepository().fetchModels();
// //     }
// //   } on DioError catch (e) {
// //     ApiClient.showErrorDialogue(e);
// //     // return [];
// //     rethrow;
// //   } catch (err) {
// //     showErrorDialogue();
// //     rethrow;
// //   }
// // }


// // Future<void> fetchLectures({required LecturesFilter filter, bool refresh = false}) async {
// //   try {
// //     switch (filter) {
// //       case LecturesFilter.all:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.routine:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.special:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.latest:
// //         return LectureRepository().fetchModels();
// //       case LecturesFilter.popular:
// //         return await LectureRepository().fetchModels();
// //     }
// //   } on DioError catch (e) {
// //     ApiClient.showErrorDialogue(e);
// //     // return [];
// //     rethrow;
// //   } catch (err) {
// //     showErrorDialogue();
// //     rethrow;
// //   }
// // }