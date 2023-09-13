import 'package:at_tareeq/app/controllers/livestream_player_controller.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerLiveControlsWidget extends StatelessWidget {
  const ListenerLiveControlsWidget({
    super.key,
    required this.controller,
  });

  final LivestreamPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Obx(() {
        return !controller.isReady.value ? const CircularProgressIndicator() :  Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            MyButton(
                    onTap: () {

                      controller.togglePlayer();
                      // if(!controller.isPlaying.value)
                    },
                    child: Text(controller.isPlaying.value ? 'Stop Listening': 'Start Listening'),
                  ),
                  const HorizontalSpace(),
            // AvatarGlow(
            //   glowColor: Colors.redAccent,
            //   endRadius: controller.isPlaying.value ? 30 : 20,
            //   child: CircleAvatar(
            //     backgroundColor:
            //         controller.isPlaying.value ? Colors.red : Colors.grey,
            //     child: IconButton(
            //       icon: Icon(
            //         Icons.mic_none_rounded,
            //         color:
            //             controller.isPlaying.value ? Colors.white : Colors.black,
            //       ),
            //       onPressed: () {
            //         controller.togglePlayer();
            //       },
            //     ),
            //   ),
            // ),
            if (controller.isPlaying.value)
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      isSelected: controller.isAudioMuted.value,
                      selectedIcon: const Icon(
                        Icons.volume_off_outlined,
                        color: Colors.black,
                      ),
                      icon: const Icon(
                        Icons.volume_up_outlined,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        controller.isAudioMuted.value
                            ? controller.unmuteAudioStream()
                            : controller.muteAudioStream();
                      },
                    ),
                  ),
                  const HorizontalSpace(),
                  //video
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      isSelected: controller.isVideoMuted.value,
                      selectedIcon: const Icon(
                        Icons.videocam_off,
                        color: Colors.black,
                      ),
                      icon: const Icon(
                        Icons.videocam,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        controller.isVideoMuted.value
                            ? controller.unmuteVideoStream()
                            : controller.muteVideoStream();
                      },
                    ),
                  ),
                  //camera switch
                  

                  // const HorizontalSpace(),
                  // MyButton(
                  //   onTap: () {
                  //     controller.leaveChannel();
                  //   },
                  //   child: const Text('End Lecture'),
                  // ),
                  // const HorizontalSpace(),
                ],
              ),
            CircleAvatar(
              backgroundColor: Colors.grey,
              child: IconButton(
                icon: const Icon(
                  Icons.share_outlined,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
          ],
        );
      }),
    );
  }
}
