import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:get/get.dart';

class LibraryRepository {
  static Future addToFavorite(Lecture lecture) async {
    await Dependancies.http().post('favorites', data: {
      'lecture_id': lecture.id,
    });
  }

  static Future addToPlaylater(Lecture lecture) async {
    await Dependancies.http().post('playlaters', data: {
      'lecture_id': lecture.id,
    });
  }
}

Future<void> addToPlaylater(Lecture lecture) async {
  await LibraryRepository.addToPlaylater(lecture);
  Get.snackbar(
      'SuccessFull', "you have added ${lecture.title} to your playlaters");
}

Future<void> addToFavorite(Lecture lecture) async {
  await LibraryRepository.addToFavorite(lecture);
  Get.snackbar(
      'SuccessFull', "you have added ${lecture.title} to your favorites");
}
