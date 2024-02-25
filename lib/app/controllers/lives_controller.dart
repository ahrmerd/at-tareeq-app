import 'package:at_tareeq/app/controllers/pagination_controller.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/repositories/livestream_repository.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivesController extends GetxController
    with StateMixin<List<Livestream>>
    implements PaginationController<Livestream> {
  // int count = 6;
  @override
  Future<void> onInit() async {
    setUp();
    fetchModels(true);

    // TODO: implement onInit
    super.onInit();
  }

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

  void setUp() {
    // String url;
    // switch (libraryType) {
    //   case LibraryType.history:
    //     url = 'histories';
    //     break;
    //   case LibraryType.playLater:
    //     url = 'playlaters';
    //     break;
    //   case LibraryType.favorite:
    //     url = 'favorites';
    //     break;
    // }
    paginator = LivestreamRepository().paginator(
        perPage: 10, query: Query(includes: ['user'], sorts: ['-updated_at']));
    scroller = addOnScollFetchMore(() {
      fetchModels(false);
    });
    // fetchLectures(true);
  }

  @override
  List<Livestream> models = [];

  @override
  late Paginator<Livestream> paginator;

  @override
  ScrollController? scroller;

  final RxBool _isloadingMore = false.obs;

  @override
  bool get isLoadingMore => _isloadingMore.value;
}
