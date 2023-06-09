// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/styles/text_styles.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:get/get.dart';
import 'dart:math';
// import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class LecturePlayerScreen extends StatefulWidget {
  const LecturePlayerScreen(this.songName, this.songUrl, {super.key});
  final String songName;
  final String songUrl;
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

  @override
  void initState() {
    super.initState();
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
    List<bool> selected = <bool>[];
    selected.add(false);
    return Scaffold(
      body: Container(
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
    );
  }

  String formatTime(Duration duration) {
    String twoDigits(int n) {
      if (n >= 10) return "$n";
      return "0$n";
    }

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  Future setAudio() async {
    String url = widget.songUrl;
    await audioPlayer.setSourceUrl(url);
    setState(() {
      isReady = true;
    });
  }

  Future playAudio() async {
    await audioPlayer.resume();
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

  Future pauseAudio() async {
    await audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }
}
