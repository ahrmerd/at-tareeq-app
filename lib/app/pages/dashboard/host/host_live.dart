import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/widgets/host_live_controls_widget.dart';
import 'package:at_tareeq/app/widgets/live_messages_widget.dart';
import 'package:at_tareeq/app/widgets/send_live_message_widget.dart';
import 'package:at_tareeq/app/widgets/livestream_info_widget.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HostLivePage extends GetView<HostLiveController> {
  const HostLivePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        flexibleSpace: Container(
          decoration: BoxDecoration(
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
              if (controller.livestream.isVideo&&
                        controller.isLive.value)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 400,
                      width: 500,
                      child: AgoraVideoView(
                      // remember for listenet use VideoViewController.remote
                        controller: VideoViewController(
                          rtcEngine: controller.engine,
                          canvas: VideoCanvas(uid: 0)),
                      ),
                    ),
                    // VideoPlayerWidget(controller: controller),
                  ],
                ),
              Positioned(
                  top: 80,
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
              LiveTopRightWidget(isLive: controller.isLive.value, isVideo: controller.livestream.isVideo,),
              Positioned(
                  bottom: 150,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: Get.width,
                    height: 250,
                    child: LiveMessagesWidget(
                      hostUserId: controller.livestream.userId,
                      onRefresh: (){controller.fetchAllMessages(true);},
                      messageScrollController: controller.messageScrollController,
                      messages: controller.messages.value,
                      messagesProcessingStatus:
                          controller.messagesProcessingStatus.value,
                    ),
                  )),
            ]);
          }
        ),
        //   Obx(() {
        //     return Column(
        //       children: [
        //         LiveStreamInfoWidget(
        //           lecturer: controller.livestream.user?.getOrganization() ?? '',
        //           showThumb: (controller.livestream.isVideo && (!controller.isLive.value)),
        //           thumbPath: controller.livestream.user?.thumb ?? '',
        //           title: controller.livestream.title,
        //         ),
        //         const VerticalSpace(),
        //         Builder(builder: (_) {
        //           switch (controller.liveProcessingStatus.value) {
        //             case ProcessingStatus.error:
        //             case ProcessingStatus.initial:
        //             case ProcessingStatus.loading:
        //               return Container();
        //             case ProcessingStatus.success:
        //               return HostLiveControlsWidget(controller: controller);
        //           }
        //         }),
        //         LiveMessagesWidget(
        //           messages: controller.messages,
        //           messagesProcessingStatus:
        //               controller.messagesProcessingStatus.value,
        //           messageScrollController: controller.messageScrollController,
        //         ),
        //         // messagesWidget(),
        //       ],
        //     );
        //   }),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HostLiveControlsWidget(controller: controller),
            Obx(() {
            if(!controller.isSending.value && controller.messagesProcessingStatus.value==ProcessingStatus.success){
                return SendMessageWidget(
                  messageFieldControlller: controller.messageFieldControlller,
                  onSubmit: (String val) {
                    controller.sendMessage(val);
                  },
                );

            }else{
              return LinearProgressIndicator();
            }
              }
            ),
          ],
        ),
      ),
    );
  }

  // Container messagesWidget() {
  //   return Container(child: Obx(() {
  //     switch (controller.messagesProcessingStatus.value) {
  //       case ProcessingStatus.success:
  //         return ListView.builder(
  //             primary: false,
  //             shrinkWrap: true,
  //             physics: NeverScrollableScrollPhysics(),
  //             controller: controller.messageScrollController,
  //             itemCount: controller.messages.length,
  //             itemBuilder: (_, i) {
  //               final message = controller.messages[i];
  //               final bool isSentByMe =
  //                   SharedPreferencesHelper.getUserId() == message.user.id;
  //               return ChatBubble(
  //                 clipper: ChatBubbleClipper3(
  //                     type: isSentByMe
  //                         ? BubbleType.sendBubble
  //                         : BubbleType.receiverBubble),
  //                 alignment:
  //                     isSentByMe ? Alignment.topRight : Alignment.topLeft,
  //                 margin: const EdgeInsets.only(top: 20),
  //                 backGroundColor: primaryColor,
  //                 child: Container(
  //                   // constraints: BoxConstraints(
  //                   // maxWidth: MediaQuery.of(context).size.width * 0.7,
  //                   // ),
  //                   child: Column(
  //                     mainAxisAlignment: MainAxisAlignment.start,
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         message.user.name,
  //                         style: const TextStyle(
  //                             color: Colors.grey,
  //                             fontSize: 13,
  //                             fontWeight: FontWeight.w300),
  //                       ),
  //                       // separa
  //                       Text(
  //                         message.message,
  //                         style: const TextStyle(
  //                             color: Colors.white, fontSize: 16),
  //                       ),
  //                       message.isSending
  //                           ? const Icon(
  //                               Icons.cached,
  //                               size: 10,
  //                               color: Colors.grey,
  //                             )
  //                           : Text(
  //                               formatDateTime(message.createdAt),
  //                               style: const TextStyle(
  //                                   color: Colors.grey,
  //                                   fontSize: 10,
  //                                   fontWeight: FontWeight.w300),
  //                             ),
  //                     ],
  //                   ),
  //                 ),
  //               );
  //             });
  //       case ProcessingStatus.initial:
  //         return const CircularProgressIndicator();
  //       case ProcessingStatus.error:
  //         return const ErrorScreen();
  //       case ProcessingStatus.loading:
  //         return const CircularProgressIndicator();
  //     }
  //   }));
  // }

  // StreamInfoWidget StreamInfo() {
  //   return StreamInfoWidget(
  //     lecturer: controller.livestream.user!.getOrganization(),
  //     processingStatus: controller.liveProcessingStatus.value,
  //     thumbPath: controller.livestream.user?.thumb??'', title: controller.livestream.title,
  //   );
  // }

  // Obx liveThumb() {
  //   return LiveStreamThumb(controller: controller, controller: controller);
  // }
}

class LiveTopRightWidget extends StatelessWidget {
  final bool isVideo;
  final bool isLive;
  const LiveTopRightWidget({
    super.key, required this.isVideo, required this.isLive,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 80,
        right: 30,
        child: Column(
          children: [
            if(isLive)
            Container(
              width: 52,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4), color: Colors.red),
              child: SmallText(
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
                  Icon(
                    Icons.people_alt_rounded,
                    color: Colors.white,
                    size: 18,
                  ),
                  SmallText(
                    isVideo?'Video': 'Audio',
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
