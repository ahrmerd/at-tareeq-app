import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/livestream_player_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/pages/dashboard/host/host_live.dart';
import 'package:at_tareeq/app/widgets/color_loader.dart';
import 'package:at_tareeq/app/widgets/host_live_controls_widget.dart';
import 'package:at_tareeq/app/widgets/listener_live_controls_widget.dart';
import 'package:at_tareeq/app/widgets/live_messages_widget.dart';
import 'package:at_tareeq/app/widgets/livestream_info_widget.dart';
import 'package:at_tareeq/app/widgets/my_network_image.dart';
import 'package:at_tareeq/app/widgets/screens/error_screen.dart';
import 'package:at_tareeq/app/widgets/send_live_message_widget.dart';
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
              if (controller.livestream.value.isVideo&&
                        controller.isPlaying.value)
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 400,
                      width: 500,
                      child: AgoraVideoView(
                      // remember for listenet use VideoViewController.remote
                        controller: VideoViewController.remote(
                          rtcEngine: controller.engine,
                          connection: RtcConnection(channelId: controller.livestream.value.channel, localUid: SharedPreferencesHelper.getUserId()),
                          canvas: VideoCanvas(uid: controller.livestream.value.userId, sourceType: VideoSourceType.videoSourceRemote)),
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
                    lecturer: controller.livestream.value.user?.getOrganization() ?? "",
                    showThumb: (!(controller.livestream.value.isVideo &&
                        controller.isPlaying.value)),
                    // showThumb: ,
                    thumbPath: controller.livestream.value.user?.thumb ?? '',
                    title: controller.livestream.value.title,
                    // title: '',
                  )),
              LiveTopRightWidget(isLive: controller.isPlaying.value, isVideo: controller.livestream.value.isVideo,),
              Positioned(
                  bottom: 150,
                  right: 0,
                  left: 0,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    width: Get.width,
                    height: 250,
                    child: LiveMessagesWidget(
                      hostUserId: controller.livestream.value.userId,
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
            ListenerLiveControlsWidget(controller: controller),
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
