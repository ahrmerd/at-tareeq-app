import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/controllers/livestream_controller.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';

// class Events {
//   static String startLivestream = "App\\Events\\StartLiveEvent";
//   static String stopLivestream = "App\\Events\\StopLiveEvent";
//   static String livemessage = "App\\Events\\LiveMessageSentEvent";
// }

class HostLivestreamController extends LiveStreamController {
  @override
  ClientRoleType get clientRole => ClientRoleType.clientRoleBroadcaster;

  // dont remove ClientRoleType get clientRoleType => ClientRoleType.clientRoleBroadcaster;

  @override
  Future<void> onInit() async {
    await super.onInit();
    await engine.enableLocalAudio(true);
    if (livestream.isVideo) {
      await engine.enableLocalVideo(true);
    }
    try {
      final permissionStatus =
          await requestPermissions(); //host alone in oninit
      if (!permissionStatus) {
        liveProcessingStatus.value = ProcessingStatus.error;
        Dependancies.errorService
            .addError(exception: Exception('Please accept all permissions'));
        // showErrorDialogue();
        isReady.value = false;
      }
      //ask for permissions
    } on Exception catch (e) {
      Dependancies.errorService.addError(exception: e);
    } finally {
      super.onInit();
    }
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid || Platform.isIOS) {
      final statuses =
          await [Permission.microphone, Permission.camera].request();
      for (var status in statuses.values) {
        if (status.isDenied && status.isLimited) {
          return false;
        }
      }
      return true;
      // final permissionStatus = await Permission.microphone.request();
      // if (permissionStatus.isGranted) {
      //   return true;
      // }
    } else {
      return true;
    }
  }

  Future<void> startBroadcast() async {
    if (isReady.value && !isLive.value) {
      try {
        await engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        liveProcessingStatus.value = ProcessingStatus.success;
        await joinChannel();
        await Dependancies.http
            .get('livestreams/${livestream.id}/start-broadcast');
        livestreamStatus.value = LivestreamStatus.started;
        livestream.status = LivestreamStatus.started;
        isLive.value = true;
        engine.startPreview();
      } on Exception catch (e) {
        Dependancies.errorService.addError(exception: e);
        Logger.log(e.toString());
      }
    }
  }

  Future<void> muteAudioBroadcast() async {
    await engine.muteLocalAudioStream(true);
    isAudioMuted.value = true;
  }

  Future<void> muteVideoBroadcast() async {
    await engine.muteLocalVideoStream(true);
    isVideoMuted.value = true;
  }

  Future<void> unmuteAudioBroadcast() async {
    await engine.muteLocalAudioStream(false);
    isAudioMuted.value = false;
  }

  Future<void> unmuteVideoBroadcast() async {
    await engine.muteLocalVideoStream(false);
    isVideoMuted.value = false;
  }

  Future<void> switchCamera() async {
    await engine.switchCamera();
  }

  Future<void> toggleFlash(bool shouldOn) async {
    if (await engine.isCameraTorchSupported()) {
      engine.setCameraTorchOn(shouldOn);
    }
  }

  Future<void> stopBroadcast() async {
    if (isReady.value) {
      try {
        await Dependancies.http
            .get('livestreams/${livestream.id}/end-broadcast');
        await leaveChannel();
        isLive.value = false;
        livestream.status = LivestreamStatus.finished;
        livestreamStatus.value = LivestreamStatus.finished;
      } on Exception catch (e) {
        Dependancies.errorService.addError(exception: e);
      }
    }
  }

  // void submitForm() {}

  // @override
  // void addToMessages(Map data) {
  //   // print(data.runtimeType);
  //   final messageMap = Map<String, dynamic>.from(data['message']);
  //   print(messageMap);
  //   final message = LiveMessage.fromJson(messageMap);
  //   // print(message.toJson());
  //   // print( as Map));
  //   // print(event.name);
  //   // print(event.data);
  // }
}
