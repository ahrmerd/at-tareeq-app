import 'package:at_tareeq/app/controllers/add_lecture_controller.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/logger.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:dio/dio.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostController extends GetxController with StateMixin<List<Lecture>> {
  final bottomNavTabIndex = 0.obs;
  // late AnimationController animationController;
  final animationDuration = 200.milliseconds;
  final isExpanded = false.obs;
  ExpandableController expandableController = ExpandableController(
    initialExpanded: true,
  );

  final List<HostAction> hostActions = [
    HostAction('Record Lecture',
        icon: const Icon(
          Icons.mic_none_rounded,
          size: actionIconSize,
          color: Colors.green,
        ), onTap: () {
      Get.toNamed(Routes.ADDLECTURE,
          arguments: {'mode': AddLectureMode.recording});
    }),
    HostAction('Upload Lecture',
        icon: const Icon(
          Icons.upload_rounded,
          size: actionIconSize,
          color: Colors.green,
        ), onTap: () {
      Get.toNamed(Routes.ADDLECTURE,
          arguments: {'mode': AddLectureMode.uploading});
    }),
    HostAction('Schedule Livestream',
        icon: const Icon(
          Icons.record_voice_over_outlined,
          size: actionIconSize,
          color: Colors.red,
        ), onTap: () {
      Get.toNamed(Routes.ADDLIVE);
    }),
    HostAction('My Livestreams',
        icon: const Icon(
          Icons.podcasts,
          size: actionIconSize,
          color: Colors.blue,
        ), onTap: () {
      Get.toNamed(Routes.MYLIVE);
    })
  ];
  void changeTabIndex(int index) {
    bottomNavTabIndex.value = index;
  }

  @override
  void onInit() {
    // animationController =
    // AnimationController.unbounded(duration: animationDuration, vsync: this);
    // TODO: implement onInit
    super.onInit();
  }

  Future fetchLectures() async {
    try {
      change(null, status: RxStatus.loading());
      List<Lecture> models = [];
      models = await LectureRepository().fetchModels();
      if (models.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(models, status: RxStatus.success());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Lectures'));
      ApiClient.showErrorDialogue(e);
      Logger.log(e.toString());
    } catch (err) {
      Logger.log(err.toString());
      showErrorDialogue();
      change(null, status: RxStatus.error('Failed to Load Lecturers'));
    }
  }

  @override
  void dispose() {
    // animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  void openMore() {
    isExpanded.value = !isExpanded.value;
    // if (animationController.isCompleted) {
    //   animationController.reverse();
    // } else {
    //   animationController.forward();
    // }
  }
}

class HostAction {
  final String title;
  final Icon icon;
  final VoidCallback? onTap;

  HostAction(this.title, {required this.icon, required this.onTap});
}

const actionIconSize = 40.0;
