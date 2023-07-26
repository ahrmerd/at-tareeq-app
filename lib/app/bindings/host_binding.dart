import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:get/get.dart';


class HostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostController>(
      () => HostController(),
    );
  }
}
