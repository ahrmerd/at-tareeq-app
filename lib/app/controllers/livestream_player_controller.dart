import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/live_message_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

import 'host_live_controller.dart';

class LivestreamPlayerController extends GetxController {
  RxBool isPlaying = false.obs;
  Rx<Livestream> livestream = (Get.arguments['livestream'] as Livestream).obs;
  final RtcEngine _engine = createAgoraRtcEngine();
  Rx<ProcessingStatus> liveProcessingStatus = ProcessingStatus.initial.obs;
  Rx<ProcessingStatus> messgaeprocessingStatus = ProcessingStatus.initial.obs;
  bool isReady = false;

  RxBool isMuted = true.obs;

  TextEditingController messageFieldControlller = TextEditingController();
  RxBool isSending = false.obs;
  ScrollController messageScrollController = ScrollController();
  RxList<LiveMessage> messages = <LiveMessage>[].obs;
  final clientOptions = ably.ClientOptions(key: ablyKey);
  late final ably.Realtime realtime;

  @override
  void onInit() async {
    await initAbly();
    // print(Get.arguments);
    // initEcho();
    await initAgora();
    super.onInit(); // }
  }

  initAbly() async {
    realtime = ably.Realtime(options: clientOptions);
    realtime.connection
        .on()
        .listen((ably.ConnectionStateChange stateChange) async {
      // if(stateChange.event);
      // Handle connection state change events
    });
    final channel = realtime.channels.get(livestream.value.channel);
    await channel.attach();
    channel.subscribe().listen((event) {
      if (event.name == Events.startLivestream) {
        livestream.value.status = LivestreamStatus.started;
      } else if (event.name == Events.stopLivestream) {
        livestream.value.status = LivestreamStatus.finished;
      } else if (event.name == Events.livemessage) {
        fetchMessages();
        addToMessages(event.data);
      } else {
        print(event.data.runtimeType);
        print(event.name);
        print(event.data);
      }
    });
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

  Future<void> fetchMessages() async {
    final res = (await LiveMessageRepository().fetchModelsFromCustomPath(
        "livestreams/${livestream.value.id}/messages"));
    print(res);
    messages.clear();
    messages.addAll(res);
  }

  Future<void> sendMessage(String strMsg) async {
    isSending.value = true;
    messages.add(LiveMessage.createSendingMessage(strMsg, livestream.value));
    messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent + 100,
        duration: .5.seconds,
        curve: Curves.easeIn);
    final res = await Dependancies.http().post('livemessages',
        data: {"message": strMsg, "livestream_id": livestream.value.id});
    // print(res);
    messageFieldControlller.clear();
    isSending.value = false;

    fetchMessages();
  }

  void addToMessages(Object? data) {}
}
