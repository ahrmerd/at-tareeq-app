import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:get/get.dart';

import '../data/repositories/section_interest_repository.dart';

class AddLiveController extends GetxController with StateMixin {
  Rx<DateTime> scheduledTime = DateTime.now().obs;
  // Rx<ProcessingStatus> sectionsStatus = ProcessingStatus.initial.obs;
  // Rx<ProcessingStatus> submissionStatus = ProcessingStatus.initial.obs;

  Future<List<SectionOrInterest>> getSections() {
    return SectionOrInterestRepository().fetchModels();

    // return sectionOrInterestListFromJson(
    // (await (ApiClient.getInstance().req.get('interests'))).data['data']);
  }

  @override
  void onInit() {
    initSections();
    super.onInit();
  }

  Future initSections() async {
    try {
      change(null, status: RxStatus.loading());
      List<SectionOrInterest> sections = [];

      sections = await getSections();

      if (sections.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(sections, status: RxStatus.success());
      }
    } on Exception catch (e) {
      Dependancies.errorService
          .addStateMixinError(stateChanger: change as dynamic, exception: e);
    }
    // on Dio.DioError catch (e) {

    //   change(null, status: RxStatus.error(ApiClient.getDioErrorMessage(e)));

    //   ApiClient.showErrorDialogue(e);
    // }
    // catch (err) {
    //   showErrorDialogue();
    //   change(null, status: RxStatus.error('Failed to Load Section'));
    // }
  }

  Future<void> submitForm(
      String title, int sectionId, String description, bool isVideo) async {
    if (validate(title, sectionId)) {
      try {
        change([], status: RxStatus.loading());
        // print('we reach here');
        scheduledTime.value.toIso8601String();
        final data = {
          'start_time': scheduledTime.value.toIso8601String(),
          'title': title,
          'interest_id': sectionId,
          'description': description,
          'is_video': isVideo
        };
        final res = await Dependancies.http().post('livestreams', data: data);
        // int id = res.data?['data']['id'];
        final livestream = Livestream.fromJson(res.data['data']);
        // print(id);
        // print(await ApiClient.getInstance().req.get('livestreams/$id'));
        // print(res);
        Get.toNamed(Routes.HOSTLIVE, arguments: {'livestream': livestream});
        // createLecture(name: name, sectionId: sectionId)
      } on Exception catch (e) {
        Dependancies.errorService
            .addStateMixinError(stateChanger: change as dynamic, exception: e);
      }
      //  on Dio.DioError catch (e) {
      // change(null, status: RxStatus.error(ApiClient.getDioErrorMessage(e)));
      //   ApiClient.showErrorDialogue(e);
      //   print(e);
      // } catch (err) {
      //   print(err);
      //   showErrorDialogue();
      //   change(null, status: RxStatus.error('Failed to Create a live session'));
      // }
    } else {
      showDialogue(
          title: 'Warning', message: 'Please fill all the required fields');
    }
  }

  void refetchSections() {
    initSections();
  }

  bool validate(String title, int sectionId) {
    return (title.isNotEmpty && sectionId != 0);
  }
}
