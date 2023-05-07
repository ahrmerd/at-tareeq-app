import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class InterestLecturesController extends GetxController
    with StateMixin<List<Lecture>> {
  SectionOrInterest interest = Get.arguments['interest'];

  Future<void> fetchLectures() async {
    try {
      change(null, status: RxStatus.loading());
      List<Lecture> models = [];
      models = await LectureRepository().fetchModels(query: {
        'filter': {'interest_id': interest.id}
      });
      if (models.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(models, status: RxStatus.success());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Lectures'));
      ApiClient.showErrorDialogue(e);
      print(e);
    } catch (err) {
      print(err);
      showErrorDialogue();
      change(null, status: RxStatus.error('Failed to Load Lecturers'));
    }
  }

  @override
  void onInit() {
    fetchLectures();
    super.onInit();
  }

  // Future addToFavorite(Lecture lecture) async {
  //   await Dependancies.http().post('favorites', data: {
  //     'lecture_id': lecture.id,
  //   });
  // }

  // Future addToPlaylater(Lecture lecture) async {
  //   await Dependancies.http().post('playlaters', data: {
  //     'lecture_id': lecture.id,
  //   });
  // }
}
