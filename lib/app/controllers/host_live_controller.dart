import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:at_tareeq/app/data/enums/processing_status.dart';
import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/models/live_messages.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/live_message_repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:at_tareeq/core/utils/logger.dart';
import 'package:at_tareeq/core/values/const.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ably_flutter/ably_flutter.dart' as ably;

class Events {
  static String startLivestream = "App\\Events\\StartLiveEvent";
  static String stopLivestream = "App\\Events\\StopLiveEvent";
  static String livemessage = "App\\Events\\LiveMessageSentEvent";
}

class HostLiveController extends GetxController {
  Rx<ProcessingStatus> liveProcessingStatus = ProcessingStatus.initial.obs;
  Rx<ProcessingStatus> messagesProcessingStatus = ProcessingStatus.initial.obs;
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
  TextEditingController messageFieldControlller = TextEditingController();
  RxBool isSending = false.obs;
  ScrollController messageScrollController = ScrollController();

  RxList<LiveMessage> messages = <LiveMessage>[].obs;

  final clientOptions = ably.ClientOptions(key: ablyKey);

  late final ably.Realtime realtime;

  initAbly() async {
    realtime = ably.Realtime(options: clientOptions);
    realtime.connection
        .on()
        .listen((ably.ConnectionStateChange stateChange) async {
          // print(stateChange.current.toString());
      // if(stateChange.event);
      // Handle connection state change events
    });
    final channel = realtime.channels.get("public:${livestream.channel}");
    await channel.attach();
    // print(channel.name);
    channel.subscribe().listen((event) {
      // print(event);
      if (event.name == Events.startLivestream) {
        livestreamStatus.value = LivestreamStatus.started;
      } else if (event.name == Events.stopLivestream) {
        livestreamStatus.value = LivestreamStatus.finished;
      } else if (event.name == Events.livemessage) {
        fetchMessages();
        // addToMessages(event.data as Map);
      } else {

      }
    });
  }

  @override
  void onInit() async {
    // print(livestream.channel);
    try {
      initAbly();
      // print(Get.arguments);
      // initEcho();
      await initAgora();
      fetchMessages();
      super.onInit(); // }
    } catch (e) {
      showErrorDialogue(e.toString());
    }
  }

  void disposeAbly(){
    realtime.close();

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
    try {
      final permissionStatus = await requestPermissions();
      if (permissionStatus) {
        await _engine.initialize(const RtcEngineContext(
          appId: appId,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          audioScenario: AudioScenarioType.audioScenarioDefault,
          // logConfig: LogConfig()
        ));

        _engine.registerEventHandler(RtcEngineEventHandler(onError: (err, _) {
          handleAgoraError(err, _);
        }
            // on
            ));
        await _engine.disableVideo();
        await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
        liveProcessingStatus.value = ProcessingStatus.success;
        isReady = true;
      } else {
        liveProcessingStatus.value = ProcessingStatus.error;
        showErrorDialogue();
        isReady = false;
      }
    } catch (e) {
      isReady = false;
      liveProcessingStatus.value = ProcessingStatus.error;
    }

    // //create the engine
    // _engine = createAgoraRtcEngine();

    // if (permissionStatus) {
    // }
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
    if (isReady && !isLive.value) {
      try {
        await Dependancies.http()
            .get('livestreams/${livestream.id}/start-broadcast');
        await joinChannel();
        livestreamStatus.value = LivestreamStatus.started;
        livestream.status = LivestreamStatus.started;
        isLive.value = true;
      } catch (e) {
        Logger.log(e.toString());
        // print(e);
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

  void handleAgoraError(ErrorCodeType err, String message) {
    Logger.log('{${err.name}}-$message');
    showErrorDialogue(message);
  }

  // void submitForm() {}

  Future<void> sendMessage(String strMsg) async {
    isSending.value = true;
    messages.add(LiveMessage.createSendingMessage(strMsg, livestream));
    messageScrollController.animateTo(
        messageScrollController.position.maxScrollExtent + 100,
        duration: .5.seconds,
        curve: Curves.easeIn);
    final res = await Dependancies.http().post('livemessages',
        data: {"message": strMsg, "livestream_id": livestream.id});
    // print(res);
    messageFieldControlller.clear();
    isSending.value = false;

    // fetchMessages();
  }

  Future<void> fetchMessages() async {
    try {
      final res = (await LiveMessageRepository()
          .fetchModelsFromCustomPath("livestreams/${livestream.id}/messages"));
      messages.clear();
      messages.addAll(res);
      messagesProcessingStatus.value = ProcessingStatus.success;

    } on DioError catch (e) {
      messagesProcessingStatus.value = ProcessingStatus.error;
      // print(e);
      ApiClient.showErrorDialogue(e);
    } catch (err) {
      // print(err);
      messagesProcessingStatus.value = ProcessingStatus.error;
      showErrorDialogue(err.toString());
    }
  }

  void addToMessages(Map data) {
            // print(data.runtimeType);
            final messageMap =Map<String, dynamic>.from(data['message']);
            print(messageMap);
           final message = LiveMessage.fromJson(messageMap);
            // print(message.toJson());
            // print( as Map));
        // print(event.name);
        // print(event.data);
  }
}
