import 'dart:convert';

import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/utils/helpers.dart';

import 'user.dart';

LiveMessage messageFromJson(String str) =>
    LiveMessage.fromJson(json.decode(str));

List<LiveMessage> liveMessageListFromJson(List<dynamic> json) =>
    List<LiveMessage>.from(json.map((x) => LiveMessage.fromJson(x)));

String messageToJson(LiveMessage data) => json.encode(data.toJson());

class LiveMessage {
  final String message;
  final int livestreamId;
  final int userId;
  final User user;
  int id;

  // final Livestream livestream;
  DateTime createdAt;
  final bool isSending;
  
  LiveMessage({
    required this.id,
    required this.message,
    required this.livestreamId,
    required this.userId,
    required this.user,
    required this.createdAt,
    // required this.livestream,
    this.isSending = false,
  });

  factory LiveMessage.fromJson(Map<String, dynamic> json) => LiveMessage(
        id: dynamicIntParsing(json["id"]),
        message: json["message"],
        livestreamId: dynamicIntParsing(json["livestream_id"]),
        userId: dynamicIntParsing(json["user_id"]),
        user: User.fromJson(Map<String, dynamic>.from(json["user"])),
        createdAt: DateTime.parse(json["created_at"]),
        // livestream: Livestream.fromJson(json["livestream"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "livestream_id": livestreamId,
        "user_id": userId,
        "user": user.toJson(),
      };

  static LiveMessage createSendingMessage(
      String message, Livestream livestream) {
    return LiveMessage(
        message: message,
        livestreamId: livestream.id,
        userId: SharedPreferencesHelper.getUserId(),
        user: User.createCurrUserDummy(),
        createdAt: DateTime.now(),
        // livestream: livestream,
        isSending: true, id: 0);
  }
}
