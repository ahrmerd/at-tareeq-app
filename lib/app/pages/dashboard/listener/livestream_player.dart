import 'package:at_tareeq/app/controllers/livestream_player_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/styles/decorations.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:at_tareeq/core/utils/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:get/get.dart';

class LivestreamPlayer extends GetView<LivestreamPlayerController> {
  const LivestreamPlayer({Key? key}) : super(key: key);

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: MyNetworkImage(
                    path: controller.livestream.value.user?.thumb ?? "",
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
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
                          path: controller.livestream.value.user?.thumb ?? "",
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
                            controller.livestream.value.title,
                            fontSize: 16,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          SmallText(
                            controller.livestream.value.user?.name ?? "",
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
                              style:
                                  const TextStyle(color: Colors.white, fontSize: 16),
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
          /*         Padding(
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
 */
        ],
      ),
    );
  }
}



// import 'package:at_tareeq/app/controllers/livestream_player_controller.dart';
// import 'package:at_tareeq/app/widgets/widgets.dart';
// import 'package:at_tareeq/core/themes/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class LivestreamPlayer extends GetView<LivestreamPlayerController> {
//   const LivestreamPlayer({super.key});

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(context),
//             SizedBox(height: 20),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   _buildThumbnail(context),
//                   SizedBox(height: 20),
//                   _buildStreamInfo(context),
//                   SizedBox(height: 20),
//                   _buildProgressBar(context),
//                   SizedBox(height: 20),
//                   _buildControls(context),
//                   SizedBox(height: 20),
//                   _buildPlaylist(context),
//                 ],
//               ),
//             ),
//             SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           color: primaryColor,
// //         ),
// //         child: Center(
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: <Widget>[
// //               Container(
// //                 height: 200,
// //                 width: 200,
// //                 decoration: BoxDecoration(
// //                   shape: BoxShape.circle,
// //                   color: primaryLightColor,
// //                 ),
// //                 child: Icon(
// //                   controller.isPlaying.value ? Icons.stop : Icons.play_arrow,
// //                   size: 100,
// //                   color: primaryDarkColor,
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               Text(
// //                 controller.livestream.value.title,
// //                 style: TextStyle(
// //                   color: Colors.white,
// //                   fontSize: 20,
// //                 ),
// //               ),
// //               SizedBox(height: 10),
// //               Row(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: <Widget>[
// //                   MyButton(
// //                     onTap: () {
// //                       controller.togglePlayer();
// //                     },
// //                     child: Icon(Icons.music_note),
// //                     danger: false,
// //                     color: Colors.white,
// //                     bgColor: primaryColor,
// //                     padding: const EdgeInsets.symmetric(
// //                       horizontal: 10,
// //                       vertical: 10,
// //                     ),
// //                   ),
// //                   SizedBox(width: 10),
// //                   Switch(
// //                     value: controller.isMuted.value,
// //                     onChanged: (isMuted) {
// //                       controller.changeMutedState(isMuted);
// //                     },
// //                   ),
// //                 ],
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//   // _LivestreamPlayerState createState() => _LivestreamPlayerState();
//   // @override

// // class _LivestreamPlayerState extends State<LivestreamPlayer> {
// //   RtcEngine _engine;
// //   bool _isPlaying = false;
// //   bool _isMuted = false;

// //   @override
// //   void initState() {
// //     super.initState();
// //     _engine = RtcEngine.create(appId);
// //     _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
// //     _engine.setClientRole(ClientRole.Broadcaster);
// //     _engine.joinChannel(widget.livestreamUrl, null, 0);
// //     _engine.onAudioTransportStateChanged.listen((event) {
// //       if (event == AudioTransportState.Playing) {
// //         setState(() {
// //           _isPlaying = true;
// //         });
// //       } else if (event == AudioTransportState.Paused) {
// //         setState(() {
// //           _isPlaying = false;
// //         });
// //       }
// //     });
// //   }

// //   @override
// //   void dispose() {
// //     _engine.leaveChannel();
// //     _engine.destroy();
// //     super.dispose();
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Container(
// //       decoration: BoxDecoration(
// //         color: Colors.black,
// //       ),
// //       child: Center(
// //         child: Column(
// //           mainAxisAlignment: MainAxisAlignment.center,
// //           children: <Widget>[
// //             Container(
// //               height: 200,
// //               width: 200,
// //               decoration: BoxDecoration(
// //                 shape: BoxShape.circle,
// //                 color: Colors.white,
// //               ),
// //               child: Icon(
// //                 _isPlaying ? Icons.stop : Icons.play_arrow,
// //                 size: 100,
// //                 color: Colors.black,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Text(
// //               'Livestream Title',
// //               style: TextStyle(
// //                 color: Colors.white,
// //                 fontSize: 20,
// //               ),
// //             ),
// //             SizedBox(height: 10),
// //             Row(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 RaisedButton(
// //                   child: Icon(Icons.music_note),
// //                   onPressed: () {
// //                     if (!_isPlaying) {
// //                       _engine.startAudio();
// //                     } else {
// //                       _engine.stopAudio();
// //                     }
// //                   },
// //                 ),
// //                 SizedBox(width: 10),
// //                 ToggleButton(
// //                   children: <Widget>[
// //                     Text('Mute'),
// //                     Text('Unmute'),
// //                   ],
// //                   onPressed: (isMuted) {
// //                     setState(() {
// //                       _isMuted = isMuted;
// //                       if (_isMuted) {
// //                         _engine.muteLocalAudio();
// //                       } else {
// //                         _engine.unmuteLocalAudio();
// //                       }
// //                     });
// //                   },
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
