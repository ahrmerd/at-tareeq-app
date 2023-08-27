import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
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
        child: Column(
          children: [
            Column(
              children: [
                Obx(() {
                  switch (controller.liveProcessingStatus.value) {
                    case ProcessingStatus.initial:
                      return const SizedBox(
                        height: 200,
                        child: Column(
                          children: [
                            ColorLoader(),
                          ],
                        ),
                      );
                    case ProcessingStatus.success:
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: MyNetworkImage(
                          path: controller.livestream.user?.thumb ?? "",
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      );
                    case ProcessingStatus.error:
                      return const ErrorScreen(
                        messsage: "Unable to initalize livestream",
                      );
                    case ProcessingStatus.loading:
                      return const ColorLoader();
                  }
                }),
                const VerticalSpace(16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          BigText(
                            controller.livestream.title,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          SmallText(
                            controller.livestream.user?.name ?? "",
                            fontSize: 15,
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const VerticalSpace(),
            Expanded(child: Obx(() {
              switch (controller.messagesProcessingStatus.value) {
                case ProcessingStatus.success:
                  return ListView.builder(
                      controller: controller.messageScrollController,
                      itemCount: controller.messages.length,
                      itemBuilder: (_, i) {
                        final message = controller.messages[i];
                        final bool isSentByMe =
                            SharedPreferencesHelper.getUserId() ==
                                message.user.id;
                        return ChatBubble(
                          clipper: ChatBubbleClipper3(
                              type: isSentByMe
                                  ? BubbleType.sendBubble
                                  : BubbleType.receiverBubble),
                          alignment: isSentByMe
                              ? Alignment.topRight
                              : Alignment.topLeft,
                          margin: const EdgeInsets.only(top: 20),
                          backGroundColor: primaryColor,
                          child: Container(
                            // constraints: BoxConstraints(
                            // maxWidth: MediaQuery.of(context).size.width * 0.7,
                            // ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  message.user.name,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w300),
                                ),
                                // separa
                                Text(
                                  message.message,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                message.isSending
                                    ? const Icon(
                                        Icons.cached,
                                        size: 10,
                                        color: Colors.grey,
                                      )
                                    : Text(
                                        formatDateTime(message.createdAt),
                                        style: const TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300),
                                      ),
                              ],
                            ),
                          ),
                        );
                      });
                case ProcessingStatus.initial:
                  return const CircularProgressIndicator();
                case ProcessingStatus.error:
                  return const ErrorScreen();
                case ProcessingStatus.loading:
                  return const CircularProgressIndicator();
              }
            })),
          ],
        ),
      ),
      bottomSheet: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  // constraints: BoxConstraints.loose(Size(Get.width - 70, 200)),
                  // width: Get.width - 170,
                  child: TextField(
                    controller: controller.messageFieldControlller,
                    onSubmitted: (val) {
                      controller.sendMessage(val);
                    },
                    decoration: myInputDecoration2(label: "Message"),
                  ),
                ),
                const HorizontalSpace(),
                MyButton(
                  child: const Icon(Icons.send),
                  onTap: () {
                    controller
                        .sendMessage(controller.messageFieldControlller.text);
                  },
                )
              ],
            ),
          ),
          Obx(() {
            switch (controller.liveProcessingStatus.value) {
              case ProcessingStatus.error:
              case ProcessingStatus.initial:
              case ProcessingStatus.loading:
                return Container();
              case ProcessingStatus.success:
                return Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AvatarGlow(
                        glowColor: Colors.redAccent,
                        endRadius: controller.isLive.value ? 30 : 20,
                        child: CircleAvatar(
                          backgroundColor: controller.isLive.value
                              ? Colors.red
                              : Colors.grey,
                          child: IconButton(
                            icon: Icon(
                              Icons.mic_none_rounded,
                              color: controller.isLive.value
                                  ? Colors.white
                                  : Colors.black,
                            ),
                            onPressed: () {
                              controller.startBroadcast();
                            },
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            child: IconButton(
                              isSelected: controller.isMuted.value,
                              selectedIcon: const Icon(
                                Icons.volume_off_outlined,
                                color: Colors.black,
                              ),
                              icon: const Icon(
                                Icons.volume_up_outlined,
                                color: Colors.black,
                              ),
                              onPressed: () {
                                controller.isMuted.value
                                    ? controller.unmuteBroadcast()
                                    : controller.muteBroadcast();
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
                      ),
                    ],
                  ),
                );

                // TODO: Handle this case.
                break;
                // TODO: Handle this case.
                break;
                // TODO: Handle this case.
                break;
            }
          }),
        ],
      ),
    );
  }
}
