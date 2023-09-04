// To parse this JSON data, do
//
//     final playlist = playlistFromJson(jsonString);

import 'dart:convert';

import 'package:at_tareeq/app/data/models/lecture.dart';

List<Playlist> playlistFromJson(String str) => List<Playlist>.from(json.decode(str).map((x) => Playlist.fromJson(x)));
List<Playlist> playlistListFromJson(List<dynamic> json) =>
    json.map((data) => Playlist.fromJson(data)).toList();


String playlistToJson(List<Playlist> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Playlist {
    int id;
    String name;
    int userId;
    DateTime createdAt;
    DateTime updatedAt;
    List<Lecture>? lectures;

    Playlist({
        required this.id,
        required this.name,
        required this.userId,
        required this.createdAt,
        required this.updatedAt,
        this.lectures,
    });

    factory Playlist.fromJson(Map<String, dynamic> json) => Playlist(
        id: json["id"],
        name: json["name"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        lectures: json["lectures"] == null ? [] : List<Lecture>.from(json["lectures"]!.map((x) => Lecture.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "lectures": lectures == null ? [] : List<dynamic>.from(lectures!.map((x) => x.toJson())),
    };
}

