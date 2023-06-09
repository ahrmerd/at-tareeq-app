import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class HostLecturesList extends StatefulWidget {
  final List<Lecture> lectures;
  const HostLecturesList({super.key, required this.lectures});

  @override
  State<HostLecturesList> createState() => _HostLecturesListState();
}

class _HostLecturesListState extends State<HostLecturesList> {
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
  Widget build(BuildContext context) {
    return ListView.builder(
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        itemCount: widget.lectures.length,
        itemBuilder: (_, i) {
          final item = widget.lectures[i];
          return ListTile(
            leading: Container(
                height: 60,
                width: 60,
                child: Image.network(item.thumb, fit: BoxFit.contain),
                decoration: BoxDecoration(
                    // color: Colors.black,
                    borderRadius: BorderRadius.circular(9))),
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
                  Icon(Icons.more_vert_rounded)
                ],
              ),
            ),
          );
        });
  }
}
