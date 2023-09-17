import 'package:at_tareeq/app/controllers/pagination_controller.dart';
import 'package:at_tareeq/app/data/enums/library_type.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/library_item.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:dio/dio.dart';
import 'package:flutter/src/widgets/scroll_controller.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController
    with StateMixin<List<LibraryItem>>
    implements PaginationController<LibraryItem> {
  LibraryType libraryType = Get.arguments['type'];

  @override
  void onInit() async {
    setUp();
    await fetchModels(true);

    super.onInit();
  }

  // Future addToFavorite(Lecture lecture) async {
  //   await ApiClient.getInstance().req.post('favorites', data: {
  //     'lecture_id': lecture.id,
  //   });
  // }

  // Future addToPlaylater(Lecture lecture) async {
  //   await ApiClient.getInstance().req.post('playlaters', data: {
  //     'lecture_id': lecture.id,
  //   });
  // }

  @override
  Future<void> fetchModels(bool isAfresh) async {
    try {
      if (isAfresh) {
        change(null, status: RxStatus.loading());
        // List<Lectumodels = [];
        models = await paginator.start();
      } else {
        _isloadingMore.value = true;
        models.addAll(await paginator.fetchNext());
        _isloadingMore.value = false;
      }
      change(models, status: RxStatus.success());
    } on Exception catch (e) {
      Dependancies.errorService
          .addStateMixinError(stateChanger: change as dynamic, exception: e);
    }
  }

  @override
  List<LibraryItem> models = [];

  @override
  late Paginator<LibraryItem> paginator;

  @override
  ScrollController? scroller;

  final RxBool _isloadingMore = false.obs;

  @override
  bool get isLoadingMore => _isloadingMore.value;

  void setUp() {
    String url;
    switch (libraryType) {
      case LibraryType.history:
        url = 'histories';
        break;
      case LibraryType.playLater:
        url = 'playlaters';
        break;
      case LibraryType.favorite:
        url = 'favorites';
        break;
    }
    paginator = LibraryRepository().paginator(
        customPath: url, perPage: 10, query: {'sort': '-updated_at'});
    scroller = addOnScollFetchMore(() {
      fetchModels(false);
    });
    // fetchLectures(true);
  }
}
      // switch (libraryType) {
      //   case LibraryType.history:
      //     break;
      //   case LibraryType.playLater:
      //     SharedPreferencesHelper.addLecturesToPlaylaters(models);
      //     break;
      //   case LibraryType.favorite:
      //     SharedPreferencesHelper.addLecturesToFavorites(models);
      //     break;
      // }
