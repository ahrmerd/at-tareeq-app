import 'package:at_tareeq/app/data/models/lecture.dart';
import 'package:at_tareeq/app/data/models/playlist.dart';
import 'package:at_tareeq/app/data/models/user.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/lecture_repository.dart';
import 'package:at_tareeq/app/data/repositories/playlist_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class PlaylistController extends GetxController
    with StateMixin<List<Playlist>> {
  // User user = User(id: 1, name: '3', email: 'ee', type: 5, thumb: 's');

  Future<void> fetchPlaylists() async {
    try {
      change(null, status: RxStatus.loading());
      List<Playlist> models = [];
      models = await PlaylistRepository().fetchModels(
        query: {"include": 'lectures'}
      );
      if (models.isEmpty) {
        change([], status: RxStatus.empty());
      } else {
        change(models, status: RxStatus.success());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Playlists'));
      ApiClient.showErrorDialogue(e);
    } catch (err) {
      showErrorDialogue();
      change(null, status: RxStatus.error('Failed to Load Lecturers'));
    }
  }

  @override
  void onInit() {
    fetchPlaylists();
    super.onInit();
  }
}
