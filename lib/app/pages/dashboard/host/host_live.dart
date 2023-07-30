import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:chat_bubbles/bubbles/bubble_special_one.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
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
        iconTheme: IconThemeData(color: CustomColor.appBlue),
      ),
      body: Container(
        margin: EdgeInsets.only(bottom: 110),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: MyNetworkImage(
                    path: controller.livestream.user?.thumb ?? "",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  // child: Image.asset(
                  //   'assets/pic_two.png',
                  //   width: double.infinity,
                  //   height: 200,
                  //   fit: BoxFit.cover,
                  // ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                        icon: Icon(Icons.more_vert_rounded),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
            VerticalSpace(),
            Expanded(child: Obx(() {
              return ListView.builder(
                  controller: controller.messageScrollController,
                  itemCount: controller.messages.length,
                  itemBuilder: (_, i) {
                    final message = controller.messages[i];
                    final bool isSentByMe =
                        SharedPreferencesHelper.getUserId() == message.user.id;
                    return ChatBubble(
                      clipper: ChatBubbleClipper3(
                          type: isSentByMe
                              ? BubbleType.sendBubble
                              : BubbleType.receiverBubble),
                      alignment:
                          isSentByMe ? Alignment.topRight : Alignment.topLeft,
                      margin: EdgeInsets.only(top: 20),
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
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w300),
                            ),
                            // separa
                            Text(
                              message.message,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            message.isSending
                                ? Icon(
                                    Icons.cached,
                                    size: 10,
                                    color: Colors.grey,
                                  )
                                : Text(
                                    formatDateTime(message.createdAt),
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w300),
                                  ),
                          ],
                        ),
                      ),
                    );
                    // return BubbleSpecialThree(
                    //   text: message.message,
                    //   color: primaryColor,
                    //   tail: true,
                    //   isSender: isSentByMe,
                    //   sent: !message.isSending,
                    //   textStyle: TextStyle(color: Colors.white, fontSize: 16),
                    // );
                    /*                   return Align(
                      alignment: isSentByMe
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        margin:
                            EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                        decoration: BoxDecoration(
                          color: isSentByMe ? primaryColor : Colors.grey,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [
                            Text(
                              message.user.name,
                              style: TextStyle(
                                color: isSentByMe ? Colors.white : Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              message.message,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              formatDateTime(message.createdAt),
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    );
*/
                  });
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
                HorizontalSpace(),
                MyButton(
                  child: Icon(Icons.send),
                  onTap: () {
                    controller
                        .sendMessage(controller.messageFieldControlller.text);
                  },
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
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
                      onPressed: () {},
                    ),
                  ),
                ),
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        isSelected: controller.isMuted.value,
                        selectedIcon: Icon(
                          Icons.volume_off_outlined,
                          color: Colors.black,
                        ),
                        icon: Icon(
                          Icons.volume_up_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    HorizontalSpace(),
                    MyButton(
                      // onPressed: () {},
                      child: Text('End Lecture'),
                    ),
                    HorizontalSpace(),
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: IconButton(
                        icon: Icon(
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
          ),
        ],
      ),
    );
  }
}
