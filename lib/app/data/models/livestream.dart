import 'dart:convert';

import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/utils/helpers.dart';

List<Livestream> livestreamListFromJson(List<dynamic> json) =>
    List<Livestream>.from(json.map((x) => Livestream.fromJson(x)));

String livestreamToJson(List<Livestream> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Livestream {
  Livestream({
    required this.id,
    required this.title,
    required this.description,
    required this.interestId,
    required this.userId,
    required this.status,
    required this.channel,
    required this.startTime,
    required this.createdAt,
    required this.updatedAt,
    required this.isVideo,
    this.deletedAt,
    this.token,
    this.user,
  });

  int id;
  String title;
  String description;
  int interestId;
  int userId;
  LivestreamStatus status;
  String channel;
  DateTime startTime;
  DateTime createdAt;
  DateTime updatedAt;
  dynamic deletedAt;
  String? token;
  User? user;
  bool isVideo;

  factory Livestream.fromJson(Map<String, dynamic> json) => Livestream(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        interestId: dynamicIntParsing(json["interest_id"]),
        userId: dynamicIntParsing(json["user_id"]),
        status: LivestreamStatus.fromInt(dynamicIntParsing(json["status"])),
        channel: json["channel"],
        startTime: DateTime.parse(json["start_time"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        token: json["token"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),
        isVideo: json["is_video"]
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "interest_id": interestId,
        "user_id": userId,
        "status": status.value,
        "channel": channel,
        "start_time": startTime.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "token": token,
        "user": user?.toJson(),
        "is_video": isVideo,
      };

  static Livestream createDummy() {
    return Livestream(
        id: 0,
        title: "title",
        description: "description",
        interestId: 0,
        userId: 0,
        status: LivestreamStatus.notStarted,
        channel: "channel",
        startTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isVideo: false,
        );
  }

  static Livestream createDummyForUser() {
    return Livestream(
        id: 0,
        title: "title",
        description: "description",
        interestId: 0,
        userId: SharedPreferencesHelper.getUserId(),
        status: LivestreamStatus.notStarted,
        channel: "channel",
        startTime: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isVideo: false
        );
  }
}
