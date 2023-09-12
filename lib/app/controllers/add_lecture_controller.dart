import 'dart:io';

import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/section_or_interest.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/section_interest_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:audioplayers/audioplayers.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart' as Dio;
// import 'package:flutter_sound/flutter_sound.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record/record.dart';

class AddLectureController extends GetxController
    with StateMixin<List<SectionOrInterest>> {
// final recorder = FlutterSoundRecorder();
  PermissionStatus permissionStatus = PermissionStatus.restricted;
  Rx<ProcessingStatus> processingStatus = ProcessingStatus.initial.obs;
  Rx<RecordingStatus> recordingStatus = RecordingStatus.notRecording.obs;
  Rx<PlayingStatus> playingStatus = PlayingStatus.stopped.obs;
  String recordingsPath = '';
  String filePath = '';
  final recorder = Record();
  final player = Dependancies.audioPlayer();

  RxBool recorderReady = false.obs;
  Rx<File?> file = Rxn<File>(null);

  AddLectureMode mode = tryMapCast(
      map: Get.arguments, key: 'mode', fallback: AddLectureMode.uploading);

  @override
  void onInit() {
    initRecorder();
    initSections();
    super.onInit();
  }

  Future<void> initRecorder() async {
    // print(await recorder.hasPermission());
    await requestPermissions();
    if (permissionStatus.isGranted) {
      recorderReady.value = await ensureRecordingFolderExists();
      filePath = getFilePath();
    }
    // recorder.setSubscriptionDuration(500.milliseconds);
  }

  String getFilePath() {
    return '$recordingsPath${Platform.pathSeparator}at_tareeq_${DateTime.now().microsecondsSinceEpoch}.m4a';
  }

  Future<bool> ensureRecordingFolderExists() async {
    final path = await getStoragePath('at-tareek');
    // print(path);

    if (path != null) {
      recordingsPath = path;
      Directory recordingsFolder = Directory(recordingsPath);
      bool recordingFolderExists = await recordingsFolder.exists();
      if (!recordingFolderExists) {
        recordingsFolder.create(recursive: true);
        // return true;
      }
      return true;
    }
    return false;
  }

  Future<void> requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      permissionStatus = await Permission.microphone.request();
      if (permissionStatus.isGranted) {
        permissionStatus = await Permission.storage.request();
      }
    } else {
      permissionStatus = PermissionStatus.granted;
    }
  }

  Future startRecord() async {
    if (await recorder.hasPermission() && recorderReady.value) {
      await recorder.start(path: filePath);
      recordingStatus.value = RecordingStatus.recording;
    } else {
      Get.defaultDialog(
          title: 'unable to start recording',
          middleText:
              'please accept all permissions requests; it you have previously denied the permissions. go to your device settings. check the app settings and provide alll the required permissions',
          onConfirm: () => Get.back());
      // Get.showSnackbar(GetSnackBar(
      // title: 'unable to start recording',
      // message: 'please accept all permissions',
      // ))
      //no permissions
    }
  }

  Future stopRecord() async {
    if (await recorder.isRecording() || await recorder.isPaused()) {
      final path = await recorder.stop();
      recordingStatus.value = RecordingStatus.doneRecording;
      if (path != null) {
        file.value = File(path);
      }
    }
  }

  Future pauseRecord() async {
    if (await recorder.isRecording()) {
      await recorder.pause();
      recordingStatus.value = RecordingStatus.pausedRecording;
    }
  }

  Future continueRecord() async {
    if (await recorder.isPaused()) {
      await recorder.resume();
      recordingStatus.value = RecordingStatus.recording;
    }
  }

  Future<void> restartRecord() async {
    file.value = null;
    recordingStatus.value = RecordingStatus.notRecording;
    await initRecorder();
    // startRecord();
  }

  void playFile() async {
    if (file.value != null) {
      playingStatus.value = PlayingStatus.waiting;
      await player.setSource(DeviceFileSource(file.value!.path));
      player.resume();
      playingStatus.value = PlayingStatus.playing;
    }

    // playingLecture = lecture;
  }

  Future pauseFile() async {
    await player.pause();
    playingStatus.value = PlayingStatus.paused;
  }

  Future stopPlayingFile() async {
    await player.stop();
    playingStatus.value = PlayingStatus.stopped;
  }

  void createLecture({required String name, required int sectionId}) {}

  bool validate(String title, int sectionId) {
    if (file.value != null) {
      return (title.isNotEmpty && sectionId != 0);
    } else {
      return false;
    }
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
    } on Dio.DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Sections'));
      ApiClient.showErrorDialogue(e);
      print(e);
    } catch (err) {
      print(err);
      showErrorDialogue();
      change(null, status: RxStatus.error('Failed to Load Section'));
    }
  }

  Future<void> submitForm(
      String title, int sectionId, String description) async {
    if (validate(title, sectionId)) {
      if (await recorder.isRecording()) {
        await recorder.stop();
        // recorder.dispose()
      }
      try {
        change([], status: RxStatus.loading());
        // print('we reach here');
        final formFile = await Dio.MultipartFile.fromFile(file.value!.path);
        Dio.FormData formData = Dio.FormData.fromMap(
            {'title': title, 'interest_id': sectionId, 'file': formFile});
        await Dependancies.http().post('lectures', data: formData);
        Get.back();
        // createLecture(name: name, sectionId: sectionId)
      } on Dio.DioError catch (e) {
        print(e);
        change(null, status: RxStatus.error('Failed to Upload '));
        ApiClient.showErrorDialogue(e);
        print(e);
      } catch (err) {
        print(err);
        showErrorDialogue();
        change(null, status: RxStatus.error('Failed to Upload'));
      }
    } else {
      showDialogue(
          title: 'Warning',
          message:
              'Please Upload or Record a Lecture and fill all the required fields');
    }
  }

  Future<List<SectionOrInterest>> getSections() {
    return SectionOrInterestRepository().fetchModels();
    // return sectionOrInterestListFromJson(
    //     (await (ApiClient.getInstance().req.get('interests'))).data['data']);
  }

  refetchSections() {
    initSections();
  }
}

enum AddLectureMode { uploading, recording, live }

enum RecordingStatus { notRecording, recording, doneRecording, pausedRecording }
