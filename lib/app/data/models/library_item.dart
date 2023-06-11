import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/core/utils/helpers.dart';

class Library {
  int id;
  int userId;
  int lectureId;
  DateTime createdAt;
  DateTime updatedAt;
  Lecture lecture;

  Library({
    required this.id,
    required this.userId,
    required this.lectureId,
    required this.createdAt,
    required this.updatedAt,
    required this.lecture,
  });

  factory Library.fromJson(Map<String, dynamic> json) => Library(
        id: json["id"],
        userId: json["user_id"],
        lectureId: dynamicIntParsing(json["lecture_id"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        lecture: Lecture.fromJson(json["lecture"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "lecture_id": lectureId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "lecture": lecture.toJson(),
      };
}
