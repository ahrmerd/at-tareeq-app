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
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: CustomColor.appBlue),
      ),
      body: Container(
        margin: const EdgeInsets.only(bottom: 110),
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Obx(() {
            return Column(
              children: [
                LiveStreamInfoWidget(
                  lecturer: controller.livestream.user?.getOrganization() ?? '',
                  processingStatus: controller.liveProcessingStatus.value,
                  thumbPath: controller.livestream.user?.thumb ?? '',
                  title: controller.livestream.title,
                ),
                const VerticalSpace(),
                Builder(builder: (_) {
                  switch (controller.liveProcessingStatus.value) {
                    case ProcessingStatus.error:
                    case ProcessingStatus.initial:
                    case ProcessingStatus.loading:
                      return Container();
                    case ProcessingStatus.success:
                      return HostLiveControlsWidget(controller: controller);
                  }
                }),
                LiveMessagesWidget(
                  messages: controller.messages,
                  messagesProcessingStatus:
                      controller.messagesProcessingStatus.value,
                  messageScrollController: controller.messageScrollController,
                ),
                // messagesWidget(),
              ],
            );
          }),
        ),
      ),
      bottomSheet: Container(
        margin: const EdgeInsets.only(bottom: 30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SendMessageWidget(
              messageFieldControlller: controller.messageFieldControlller,
              onSubmit: (String val) {
                controller.sendMessage(val);
              },
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

