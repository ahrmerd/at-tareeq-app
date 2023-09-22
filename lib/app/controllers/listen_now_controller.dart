import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../data/repositories/repository.dart';

class ListenNowController extends GetxController {
  final _status = ProcessingStatus.initial.obs;
  ProcessingStatus get status => _status.value;
  final RxList<Lecture> latestLectures = <Lecture>[].obs;
  final RxList<Lecture> recomendedLectures = <Lecture>[].obs;
  final RxList<Lecture> popularLectures = <Lecture>[].obs;

  @override
  void onInit() {
    fetchLectures();
    super.onInit();
  }

  Future fetchLectures() async {
    try {
      _status.value = ProcessingStatus.loading;
      latestLectures.addAll(await getLatestLectures());
      recomendedLectures.addAll(await getRecommendedLectures());
      popularLectures.addAll(await getPopularLectures());
      _status.value = ProcessingStatus.success;
      latestLectures.refresh();
      recomendedLectures.refresh();
      popularLectures.refresh();
    } on Exception catch (e) {
      Dependancies.errorService.addErrorWithCallback(
          callback: () => _status.value = ProcessingStatus.success,
          exception: e);
    }
  }

  Future<List<Lecture>> getLatestLectures() async {
    return LectureRepository().fetchModels(
        query: Query(sorts: ["-created_at"], limit: 5, includes: ["user"]));
  }

  Future<List<Lecture>> getPopularLectures() {
    return LectureRepository().fetchModels(
        query: Query(sorts: ["-downloaded"], limit: 5, includes: ["user"]));
  }

  Future<List<Lecture>> getRecommendedLectures() {
    return LectureRepository().fetchModelsFromCustomPath('lectures/recommended',
        query: Query(limit: 5, includes: ["user"]));
  }
}
