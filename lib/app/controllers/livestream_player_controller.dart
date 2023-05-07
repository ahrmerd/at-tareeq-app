import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class LivestreamPlayerController extends GetxController {
  RxBool isPlaying = false.obs;
  Rx<Livestream> livestream = (Get.arguments['livestream'] as Livestream).obs;
  final RtcEngine _engine = createAgoraRtcEngine();
  ProcessingStatus processingStatus = ProcessingStatus.initial;
  bool isReady = false;

  RxBool isMuted = true.obs;

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

  Future<void> togglePlayer() async {
    if (isReady && !isPlaying.value) {
      await joinChannel();
      isPlaying.value = true;
    } else if (isReady && isPlaying.value) {
      await leaveChannel();
      isPlaying.value = false;
    }
  }

  Future<void> leaveChannel() async {
    await _engine.leaveChannel();
  }

  Future<void> muteStream() async {
    await _engine.muteAllRemoteAudioStreams(true);
    isMuted.value = true;
  }

  Future<void> unmuteStream() async {
    await _engine.muteAllRemoteAudioStreams(false);
    isMuted.value = false;
  }

  void toggleMute() {
    if (isMuted.value) {
      muteStream();
      return;
    }
    unmuteStream();
  }

  Future<void> joinChannel() async {
    await _engine.enableLocalAudio(false);
    await _engine.joinChannel(
      token: livestream.value.token ?? '',
      channelId: livestream.value.channel,
      uid: SharedPreferencesHelper.getUserId(),
      options: const ChannelMediaOptions(
        autoSubscribeVideo: false,
        autoSubscribeAudio: true,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        clientRoleType: ClientRoleType.clientRoleAudience,
      ),
    );
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
    await _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
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
}
