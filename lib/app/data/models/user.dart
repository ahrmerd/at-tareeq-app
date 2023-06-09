// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:at_tareeq/core/utils/helpers.dart';

User userFromJson(String str) => User.fromJson(json.decode(str));

List<User> userListFromJson(List<dynamic> json) =>
    json.map((data) => User.fromJson(data)).toList();

String userToJson(User data) => json.encode(data.toJson());

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNo,
    this.emailVerifiedAt,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    this.location,
    // this.googleId,
    this.organization,
    required this.thumb,
  });

  int id;
  String name;
  String email;
  String? phoneNo;
  DateTime? emailVerifiedAt;
  int type;
  DateTime createdAt;
  DateTime updatedAt;
  DateTime? deletedAt;
  String? location;
  // dynamic googleId;
  String? organization;
  String thumb;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        phoneNo: json["phone_no"],
        emailVerifiedAt: json["email_verified_at"],
        type: dynamicIntParsing(json["type"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        location: json["location"],
        // googleId: json["google_id"],
        organization: json["organization"],
        thumb: json["thumb"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "phone_no": phoneNo,
        "email_verified_at": emailVerifiedAt,
        "type": type,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt,
        "location": location,
        // "google_id": googleId,
        "organization": organization,
        "thumb": thumb,
      };
}
