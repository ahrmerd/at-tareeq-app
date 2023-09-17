import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/library_item.dart';
import 'package:at_tareeq/app/data/providers/shared_preferences_helper.dart';
import 'package:at_tareeq/app/data/repositories/repository.dart';
import 'package:at_tareeq/app/dependancies.dart';
import 'package:get/get.dart';

class LibraryRepository extends Repository<LibraryItem> {
  static Future addToFavorite(Lecture lecture) async {
    await Dependancies.apiClient().req.post('favorites', data: {
      'lecture_id': lecture.id,
    });
  }

  static Future addToPlaylater(Lecture lecture) async {
    await Dependancies.apiClient().req.post('playlaters', data: {
      'lecture_id': lecture.id,
    });
  }

  static Future removeFromFavorite(int id) async {
    await Dependancies.apiClient().req.delete('favorites/$id');
  }

  static Future removeFromPlaylater(int id) async {
    await Dependancies.apiClient().req.delete(
          'playlaters/$id',
        );
  }

  static Future addToHistory(Lecture lecture) async {
    await Dependancies.http.post('histories', data: {
      'lecture_id': lecture.id,
    });
  }

  static Future refreshFavorites() async {
    // print((await Dependancies.apiClient().req.get('favorites')));
    final models =
        await LibraryRepository().fetchModelsFromCustomPath('favorites');
    // models.forEach((element) {
    // SharedPreferencesHelper.setFavorites()
    //  });
    SharedPreferencesHelper.addLecturesToFavorites(models);
    // SharedPreferencesHelper.setFavorites(models.map((e) => "${e.id}:${e.lectureId}").toList());
  }

  static Future refreshPlaylater() async {
    // print((await Dependancies.apiClient().req.get('favorites')));
    final models =
        await LibraryRepository().fetchModelsFromCustomPath('playlaters');
    SharedPreferencesHelper.addLecturesToPlaylaters(models);
  }

  @override
  String resource = 'lectures';

  @override
  transformModel(data) {
    return LibraryItem.fromJson(data);
  }

  @override
  List<LibraryItem> transformModels(data) {
    return libraryItemListFromJson(data);
  }
}

Future<void> addToPlaylater(Lecture lecture) async {
  await LibraryRepository.addToPlaylater(lecture);
  await LibraryRepository.refreshPlaylater();
  Get.snackbar(
      'SuccessFull', "you have added ${lecture.title} to your playlaters");
}

Future<void> addToFavorite(Lecture lecture) async {
  await LibraryRepository.addToFavorite(lecture);
  await LibraryRepository.refreshFavorites();

  Get.snackbar(
      'SuccessFull', "you have added ${lecture.title} to your favorites");
}

Future<void> removeFromPlaylater(LibraryItem item) async {
  await LibraryRepository.removeFromPlaylater(item.id);
  await LibraryRepository.refreshPlaylater();
  Get.snackbar('SuccessFull',
      "you have remove ${item.lecture.title} from your playlaters");
}

Future<void> removeFromFavorite(LibraryItem item) async {
  await LibraryRepository.removeFromFavorite(item.id);
  await LibraryRepository.refreshFavorites();

  Get.snackbar('SuccessFull',
      "you have removed ${item.lecture.title} from your favorites");
}
