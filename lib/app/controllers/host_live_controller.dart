import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class HostLiveController extends GetxController {
  @override
  ProcessingStatus processingStatus = ProcessingStatus.initial;
  Livestream livestream = Get.arguments['livestream'];
  Rx<LivestreamStatus> livestreamStatus =
      (Get.arguments['livestream'] as Livestream).status.obs;
  // PermissionStatus _permissionStatus = PermissionStatus.limited;
  RxBool isMuted = false.obs;
  // PermissionStatus broadcastingStatus = PermissionStatus.limited;
  final RtcEngine _engine = createAgoraRtcEngine();
  // late Echo<PusherClient, PusherChannel> _echo;
  bool isReady = false;
  RxBool isLive = false.obs;

  @override
  void onInit() async {
    // print(Get.arguments);
    // initEcho();
    await initAgora();
    super.onInit(); // }
  }

  @override
  void dispose() async {
    await disposeAgora();
    super.dispose();
  }

  Future<void> disposeAgora() async {
    await _engine.leaveChannel();
    await _engine.release();
  }

  Future<void> initAgora() async {
    // retrieve permissions
    final permissionStatus = await requestPermissions();

    // //create the engine
    // _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      audioScenario: AudioScenarioType.audioScenarioDefault,
      // logConfig: LogConfig()
    ));

    _engine.registerEventHandler(RtcEngineEventHandler(onError: (err, _) {
      print(_);
    }
        // on
        ));
    await _engine.disableVideo();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    if (permissionStatus) {
      isReady = true;
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final permissionStatus = await Permission.microphone.request();
      if (permissionStatus.isGranted) {
        return true;
      }
      return false;
    } else {
      return true;
    }
  }

//   void initEcho() {
//     PusherOptions options = PusherOptions(
//       // wssPort: 443,
//       host: 'realtime-pusher.ably.io',
//       // wsPort: 6001,
//       encrypted: false,
//     );

//     PusherClient pusher = PusherClient(
//       ablyKey,
//       options,
//       // autoConnect: false
//     );
// // Create echo instance
//     _echo = Echo(PusherConnector(pusher));
//     // _echo = Echo({'broadcaster': 'ably', 'client': pusher});
//     _echo.channel('public-channel').listen('PublicEvent', (e) {
//       print(e);
//     });
//   }

  Future<void> startBroadcast() async {
    if (isReady) {
      try {
        await Dependancies.http()
            .get('livestreams/${livestream.id}/start-broadcast');
        await joinChannel();
        livestreamStatus.value = LivestreamStatus.started;
        livestream.status = LivestreamStatus.started;
        isLive.value = true;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> joinChannel() async {
    await _engine.enableLocalAudio(true);
    await _engine.joinChannel(
      token: livestream.token ?? '',
      channelId: livestream.channel,
      uid: SharedPreferencesHelper.getUserId(),
      options: const ChannelMediaOptions(
        autoSubscribeVideo: false,
        autoSubscribeAudio: true,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
      ),
    );
  }

  Future<void> muteBroadcast() async {
    await _engine.muteLocalAudioStream(true);
    isMuted.value = true;
  }

  Future<void> unmuteBroadcast() async {
    await _engine.muteLocalAudioStream(false);
    isMuted.value = false;
  }

  Future<void> stopBroadcast() async {
    if (isReady) {
      try {
        await Dependancies.http()
            .get('livestreams/${livestream.id}/end-broadcast');
        await leaveChannel();
        isLive.value = false;
        livestream.status = LivestreamStatus.finished;
        livestreamStatus.value = LivestreamStatus.finished;
      } catch (e) {
        print(e);
      }
    }
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }
}
