import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/core/utils/helpers.dart';

List<LibraryItem> libraryItemListFromJson(List<dynamic> json) =>
    json.map((data) => LibraryItem.fromJson(data)).toList();

class LibraryItem {
  int id;
  int userId;
  int lectureId;
  DateTime createdAt;
  DateTime updatedAt;
  Lecture lecture;

  LibraryItem({
    required this.id,
    required this.userId,
    required this.lectureId,
    required this.createdAt,
    required this.updatedAt,
    required this.lecture,
  });


  factory LibraryItem.fromJson(Map<String, dynamic> json) => LibraryItem(
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


      static LibraryItem fromLecture(int id, Lecture lecture) {
    return LibraryItem(
        id: id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        lecture: lecture, lectureId: lecture.id, userId: SharedPreferencesHelper.getUserId()
        );
  }
}
