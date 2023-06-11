import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/pages/dashboard/listener/lecture_player.dart';
import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'playbutton.dart';

class VerticalLectureListView extends StatefulWidget {
  final String label;
  final List<Lecture> lectures;
  final void Function(Lecture lecture) onAddToFavorite;
  final void Function(Lecture lecture) onAddToPlaylater;
  const VerticalLectureListView(
      {super.key,
      required this.label,
      required this.lectures,
      required this.onAddToFavorite,
      required this.onAddToPlaylater});

  @override
  State<VerticalLectureListView> createState() =>
      _VerticalLectureListViewState();
}

class _VerticalLectureListViewState extends State<VerticalLectureListView> {
  Lecture? playingLecture = null;
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
  void dispose() {
    player.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: widget.lectures.length,
        itemBuilder: (_, i) {
          final item = widget.lectures[i];
          return ListTile(
            onTap: () {
              Get.to(() => LecturePlayerScreen(item.title, item.url));
              // playAudio(item);
            },
            leading: Container(
                height: 60,
                width: 60,
                child: Image.network(item.thumb, fit: BoxFit.contain),
                decoration: BoxDecoration(
                    // color: Colors.black,
                    borderRadius: BorderRadius.circular(9))),
            title: Text(
              item.title,
              overflow: TextOverflow.ellipsis,
            ),
            // subtitle: Text(item.description),
            trailing: SizedBox(
              width: 130,
              child: Row(
                children: [
                  playingLecture?.id == item.id
                      ? PlayButton(
                          playingStatus: playingStatus,
                          onPlay: () {
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
                          onTap: () => playAudio(item),
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
                  PopupMenuButton(itemBuilder: (_) {
                    return [
                      PopupMenuItem(
                        child: Text('Add to favorite'),
                        onTap: () => widget.onAddToFavorite(item),
                      ),
                      PopupMenuItem(
                        child: Text('Add to playlater'),
                        onTap: () => widget.onAddToPlaylater(item),
                      ),
                    ];
                  }),
                  // Icon(Icons.more_vert_rounded)
                ],
              ),
            ),
          );
        });
  }
}
