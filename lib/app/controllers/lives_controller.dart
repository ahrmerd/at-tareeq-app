import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/livestream_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class LivesController extends GetxController with StateMixin<List<Livestream>> {
  // int count = 6;
  @override
  Future<void> onInit() async {
    fetchLivestreams();

    // TODO: implement onInit
    super.onInit();
  }

  Future fetchLivestreams() async {
    try {
      change(null, status: RxStatus.loading());
      List<Livestream> models =
          await LivestreamRepository().fetchModels(query: {"include": "user"});
      if (models.isEmpty) {
        change(models, status: RxStatus.empty());
      } else {
        change(models, status: RxStatus.success());
      }
    } on DioError catch (e) {
      change(null, status: RxStatus.error('Failed to Load Lectures'));
      ApiClient.showErrorDialogue(e);
      print(e);
    } catch (err) {
      print(err);
      showErrorDialogue();
      change(null, status: RxStatus.error('Failed to Load Lecturers'));
    }
  }
}
