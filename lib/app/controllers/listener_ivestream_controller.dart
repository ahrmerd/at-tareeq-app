import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/livestream_controller.dart';
import 'package:at_tareeq/app/dependancies.dart';


class ListenerLivestreamController extends LiveStreamController {
  @override
  ClientRoleType get clientRole => ClientRoleType.clientRoleAudience;

  // RxBool isPlaying = false.obs;

  @override
  Future<void> onInit() async {
    await super.onInit();
    // _engine = createAgoraRtcEngine();
    try {
      // await initAbly();
      // await initAgora();
      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      await engine.enableLocalAudio(false);
      await engine.enableLocalVideo(false);
      if (livestream.isVideo) {
        await engine.muteAllRemoteVideoStreams(false);
      }
    } on Exception catch (e) {
      Dependancies.errorService.addError(exception: e);
    } finally {
      super.onInit();
    }
  }

  Future<void> togglePlayer() async {
    if (isReady.value && !isLive.value) {
      await startPlaying();
    } else if (isReady.value && isLive.value) {
      await stopPlaying();
    }
  }

  Future<void> startPlaying() async {
    if (isReady.value) {
      await joinChannel();
      isLive.value = true;
    }
  }

  Future<void> stopPlaying() async {
    await leaveChannel();
    isLive.value = false;
  }

  Future<void> muteAudioStream() async {
    await engine.muteAllRemoteAudioStreams(true);
    isAudioMuted.value = true;
  }

  Future<void> muteVideoStream() async {
    await engine.muteAllRemoteVideoStreams(true);
    isVideoMuted.value = true;
  }

  Future<void> unmuteAudioStream() async {
    await engine.muteAllRemoteAudioStreams(false);
    isAudioMuted.value = false;
  }

  Future<void> unmuteVideoStream() async {
    await engine.muteAllRemoteVideoStreams(false);
    isVideoMuted.value = false;
  }
}
