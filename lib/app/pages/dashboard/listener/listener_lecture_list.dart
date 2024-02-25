import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/pages/pagination_builder.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:at_tareeq/app/widgets/vertical_lecture_list_view.dart';

class ListenerLectureList extends StatelessWidget {
  final LecturesFilter filter;
  const ListenerLectureList({super.key, required this.filter});
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
    Query query = Query();
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
        query.addSort('created_at', Sorts.desc);
        break;
      case LecturesFilter.popular:
        url = 'lectures';
        query.addSort('downloaded', Sorts.desc);
        // query['sort'] = '-downloaded';
        break;
    }
    return LectureRepository()
        .paginator(customPath: url, perPage: 10, query: query);
  }
}
