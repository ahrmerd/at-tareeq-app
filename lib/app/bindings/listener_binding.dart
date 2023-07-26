import 'package:at_tareeq/app/controllers/browse_lectures_controller.dart';
import 'package:at_tareeq/app/controllers/lecture_list_controller.dart';
import 'package:at_tareeq/app/controllers/listen_now_controller.dart';
import 'package:at_tareeq/app/controllers/listener_controller.dart';
import 'package:get/get.dart';


class ListenerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListenerController>(() => ListenerController());
    Get.put<LectureListController>(LectureListController());
    Get.put<ListenNowController>(ListenNowController());
    Get.lazyPut<BrowseLecturesController>(() => BrowseLecturesController());
  }
}
