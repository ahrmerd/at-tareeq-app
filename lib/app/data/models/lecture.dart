// To parse this JSON data, do
//
//     final lecture = lectureFromJson(jsonString);

import 'dart:convert';

import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/core/utils/helpers.dart';

Lecture lectureFromJson(Map<String, dynamic> json) => Lecture.fromJson(json);

List<Lecture> lectureListFromJson(List<dynamic> json) =>
    json.map((data) => Lecture.fromJson(data)).toList();

List<Lecture> libraryLectureListFromJson(List<dynamic> json) =>
    json.map((data) => Lecture.fromJson(data['lecture'])).toList();

String lectureToJson(Lecture data) => json.encode(data.toJson());

class Lecture {
  Lecture({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.title,
    required this.path,
    required this.live,
    required this.approved,
    required this.userId,
    required this.interestId,
    required this.duration,
    this.description,
    this.deletedAt,
    required this.downloaded,
    required this.url,
    this.thumb,
    this.user
  });

  int id;
  DateTime createdAt;
  DateTime updatedAt;
  String title;
  String path;
  bool live;
  bool? approved;
  int userId;
  int interestId;
  int duration;
  String? description;
  dynamic deletedAt;
  String downloaded;
  String url;
  String? thumb;
  User? user;

  factory Lecture.fromJson(Map<String, dynamic> json) => Lecture(
        id: json["id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        title: json["title"],
        path: json["path"],
        live: json["live"],
        approved: json["approved"],
        userId: dynamicIntParsing(json["user_id"]),
        interestId: dynamicIntParsing(json["interest_id"]),
        duration: dynamicIntParsing(json["duration"]),
        description: json["description"],
        deletedAt: json["deleted_at"],
        downloaded: json["downloaded"],
        url: json["url"],
        thumb: json["thumb"],
        user: json["user"] == null ? null : User.fromJson(json["user"]),

      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "title": title,
        "path": path,
        "live": live,
        "visible": approved,
        "user_id": userId,
        "interest_id": interestId,
        "duration": duration,
        "description": description,
        "deleted_at": deletedAt,
        "downloaded": downloaded,
        "url": url,
        "thumb": thumb??"",
        "user": user?.toJson()?? "",
      };
}
