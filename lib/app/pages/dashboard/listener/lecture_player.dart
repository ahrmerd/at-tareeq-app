// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/repositories/library_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:expandable/expandable.dart';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class LecturePlayerScreen extends StatefulWidget {
  const LecturePlayerScreen(this.lecture, {super.key, required});
  // final String songName;
  // final String? lecturer;
  final Lecture lecture;

  // final String songUrl;
  @override
  State<LecturePlayerScreen> createState() => _LecturePlayerScreenState();
}

class _LecturePlayerScreenState extends State<LecturePlayerScreen> {
  // final audioPlayer = AudioPlayer();
  final audioPlayer = Dependancies.audioPlayer();
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  bool isPlaying = false;
  bool isReady = false;

  static bool isOpened = false;
  ExpandableController controller = ExpandableController(
    initialExpanded: isOpened,
  );

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      isOpened = !isOpened;
    });
    setAudio();
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.playing;
      });
    });
    audioPlayer.onDurationChanged.listen((d) {
      setState(() {
        duration = d;
      });
    });
    audioPlayer.onPositionChanged.listen((p) {
      setState(() {
        position = p;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // List<bool> selected = <bool>[];
    // selected.add(false);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(
          color: CustomColor.appBlue,
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: MyNetworkImage(
                      useAppRequest: false,
                      path: widget.lecture.thumb,
                      height: 350,
                      fit: BoxFit.cover,
                    ),
                  ),
                  VerticalSpace(32),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(Icons.more_vert_rounded),
                          onPressed: () {
                            controller.toggle();
                          },
                        ),
                      ),
                      Expanded(
                          child: Container(
                        child: BigText(
                          widget.lecture.title,
                          color: Colors.black,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      )),
                      Container(
                        padding: const EdgeInsets.all(8),
                        child: IconButton(
                          icon: Icon(
                            Icons.favorite_outline_rounded,
                          ),
                          onPressed: () {
                            // TODO: Handle this case. add lectures to favorites. and show a favorited state
                            //also save favourited ids in your sharedpreferences
                          },
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  // SmallText(widget.lecture.),
                  SliderTheme(
                    data: SliderThemeData(
                      thumbColor: Colors.black,
                      trackHeight: 2,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                    ),
                    child: Slider(
                      activeColor: Colors.black,
                      inactiveColor: Colors.grey,
                      min: 0,
                      max: duration.inSeconds.toDouble() > 0
                          ? duration.inSeconds.toDouble()
                          : double.infinity,
                      value: position.inSeconds.toDouble(),
                      onChanged: (value) async {
                        final position = Duration(seconds: value.toInt());
                        await audioPlayer.seek(position);

                        await audioPlayer.resume();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDuration(position)),
                        Text(formatDuration(duration)),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.replay,
                          color: Colors.black,
                        ),
                        iconSize: 38,
                        onPressed: () {
                          replayAudio();
                        },
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.rotate_left_rounded,
                      //     color: Colors.black,
                      //   ),
                      //   iconSize: 38,
                      //   onPressed: () {},
                      // ),
                      CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 35,
                        child: IconButton(
                          icon: Icon(
                            isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            color: Colors.white,
                          ),
                          iconSize: 50,
                          onPressed: () async {
                            if (isPlaying) {
                              pauseAudio();
                              // await audioPlayer.pause();
                            } else {
                              playAudio();
                              // await audioPlayer.resume();
                            }
                          },
                        ),
                      ),
                      // IconButton(
                      //   icon: Icon(
                      //     Icons.rotate_right_rounded,
                      //     color: Colors.black,
                      //   ),
                      //   iconSize: 38,
                      //   onPressed: () {},
                      // ),
                      IconButton(
                        icon: Icon(
                          Icons.stop,
                          color: Colors.black,
                        ),
                        iconSize: 38,
                        onPressed: () {
                          stopAudio();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Positioned(
            //   bottom: 0,
            //   left: 0,
            //   right: 0,
            //   child: _menu(),
            // )
          ],
        ),
      ),

      /*    body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, primaryLightColor],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
        ),
        child: SafeArea(
          child: Stack(children: [
            Positioned(
              top: 0,
              left: 0,
              child: IconButton(
                onPressed: () => {Get.back()},
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.black,
                ),
              ),
            ),
            Positioned(
              top: Get.height * .225,
              left: 0,
              right: 0,
              child: Container(
                height: Get.height * .29,
                width: Get.height * .29,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 55, right: 55),
                  child: Container(
                    margin: const EdgeInsets.only(
                        top: 38, bottom: 38, left: 38, right: 38),
                    child: isReady
                        ? Icon(
                            Icons.music_video,
                            size: 50,
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ),
            ),
            //music slider
            Positioned(
              bottom: Get.height * 0.325,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(widget.songName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bigTextStyle.copyWith(color: lightColor)),
                ),
              ),
            ),
            Positioned(
              bottom: Get.height * .26,
              child: Builder(builder: (context) {
                return SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 20,
                  child: Slider(
                    value: position.inSeconds.toDouble(),
                    min: 0,
                    max: duration.inSeconds.toDouble(),
                    activeColor: Color(0xffBB86FC),
                    inactiveColor: Colors.white,
                    onChanged: (value) async {
                      final position = Duration(seconds: value.toInt());
                      await audioPlayer.seek(position);
                      await audioPlayer.resume();
                      // setState(() {
                      //   audioPlayer.seek(Duration(seconds: value.toInt()));
                      // });
                    },
                  ),
                );
              }),
            ),
            Positioned(
              bottom: Get.height * .24,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      formatTime(position),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text(
                      formatTime(duration),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationY(pi),
                    child: IconButton(
                      padding: const EdgeInsets.all(0),
                      onPressed: () async {
                        final position = Duration(seconds: 0);
                        await audioPlayer.seek(position);
                        await audioPlayer.resume();
                      },
                      icon: const Icon(
                        Icons.replay,
                        size: 35,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: IconButton(
                        splashColor: const Color(0xffBB86FC),
                        splashRadius: 30,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(0),
                        onPressed: () async {
                          setState(() {
                            if (isPlaying) {
                              pauseAudio();
                              // await audioPlayer.pause();
                            } else {
                              playAudio();

                              // await audioPlayer.resume();
                            }
                          });
                        },
                        icon: isPlaying
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow),
                      ),
                    ),
                  ),
                ],
              ),
              bottom: Get.height * 0.13,
              left: 0,
              right: 0,
            ),
          ]),
        ),
      ),
  */
    );
  }

  String formatDuration(Duration duration) {
    // String twoDigits(int n) {
    //   if (n >= 10) return "$n";
    //   return "0$n";
    // }

    String twoDigits(int n) => n.toString().padLeft(2, "0");

    int hours = duration.inHours;
    int minutes = duration.inMinutes.remainder(60);
    int seconds = duration.inSeconds.remainder(60);

    String twoDigitHours = twoDigits(hours);
    String twoDigitMinutes = twoDigits(minutes);
    String twoDigitSeconds = twoDigits(seconds);

    if (hours > 0) {
      return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  Future setAudio() async {
    String url = widget.lecture.url;
    await audioPlayer.setSourceUrl(url);
    setState(() {
      isReady = true;
    });
  }

  Future playAudio() async {
    await audioPlayer.resume();
    LibraryRepository.addToHistory(widget.lecture);
    setState(() {
      isPlaying = true;
    });
  }

  Future replayAudio() async {
    await audioPlayer.seek(Duration.zero);
    await audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  Future stopAudio() async {
    await audioPlayer.stop();
    setState(() {
      isPlaying = false;
    });
  }

  Future pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }
}
