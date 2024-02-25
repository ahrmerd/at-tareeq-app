import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/listener_ivestream_controller.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/pages/livestream_layout.dart';
import 'package:at_tareeq/app/widgets/listener_live_controls_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ListenerLivestreamPage extends GetView<ListenerLivestreamController> {
  const ListenerLivestreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LivestreamLayout(
        controller: controller,
        agoraVideoView: AgoraVideoView(
          // remember for listenet use VideoViewController.remote
          controller: VideoViewController.remote(
              rtcEngine: controller.engine,
              connection: RtcConnection(
                  channelId: controller.livestream.channel,
                  localUid: SharedPreferencesHelper.getUserId()),
              canvas: VideoCanvas(
                  uid: controller.livestream.userId,
                  sourceType: VideoSourceType.videoSourceRemote)),
        ),
        livesControlWidget: ListenerLiveControlsWidget(
          controller: controller,
        ));
  }
}
