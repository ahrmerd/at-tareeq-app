import 'package:at_tareeq/app/controllers/host_livestream_controller.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HostLiveControlsWidget extends StatelessWidget {
  const HostLiveControlsWidget({
    super.key,
    required this.controller,
  });

  final HostLivestreamController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Obx(() {
        return !controller.isReady.value
            ? const CircularProgressIndicator()
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AvatarGlow(
                    glowColor: Colors.redAccent,
                    endRadius: controller.isLive.value ? 30 : 20,
                    child: CircleAvatar(
                      backgroundColor:
                          controller.isLive.value ? Colors.red : Colors.grey,
                      child: IconButton(
                        icon: Icon(
                          Icons.mic_none_rounded,
                          color: controller.isLive.value
                              ? Colors.white
                              : Colors.black,
                        ),
                        onPressed: () {
                          if (controller.isLive.value) {
                            controller.stopBroadcast();
                          } else {
                            controller.startBroadcast();
                          }
                        },
                      ),
                    ),
                  ),
                  if (controller.isLive.value)
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
                                  ? controller.unmuteAudioBroadcast()
                                  : controller.muteAudioBroadcast();
                            },
                          ),
                        ),
                        const HorizontalSpace(),
                        //video
                        if (controller.livestream.isVideo)
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
                                    ? controller.unmuteVideoBroadcast()
                                    : controller.muteVideoBroadcast();
                              },
                            ),
                          ),
                        //camera switch
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: IconButton(
                            icon: const Icon(
                              Icons.cameraswitch_rounded,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              controller.switchCamera();
                            },
                          ),
                        ),

                        const HorizontalSpace(),
                        MyButton(
                          onTap: () {
                            controller.stopBroadcast();
                          },
                          child: const Text('End Lecture'),
                        ),
                        const HorizontalSpace(),
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
