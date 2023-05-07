import 'package:at_tareeq/app/data/enums/lectures_filter.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
// import 'package:audioplayers/audioplayers.dart';
// import 'package:audio/audio.dart';/
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class LectureListController extends GetxController
    with StateMixin<List<Lecture>> {
  ApiClient apiClient = Get.find<ApiClient>();
  // Rx<Lecture?> playingLecture = Rxn<Lecture>();
  // final player = AudioPlayer();
  // final isPlaying = false.obs;

  // Future<void> playAudio(Lecture lecture) async {
  //   playingLecture.value = lecture;
  //   isPlaying.value = true;
  //   await player.setSourceUrl(lecture.url);
  //   // await player.play();
  // }

  // Future<void> pause() async {
  //   isPlaying.value = false;
  //   player.pause();
  // }

  // Future<void> stop() async {
  //   isPlaying.value = false;
  //   player.stop();
  // }

  @override
  void onInit() {
    // fetchLectures(LecturesFilter.all);
    // TODO: implement onInit
    super.onInit();
  }

  Future<void> fetchLectures(LecturesFilter filter) async {
    try {
      change(null, status: RxStatus.loading());
      List<Lecture> models = [];
      switch (filter) {
        case LecturesFilter.all:
          models = await LectureRepository().fetchModels();
          break;
        case LecturesFilter.routine:
          models = await LectureRepository().fetchModels();
          break;
        case LecturesFilter.special:
          models = await LectureRepository().fetchModels();
          break;
        case LecturesFilter.latest:
          models = await LectureRepository().fetchModels();
          break;
        case LecturesFilter.popular:
          models = await LectureRepository().fetchModels();
          break;
      }
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
}
