import 'package:at_tareeq/app/data/enums/library_type.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class LibraryController extends GetxController with StateMixin<List<Lecture>> {
  LibraryType libraryType = Get.arguments['type'];

  @override
  void onInit() async {
    await fetchLectures();
    // TODO: implement onInit
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

  Future fetchLectures() async {
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
    try {
      change(null, status: RxStatus.loading());
      List<Lecture> models = [];

      // final res = await (ApiClient.getInstance().req.get(url));
      // models = libraryLectureListFromJson(res.data['data']);
      models = await LectureRepository().fetchModelsFromCustomPath(url,
          customTransformer: libraryLectureListFromJson);

      if (models.isEmpty) {
        change(models, status: RxStatus.empty());
      } else {
        change(models, status: RxStatus.success());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Lectures'));
      ApiClient.showErrorDialogue(e);
      print(e);
    } catch (err) {
      print(err);
      showErrorDialogue(err.toString());
      change(null, status: RxStatus.error('Failed to Load Lecturers'));
    }
  }
}
