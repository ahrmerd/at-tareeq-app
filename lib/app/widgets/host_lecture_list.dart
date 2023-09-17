import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lecture_player.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/host_lecture_item.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
// import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostLecturesList extends StatefulWidget {
  final List<Lecture> lectures;
  final VoidCallback onRefresh;
  final ScrollController? scrollController;
  final bool isLoadingMore;
  const HostLecturesList(
      {super.key,
      required this.lectures,
      required this.onRefresh,
      required this.scrollController,
      this.isLoadingMore = false});

  @override
  State<HostLecturesList> createState() => _HostLecturesListState();
}

class _HostLecturesListState extends State<HostLecturesList> {
  Lecture? playingLecture;
  final player = Dependancies.audioPlayer();
  // bool isPlaying = false;
  PlayingStatus playingStatus = PlayingStatus.stopped;

  Future<void> playAudio(Lecture lecture) async {
    setState(() {
      playingStatus = PlayingStatus.waiting;
      playingLecture = lecture;
    });

    await player.setSourceUrl(lecture.url);
    player.resume();
    setState(() {
      playingStatus = PlayingStatus.playing;
    });
  }

  Future<void> pauseAudio() async {
    await player.pause();
    setState(() {
      playingStatus = PlayingStatus.paused;
    });
  }

  Future<void> stopAudio() async {
    player.stop();
    setState(() {
      playingStatus = PlayingStatus.stopped;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
              // shrinkWrap: true,
              controller: widget.scrollController,
              physics: BouncingScrollPhysics(),
              // physics: NeverScrollableScrollPhysics(),
              itemCount: widget.lectures.length,
              itemBuilder: (_, i) {
                final item = widget.lectures[i];
                return HostLectureItem(
                    onTap: (lecture) {
                      Get.to(() => LecturePlayerScreen(lecture));
                    },
                    popUpActions: [
                      PopupMenuItem(
                        // value: PopupMenuItemActionType.openDialgoue,
                        child: GestureDetector(
                            child: const Text('Delete Lecture')),
                        // onTap: () {
                        //   Future.delayed(0.seconds, () => showErrorDialogue());
                        // },
                        onTap: () => Future.delayed(
                            0.seconds, () => showDeletionDialogue(item)),
                      ),
                    ],
                    // onTapMenu: (lecture) {},
                    lecture: item);
                /*    ListTile(
                  leading: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          // color: Colors.black,
                          borderRadius: BorderRadius.circular(9)),
                      child: Image.network(item.thumb, fit: BoxFit.contain)),
                  title: Text(item.title),
                  subtitle: Text(item.title),
                  trailing: SizedBox(
                    width: 110,
                    child: Row(
                      children: [
                        playingLecture?.id == item.id
                            ? PlayButton(
                                playingStatus: playingStatus,
                                onPlay: () {
                                  print('yes');
                                  playAudio(item);
                                },
                                onPause: () {
                                  pauseAudio();
                                },
                                onStop: () {
                                  stopAudio();
                                },
                              )
                            : GestureDetector(
                                onTap: () {
                                  playAudio(item);
                                },
                                child: Container(
                                    alignment: Alignment.center,
                                    padding: const EdgeInsets.all(5),
                                    decoration: const BoxDecoration(
                                        color: primaryLightColor,
                                        shape: BoxShape.circle),
                                    child: const Icon(
                                      Icons.play_arrow,
                                      color: Colors.white,
                                    )),
                              ),
                        const SizedBox(
                          width: 9,
                        ),
                        const Icon(Icons.more_vert_rounded)
                      ],
                    ),
                  ),
                );
          */
              }),
        ),
        if (widget.isLoadingMore)
          Padding(
            padding: EdgeInsets.all(8),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )
      ],
    );
  }

  void showDeletionDialogue(Lecture lecture) {
    // showDialog(context: context, builder: builder)
    // widget.onRefresh();
    Get.dialog(LectureDelectionDialogue(
        lecture: lecture,
        onConfirmDelete: (lecture) async {
          await LectureRepository.deleteLecture(lecture);
          widget.onRefresh();
        }));

    // await Get.defaultDialog(
    //     title: "Warning",
    //     middleText:
    //         "Are you sure you want to delete the lecture titled: ${lecture.title}",
    //     onConfirm: () {
    //       LectureRepository.deleteLecture(lecture).then((value) {
    //         widget.onRefresh();
    //       });
    //       // widget.onRefresh;
    //       Get.back();
    //       // confirmedDeleteLecture(lecture);
    //     },
    //     // content:,
    //     onCancel: () {});
  }

  // Future <void> confirmedDeleteLecture(Lecture lecture) async {
  // }
}

class LectureDelectionDialogue extends StatefulWidget {
  final Lecture lecture;
  final Future<void> Function(Lecture lecture) onConfirmDelete;
  const LectureDelectionDialogue(
      {super.key, required this.lecture, required this.onConfirmDelete});

  @override
  State<LectureDelectionDialogue> createState() =>
      _LectureDelectionDialogueState();
}

class _LectureDelectionDialogueState extends State<LectureDelectionDialogue> {
  // bool isLoading = false;
  ProcessingStatus _status = ProcessingStatus.initial;

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case ProcessingStatus.loading:
        return AlertDialog(
          content: Center(child: ColorLoader()),
        );
      case ProcessingStatus.error:
        return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            actions: [
              MyButton(
                onTap: () {
                  Get.back();
                },
                child: const Text("Close"),
              ),
            ],
            content: ErrorScreen(
              messsage:
                  "Couldnt delete lecture. refresh the lectures before trying again",
            ));
      case ProcessingStatus.initial:
      case ProcessingStatus.success:
        return AlertDialog(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
          ),
          titlePadding: const EdgeInsets.all(8),
          contentPadding: const EdgeInsets.all(8),

          backgroundColor: Get.theme.dialogBackgroundColor,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          title: Text("Warning",
              textAlign: TextAlign.center, style: dangerTextStyle),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                    "Are you sure you want to delete the lecture titled: ${widget.lecture.title}",
                    textAlign: TextAlign.center),
              ),
              const SizedBox(height: 16),
              ButtonTheme(
                minWidth: 78.0,
                height: 34.0,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    // my
                    MyButton(
                      danger: true,
                      onTap: () async {
                        setState(() {
                          _status = ProcessingStatus.loading;
                        });
                        try {
                          await widget.onConfirmDelete(widget.lecture);
                          setState(() {
                            _status = ProcessingStatus.success;
                          });
                          Get.back();
                        } on Exception catch (e) {
                          Dependancies.errorService.addErrorWithCallback(
                              callback: () {
                                setState(() {
                                  _status = ProcessingStatus.error;
                                });
                              },
                              exception: e);
                        }
                        // setState(() {
                        //   isLoading = false;
                        // });
                        // LectureRepository.deleteLecture(lecture)
                        //     .then((value) {
                        //   widget.onRefresh();
                        // });
                        // widget.onRefresh;
                        // confirmedDeleteLecture(lecture);
                      },
                      child: const Text("Confirm"),
                    ),
                    MyButton(
                      onTap: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                  ],
                ),
              )
            ],
          ),
          // actions: actions, // ?? <Widget>[cancelButton, confirmButton],
          buttonPadding: EdgeInsets.zero,
        );
    }
  }
}
