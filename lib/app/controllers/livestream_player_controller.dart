import 'package:agora_rtc_engine/agora_rtc_engine.dart';
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

import 'host_live_controller.dart';

class LivestreamPlayerController extends GetxController {
  RxBool isPlaying = false.obs;
  Rx<Livestream> livestream = (Get.arguments['livestream'] as Livestream).obs;
  // final RtcEngine engine = createAgoraRtcEngine();
  late RtcEngine _engine;
  RtcEngine get engine => _engine;
  Rx<ProcessingStatus> liveProcessingStatus = ProcessingStatus.initial.obs;
  Rx<ProcessingStatus> messagesProcessingStatus = ProcessingStatus.initial.obs;
  RxBool isReady = false.obs;

  RxBool isAudioMuted = false.obs;
  RxBool isVideoMuted = false.obs;

  TextEditingController messageFieldControlller = TextEditingController();
  RxBool isSending = false.obs;
  ScrollController messageScrollController = ScrollController();
  RxList<LiveMessage> messages = <LiveMessage>[].obs;
  final clientOptions = ably.ClientOptions(key: ablyKey);
  late final ably.Realtime realtime;

  @override
  void onInit() async {
    _engine = createAgoraRtcEngine();
    try {
      await initAbly();
      await initAgora();
      fetchAllMessages();
    } on Exception catch (e) {
      Dependancies.errorService.addError(exception: e);
    } finally {
      super.onInit();
    }
  }

  initAbly() async {
    realtime = ably.Realtime(options: clientOptions);
    realtime.connection
        .on()
        .listen((ably.ConnectionStateChange stateChange) async {
      // if(stateChange.event);
      // Handle connection state change events
    });
    final channel = realtime.channels.get("public:${livestream.value.channel}");
    await channel.attach();
    channel.subscribe().listen((event) {
      if (event.name == Events.startLivestream) {
        livestream.value.status = LivestreamStatus.started;
        startPlaying();
      } else if (event.name == Events.stopLivestream) {
        livestream.value.status = LivestreamStatus.finished;
        stopPlaying();
        // leaveChannel();
      } else if (event.name == Events.livemessage) {
        fetchAllMessages();
        // addToMessages(event.data);
      } else {}
    });
  }

  Future<void> disposeAbly() async {
    await realtime.close();
  }

  @override
  void dispose() async {
    await disposeAgora();
    await disposeAbly();
    super.dispose();
  }

  Future<void> disposeAgora() async {
    await engine.leaveChannel();
    await engine.release();
  }

  Future<void> togglePlayer() async {
    if (isReady.value && !isPlaying.value) {
      await startPlaying();
    } else if (isReady.value && isPlaying.value) {
      await stopPlaying();
    }
  }

  Future<void> startPlaying() async {
    if (isReady.value) {
      await joinChannel();
      isPlaying.value = true;
    }
  }

  Future<void> stopPlaying() async {
    await leaveChannel();
    isPlaying.value = false;
  }

  Future<void> leaveChannel() async {
    await engine.leaveChannel();
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

  // void toggleMute() {
  //   if (isMuted.value) {
  //     muteStream();
  //     return;
  //   }
  //   unmuteStream();
  // }

  Future<void> joinChannel() async {
    await engine.enableLocalAudio(false);
    await engine.enableLocalVideo(false);
    if (livestream.value.isVideo) {
      await engine.muteAllRemoteVideoStreams(false);
    }
    await engine.joinChannel(
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
    // final permissionStatus = await requestPermissions();

    // //create the engine
    // _engine = createAgoraRtcEngine();
    try {
      await engine.initialize(const RtcEngineContext(
        appId: appId,
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
        audioScenario: AudioScenarioType.audioScenarioDefault,
        // logConfig: LogConfig()
      ));

      engine.registerEventHandler(RtcEngineEventHandler(onError: (err, _) {
        print(_);
      }
          // on
          ));
      if (livestream.value.isVideo) {
        await engine.enableVideo();
      } else {
        await engine.disableVideo();
      }
      // await _engine.disableVideo();
      await engine.setClientRole(role: ClientRoleType.clientRoleAudience);
      isReady.value = true;
    } catch (e) {
      isReady.value = false;
      liveProcessingStatus.value = ProcessingStatus.error;
    }
  }

  Future<void> fetchAllMessages([bool isRefresh = false]) async {
    if (isRefresh) {
      messagesProcessingStatus.value = ProcessingStatus.loading;
    }
    try {
      final res = (await LiveMessageRepository().fetchModelsFromCustomPath(
          "livestreams/${livestream.value.id}/messages"));
      messages.clear();
      messages.addAll(res);
      messages.refresh();

      messagesProcessingStatus.value = ProcessingStatus.success;
      // messagesProcessingStatus.value = ProcessingStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (messageScrollController.hasClients) {
          messageScrollController.animateTo(
              messageScrollController.position.maxScrollExtent + 100,
              duration: .5.seconds,
              curve: Curves.easeIn);
        }
      });
    } on Exception catch (e) {
      messagesProcessingStatus.value = ProcessingStatus.error;
      // print(e);
      Dependancies.errorService.addError(exception: e);
      // ApiClient.showErrorDialogue(e);
    }
  }

  Future<void> sendMessage(String strMsg) async {
    isSending.value = true;
    messages.add(LiveMessage.createSendingMessage(strMsg, livestream.value));
    messages.refresh();

    if (messageScrollController.hasClients) {
      messageScrollController.animateTo(
          messageScrollController.position.maxScrollExtent + 100,
          duration: .5.seconds,
          curve: Curves.easeIn);
    }
    final res = await Dependancies.http.post('livemessages',
        data: {"message": strMsg, "livestream_id": livestream.value.id});
    // print(res);
    messageFieldControlller.clear();
    isSending.value = false;
  }

  // void addToMessages(Object? data) {}
}
