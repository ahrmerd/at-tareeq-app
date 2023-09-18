import 'package:at_tareeq/app/controllers/pagination_controller.dart';
import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/async_data_builder.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:dio/dio.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';

class ListenerLectureList extends StatelessWidget {
  final LecturesFilter filter;
  const ListenerLectureList({Key? key, required this.filter}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PaginationBuilder<Lecture>(
      paginator: getPaginator(),
      onSuccess: (scroller, data, isFetchingMore, toRefresh) {
        // return Placeholder();
        return VerticalLectureListView(
          label: 'Lectures',
          lectures: data,
          isLoadingMore: isFetchingMore,
          scrollController: scroller,
        );
      },
      // ontest: ({tre = false}) => 1
    );

    // AsyncDataBuilder(
    //   onRefresh: () async {
    //     fetchModels(true);
    //   },
    //   status: processingStatus,
    //   content: VerticalLectureListView(
    //     label: 'Lectures',
    //     lectures: models,
    //     isLoadingMore: isLoadingMore,
    //     scrollController: scroller,
    //     // onAddToFavorite: addToFavorite,
    //     // onAddToPlaylater: addToPlaylater
    //   ),
    // );
  }

  Paginator<Lecture> getPaginator() {
    String url = 'lectures';
    Map<String, dynamic> query = {};
    switch (filter) {
      case LecturesFilter.all:
        break;
      case LecturesFilter.routine:
        url = 'lectures/special';
        break;
      case LecturesFilter.special:
        url = 'lectures/routine';
        break;
      case LecturesFilter.latest:
        url = 'lectures';
        query['sort'] = '-created_at';
        break;
      case LecturesFilter.popular:
        url = 'lectures';
        query['sort'] = '-downloaded';
        break;
    }
    return LectureRepository()
        .paginator(customPath: url, perPage: 10, query: query);
  }
}
