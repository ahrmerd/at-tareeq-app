import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/livestream_controller.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/live_message_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

import 'host_livestream_controller.dart';

class ListenerLivestreamController extends LiveStreamController {
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
