import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/livestream_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/live_messages_widget.dart';
import 'package:at_tareeq/app/widgets/livestream_info_widget.dart';
import 'package:at_tareeq/app/widgets/send_live_message_widget.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivestreamLayout extends StatelessWidget {
  final LiveStreamController controller;
  final AgoraVideoView agoraVideoView;
  final Widget livesControlWidget;
  const LivestreamLayout(
      {super.key,
      required this.controller,
      required this.agoraVideoView,
      required this.livesControlWidget});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            colors: [Colors.black87, Colors.transparent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )),
        ),
      ),
      body: Container(
        color: Colors.black87,
        height: Get.height,
        width: Get.width,
        // decoration: Colors
        // decoration: BoxDecoration(),
        // margin: const EdgeInsets.only(bottom: 110),
        // padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          return Stack(children: [
            if (controller.livestream.isVideo && controller.isLive.value)
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 400, width: 500, child: agoraVideoView),
                  // VideoPlayerWidget(controller: controller),
                ],
              ),
            Positioned(
                top: 50,
                left: 0,
                right: 0,
                // left: 16,
                child: LiveStreamInfoWidget(
                  lecturer: controller.livestream.user?.getOrganization() ?? "",
                  showThumb: (!(controller.livestream.isVideo &&
                      controller.isLive.value)),
                  // showThumb: ,
                  thumbPath: controller.livestream.user?.thumb ?? '',
                  title: controller.livestream.title,
                  // title: '',
                )),
            LiveTopRightWidget(
              isLive: controller.isLive.value,
              isVideo: controller.livestream.isVideo,
            ),
            Positioned(
                bottom: 150,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.all(10),
                  width: Get.width,
                  height: 250,
                  child: LiveMessagesWidget(
                    hostUserId: controller.livestream.userId,
                    onRefresh: () {
                      controller.fetchAllMessages(true);
                    },
                    messageScrollController: controller.messageScrollController,
                    messages: controller.messages.value,
                    messagesProcessingStatus:
                        controller.messagesProcessingStatus.value,
                  ),
                )),
          ]);
        }),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            livesControlWidget,
            // ListenerLiveControlsWidget(controller: controller),
            Obx(() {
              if (!controller.isSending.value &&
                  controller.messagesProcessingStatus.value ==
                      ProcessingStatus.success) {
                return SendMessageWidget(
                  messageFieldControlller: controller.messageFieldControlller,
                  onSubmit: (String val) {
                    controller.sendMessage(val);
                  },
                );
              } else {
                return const LinearProgressIndicator();
              }
            }),
          ],
        ),
      ),
    );
  }
}

class LiveTopRightWidget extends StatelessWidget {
  final bool isVideo;
  final bool isLive;
  const LiveTopRightWidget({
    super.key,
    required this.isVideo,
    required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 80,
        right: 30,
        child: Column(
          children: [
            if (isLive)
              Container(
                width: 52,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4), color: Colors.red),
                child: const SmallText(
                  'LIVE',
                  textAlign: TextAlign.center,
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            const SizedBox(
              height: 16,
            ),
            Container(
              width: 79,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), color: Colors.red),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SmallText(
                    isVideo ? 'Video' : 'Audio',
                    textAlign: TextAlign.center,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
