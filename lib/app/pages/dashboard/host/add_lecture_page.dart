import 'dart:io';

import 'package:at_tareeq/app/controllers/add_lecture_controller.dart';
import 'package:at_tareeq/app/widgets/lecture_detail_form.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_sound/flutter_sound.dart';

import 'package:get/get.dart';

class AddLecturePage extends GetView<AddLectureController> {
  const AddLecturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: lightColor,
        title: const Text('Add Lecture'),
        backgroundColor: primaryColor,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (controller.mode == AddLectureMode.recording)
              RecorderWidget(controller: controller),
            if (controller.mode == AddLectureMode.uploading)
              FileUploadWidget(controller: controller),
            const VerticalSpace(20),
            FileControls(controller: controller),
            controller.obx(
              (state) {
                return LectureDetailsForm(
                  onSubmit: (title, sectionId, description, _) {
                    controller.submitForm(
                      title,
                      sectionId,
                      description,
                    );
                  },
                  sections: state!,
                );
              },
              onLoading: const LoadingScreen(),
              onError: (err) => ErrorScreen(
                messsage: err,
                onRetry: controller.refetchSections,
              ),
              onEmpty: EmptyScreen(
                  onRetry: controller.refetchSections,
                  message:
                      'There are no interest, you wont be able to add a lecture please contact admin to add some interest'),
            ),
          ],
        ),
      ),
    );
  }
}

class FileControls extends StatelessWidget {
  const FileControls({
    super.key,
    required this.controller,
  });

  final AddLectureController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.grey),
      child: Obx(() {
        return controller.file.value != null
            ? SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    PlayButton(
                      playingStatus: controller.playingStatus.value,
                      onPlay: () {
                        controller.playFile();
                      },
                      onPause: () {
                        controller.pauseFile();
                      },
                      onStop: () {
                        controller.stopPlayingFile();
                      },
                    ),
                    const HorizontalSpace(),
                    Text(
                      '${getfileBasename(controller.file.value!)}: ',
                      style: bigTextStyle,
                    ),
                  ],
                ),
              )
            : Text(controller.mode == AddLectureMode.uploading
                ? 'No File Selected'
                : 'No Recordings Yet');
      }),
    );
  }
}

class FileUploadWidget extends StatelessWidget {
  const FileUploadWidget({
    super.key,
    required this.controller,
  });

  final AddLectureController controller;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              MyButton(
                onTap: () async {
                  final result = Platform.isIOS
                      ? await FilePicker.platform.pickFiles(
                          type: FileType.custom,
                          allowedExtensions: [
                            'wav',
                            'aiff',
                            'alac',
                            'flac',
                            'mp3',
                            'aac',
                            'wma',
                            'ogg'
                          ],
                        )
                      : await FilePicker.platform
                          .pickFiles(type: FileType.audio);
                  if (result == null) {
                    Get.showSnackbar(GetSnackBar(
                      duration: 2.seconds,
                      backgroundColor: Colors.red.shade200,
                      borderColor: primaryColor,
                      title: 'File not selected',
                      message: 'You didnt select another file',
                    ));
                  } else {
                    if (result.count > 0) {
                      final file = File(result.files.first.path!);
                      controller.file.value = file;
                    }
                  }
                },
                child: const Text('Pick File'),
              )
            ],
          )),
    );
  }
}

class RecorderWidget extends StatelessWidget {
  const RecorderWidget({
    super.key,
    required this.controller,
  });

  final AddLectureController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20))),
      height: Get.height / 3,
      width: Get.width,
      child: Obx(() {
        return Stack(
          alignment: Alignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // StreamBuilder<RecordingDisposition>(
                //     stream: controller.recorder.onProgress,
                //     builder: (_, snapshot) {
                //       final duration = snapshot.hasData
                //           ? snapshot.data!.duration
                //           : 0.milliseconds;
                //       final inMinss = duration.inMinutes
                //           .remainder(60)
                //           .toString()
                //           .padLeft(2, '0');
                //       final inSecs = duration.inSeconds
                //           .remainder(60)
                //           .toString()
                //           .padLeft(2, '0');
                //       return Text('$inMinss:$inSecs');
                //     }),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (controller.recordingStatus.value ==
                        RecordingStatus.notRecording)
                      GestureDetector(
                        onTap: controller.startRecord,
                        child: Container(
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(15),
                            child: const Icon(
                              Icons.mic,
                              size: 42,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      ),
                    const HorizontalSpace(),
                    if (controller.recordingStatus.value ==
                        RecordingStatus.recording)
                      GestureDetector(
                        onTap: controller.pauseRecord,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.pause,
                                size: 25,
                                color: Colors.green,
                              ),
                            )),
                      ),
                    if (controller.recordingStatus.value ==
                        RecordingStatus.pausedRecording)
                      GestureDetector(
                        onTap: controller.continueRecord,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.play_arrow,
                                size: 25,
                                color: Colors.green,
                              ),
                            )),
                      ),
                    const HorizontalSpace(),
                    if (controller.recordingStatus.value ==
                            RecordingStatus.recording ||
                        controller.recordingStatus.value ==
                            RecordingStatus.pausedRecording)
                      GestureDetector(
                        onTap: controller.stopRecord,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.stop,
                                size: 25,
                                color: Colors.red,
                              ),
                            )),
                      ),
                    if (controller.recordingStatus.value ==
                        RecordingStatus.doneRecording)
                      GestureDetector(
                        onTap: controller.restartRecord,
                        child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Colors.grey,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(8),
                              child: const Icon(
                                Icons.restart_alt,
                                size: 25,
                                color: Colors.red,
                              ),
                            )),
                      ),
                  ],
                )
              ],
            ),
            if (controller.recordingStatus.value == RecordingStatus.recording)
              Positioned(
                right: 10,
                bottom: 10,
                child: AvatarGlow(
                  glowColor: Colors.redAccent,
                  glowBorderRadius: BorderRadius.circular(20),
                  child: Container(
                    // height: 30,
                    decoration: const BoxDecoration(shape: BoxShape.circle),
                    child: const Icon(
                      Icons.record_voice_over,
                      color: Colors.red,
                    ),
                  ),
                ),
              )
          ],
        );
      }),
    );
  }
}
