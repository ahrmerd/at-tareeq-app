import 'package:at_tareeq/app/controllers/livestream_player_controller.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:at_tareeq/core/themes/colors.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LivestreamPlayer extends GetView<LivestreamPlayerController> {
  const LivestreamPlayer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      backgroundColor: primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                controller.togglePlayer();
              },
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: primaryLightColor,
                ),
                child: Icon(
                  Icons.music_note,
                  size: 100,
                  color: primaryDarkColor,
                ),
              ),
            ),
            SizedBox(height: 20),
            Obx(() => Text(
                  controller.livestream.value.title,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                )),
            SizedBox(height: 20),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.isPlaying.value ? "LIVE" : "",
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (controller.isPlaying.value)
                      AvatarGlow(
                        glowColor: Colors.redAccent,
                        endRadius: 20,
                        child: Container(
                          // height: 30,
                          decoration:
                              const BoxDecoration(shape: BoxShape.circle),
                          child: const Icon(
                            Icons.fiber_manual_record_rounded,
                            color: Colors.red,
                          ),
                        ),
                      )
                  ],
                )),
            SizedBox(height: 20),
            Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    MyButton(
                      onTap: () {
                        controller.togglePlayer();
                      },
                      child: Icon(
                        controller.isPlaying.value
                            ? Icons.stop
                            : Icons.play_arrow,
                        color: lightColor,
                      ),
                      danger: false,
                      color: lightColor,
                      bgColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                    SizedBox(width: 10),
                    MyButton(
                      onTap: () {
                        controller.toggleMute();
                      },
                      child: Icon(
                        controller.isMuted.value
                            ? Icons.volume_up_outlined
                            : Icons.volume_off,
                        color: lightColor,
                      ),
                      danger: false,
                      color: lightColor,
                      bgColor: primaryColor,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                    ),
                  ],
                )),
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
