import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/explore/has_lectures_layout.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UserLecturesController extends GetxController
    with StateMixin<List<Lecture>>
    implements HasLecturesController {
  Rx<User?> user = Rxn(Get.arguments['user']);
  int? userId = Get.arguments['userId'];
  // User user = User(id: 1, name: '3', email: 'ee', type: 5, thumb: 's');

  @override
  late Paginator<Lecture> paginator;
  @override
  RxBool isLoadingMore = false.obs;
  @override
  List<Lecture> models = [];
  @override
  ScrollController? scroller;
  // ScrollController scroller = addOnScollFetchMore(() {
  // fetchLectures(false);
  // print('as');
  // });

  // final ScrollController scroller = ScrollController();

  Future setUser() async {
    final userJson = await Dependancies.http.get('users/$userId');
    user.value = User.fromJson(userJson.data['data']);
  }

  @override
  void onInit() {
    if (user.value == null) {
      setUser();
    }
    paginator = LectureRepository()
        .paginator(perPage: 10, query: Query(filters: {'user_id': userId}));
    // scroller?.addListener(() {
    //   print('ssd');
    // });
    scroller = addOnScollFetchMore(() {
      fetchLectures(false);
    });
    fetchLectures(true);
    super.onInit();
  }

  Future<void> refreshLectures() async {
    return fetchLectures(true);
  }

  @override
  Future<void> fetchLectures(bool isAfresh) async {
    try {
      if (isAfresh) {
        change(null, status: RxStatus.loading());
        // List<Lectumodels = [];
        models = await paginator.start();
      } else {
        isLoadingMore.value = true;
        models.addAll(await paginator.fetchNext());
        isLoadingMore.value = false;
      }
      change(models, status: RxStatus.success());
      // models = await LectureRepository().fetchModels(query: {
      //   'filter': {'interest_id': interest.id}
      // });
      // if (models.isEmpty) {
      //   change([], status: RxStatus.empty());
      // } else {
      // }
    } on Exception catch (e) {
      Dependancies.errorService
          .addStateMixinError(stateChanger: change as dynamic, exception: e);
    }
  }
}
