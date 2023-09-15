import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

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
    } on DioError catch (e) {
      _status.value = ProcessingStatus.error;
      print(e);
      ApiClient.showErrorDialogue(e);
    } catch (err) {
      print(err);

      _status.value = ProcessingStatus.error;
      showErrorDialogue();
    }
  }

  Future<List<Lecture>> getLatestLectures() async {
    return LectureRepository().paginate(perPage: 3, query: {"sort": "-created_at"}).start();

    // return LectureRepository().paginate(perPage: 3).start();

    // return LectureRepository().fetchModels(query: {"include": "user", ""});
  }

  Future<List<Lecture>> getPopularLectures() {
    return LectureRepository().paginate(perPage: 3, query: {"sort": "-created_at"}).start();

    return LectureRepository().fetchModels(query: {"include": "user"});
  }

  Future<List<Lecture>> getRecommendedLectures() {
    return LectureRepository().paginate(perPage: 3, query: {"sort": "created_at"}).start();
    // return LectureRepository().paginate(perPage: 3).start();
    // return LectureRepository().fetchModels(query: {"include": "user"});
  }
}
