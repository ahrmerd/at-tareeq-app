import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HostLivePage extends GetView<HostLiveController> {
  const HostLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(children: [
        Text(controller.livestream.title),
        //
        Container(
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
                    if (controller.livestreamStatus.value.isStarted() &&
                        !controller.isLive.value)
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'This Livestream has already started broadcasting. you may continue broadcasting',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    if (controller.livestreamStatus.value.isEnded())
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'This Livestream has finished broadcasting. you can\'t continue broadcasting',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    const VerticalSpace(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!controller.livestreamStatus.value.isEnded() &&
                            !controller.isLive.value)
                          GestureDetector(
                            onTap: controller.startBroadcast,
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
                                child: Icon(
                                  MdiIcons.broadcast,
                                  size: 42,
                                  color: controller.livestreamStatus.value ==
                                          LivestreamStatus.notStarted
                                      ? Colors.red
                                      : Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        const HorizontalSpace(),
                        if (controller.isLive.value &&
                            !controller.isAudioMuted.value)
                          GestureDetector(
                            onTap: controller.muteAudioBroadcast,
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
                                    Icons.volume_off,
                                    size: 25,
                                    color: Colors.red,
                                  ),
                                )),
                          ),
                        if (controller.isLive.value && controller.isAudioMuted.value)
                          GestureDetector(
                            onTap: controller.unmuteAudioBroadcast,
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
                                    Icons.volume_up_outlined,
                                    size: 25,
                                    color: Colors.blue,
                                  ),
                                )),
                          ),
                        const HorizontalSpace(),
                        if (controller.isLive.value)
                          GestureDetector(
                            onTap: controller.stopBroadcast,
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
                      ],
                    )
                  ],
                ),
                if (controller.isLive.value)
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: AvatarGlow(
                      glowColor: Colors.redAccent,
                      endRadius: 20,
                      child: Container(
                        // height: 30,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: const Icon(
                          MdiIcons.broadcast,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  )
              ],
            );
          }),
        )
      ]),
    );
  }
}
