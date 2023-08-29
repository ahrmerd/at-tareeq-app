import 'package:at_tareeq/app/controllers/download_controller.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/downloader.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadPlayerPage extends GetView<DownloadController> {
  const DownloadPlayerPage ({super.key});
  // final DownloadController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
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
              child: Obx(() {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.asset(
                          'assets/pic_two.png',
                          // useAppRequest: false,
                          // path: widget.lecture.thumb,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const VerticalSpace(32),
                      Obx(() {
                          return Row(
                            children: [
                              
                              Expanded(
                                  child: Container(
                                child: BigText(
                                  Downloader.lectureTitleFromFile(controller.downloads[controller.currPlayingIndex.value??0]),
                                  color: Colors.black,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              )),
                              
                            ],
                          );
                        }
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // SmallText(widget.lecture.),
                      Obx(() {
                          return SliderTheme(
                            data: const SliderThemeData(
                              thumbColor: Colors.black,
                              trackHeight: 2,
                              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6),
                            ),
                            child: Slider(
                              activeColor: Colors.black,
                              inactiveColor: Colors.grey,
                              min: 0,
                              max: controller.duration.value.inSeconds.toDouble() > 0
                                  ? controller.duration.value.inSeconds.toDouble()
                                  : double.infinity,
                              value: controller.position.value.inSeconds.toDouble(),
                              onChanged: (value) async {
                                final position = Duration(seconds: value.toInt());
                                await controller.audioPlayer.seek(position);

                                await controller.audioPlayer.resume();
                              },
                            ),
                          );
                        }
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formatDuration(controller.position.value)),
                            Text(formatDuration(controller.duration.value)),
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
                            icon: const Icon(
                              Icons.replay,
                              color: Colors.black,
                            ),
                            iconSize: 38,
                            onPressed: () {
                              controller.replayAudio();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_previous_rounded,
                              color: Colors.black,
                            ),
                            iconSize: 38,
                            onPressed: () {
                              controller.playPrev();
                            },
                          ),
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 35,
                            child: IconButton(
                              icon: Icon(
                                controller.isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                                color: Colors.white,
                              ),
                              iconSize: 50,
                              onPressed: () async {
                                if (controller.isPlaying) {
                                  controller.pauseAudio();
                                  // await audioPlayer.pause();
                                } else {
                                  controller.playAudio();
                                  // await audioPlayer.resume();
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.skip_next_rounded,
                              color: Colors.black,
                            ),
                            iconSize: 38,
                            onPressed: () {
                              controller.playNext();
                            },
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.stop,
                              color: Colors.black,
                            ),
                            iconSize: 38,
                            onPressed: () {
                              controller.stopAudio();
                            },
                          ),
                        ],
                      ),
                    ],
                  );
                }
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
}