import 'package:at_tareeq/app/controllers/download_controller.dart';
import 'package:at_tareeq/app/widgets/playbutton.dart';
import 'package:at_tareeq/app/widgets/screens/empty_screen.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/screens/loading_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/downloader.dart';
import 'package:at_tareeq/routes/pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DownloadsPage extends GetView<DownloadController> {
  const DownloadsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Downloads')),
      body: controller.obx(
        (state) => ListView.builder(
            itemCount: state!.length,
            itemBuilder: (_, index) {
              final item = state[index];
              return GestureDetector(
                onTap: () {
                  controller.setAudio(index);
                  // print(item.path);
                  Get.toNamed(Routes.DOWNLOADSPLAYER);
                },
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  margin:
                      const EdgeInsets.symmetric(vertical: 2, horizontal: 0),
                  elevation: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey.shade100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              const HorizontalSpace(16),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SmallText(
                                        Downloader.lectureTitleFromFile(item)),
                                    const HorizontalSpace(4),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Obx(() {
                            return Row(
                              children: [
                                controller.currPlayingIndex.value == index
                                    ? PlayButton(
                                        playingStatus:
                                            controller.playingStatus.value,
                                        onPlay: () {
                                          controller.play(index);
                                          // controller.playAudio();
                                        },
                                        onPause: () {
                                          controller.pauseAudio();
                                        },
                                        onStop: () {
                                          controller.stopAudio();
                                        },
                                      )
                                    : GestureDetector(
                                        onTap: () => controller.play(index),
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                                color: CustomColor.appPurple,
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                              Icons.play_arrow,
                                              color: Colors.white,
                                            )),
                                      ),
                                const HorizontalSpace(9),
                                GestureDetector(
                                        onTap: () {
                                          controller.deleteItem(item);
                                        },
                                        child: Container(
                                            alignment: Alignment.center,
                                            padding: const EdgeInsets.all(5),
                                            decoration: const BoxDecoration(
                                                color: dangerColor,
                                                shape: BoxShape.circle),
                                            child: const Icon(
                                              Icons.delete_forever,
                                              color: Colors.white,
                                            )),
                                      ),
                                // LectureOptionsMenuWidget(
                                //   lecture: item,
                                //   // controller: controller,
                                // ),
                              ],
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
        onEmpty: const EmptyScreen(),
        onError: (error) => ErrorScreen(
            onRetry: (){controller.fetchDownloads();},
           messsage: error.toString()),
        onLoading: const LoadingScreen(),
      ),
    );
  }
}
