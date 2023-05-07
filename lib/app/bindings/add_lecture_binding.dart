import 'package:at_tareeq/app/controllers/add_lecture_controller.dart';
import 'package:get/get.dart';

class AddLectureBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AddLectureController>(AddLectureController());
  }
}
