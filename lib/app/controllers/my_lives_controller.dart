import 'package:at_tareeq/app/data/models/livestream.dart';
import 'package:at_tareeq/app/data/enums/livestream_status.dart';
import 'package:at_tareeq/app/data/providers/api/api_client.dart';
import 'package:at_tareeq/app/data/repositories/livestream_repository.dart';
import 'package:at_tareeq/core/utils/dialogues.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class MyLivesController extends GetxController
    with StateMixin<List<Livestream>> {
  int count = 6;
  @override
  Future<void> onInit() async {
    print('ye');
    fetchLivestreams();

    // TODO: implement onInit
    super.onInit();
  }

  Future fetchLivestreams() async {
    print('ye2');
    try {
      change(null, status: RxStatus.loading());
      List<Livestream> models = await LivestreamRepository()
          .fetchModelsFromCustomPath('livestreams/user');

      // models = livestreamListFromJson(
      //     (await (ApiClient.getInstance().req.get('livestreams/user')))
      //         .data['data']);

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
