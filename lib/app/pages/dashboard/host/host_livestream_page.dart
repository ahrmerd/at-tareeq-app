import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/host_livestream_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/pages/livestream_layout.dart';
import 'package:at_tareeq/app/widgets/host_live_controls_widget.dart';
import 'package:at_tareeq/app/widgets/live_messages_widget.dart';
import 'package:at_tareeq/app/widgets/send_live_message_widget.dart';
import 'package:at_tareeq/app/widgets/livestream_info_widget.dart';
import 'package:at_tareeq/app/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class HostLivestreamPage extends GetView<HostLivestreamController> {
  const HostLivestreamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return LivestreamLayout(
        controller: controller,
        agoraVideoView: AgoraVideoView(
          //                     // remember for listenet use VideoViewController.remote
          controller: VideoViewController(
              rtcEngine: controller.engine, canvas: const VideoCanvas(uid: 0)),
        ),
        livesControlWidget: HostLiveControlsWidget(
          controller: controller,
        ));
  }
}
