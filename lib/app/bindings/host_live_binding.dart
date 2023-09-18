import 'package:at_tareeq/app/controllers/add_live_controller.dart';
import 'package:at_tareeq/app/controllers/host_livestream_controller.dart';
import 'package:get/get.dart';

class HostLiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLiveController>(
      () => AddLiveController(),
    );
    Get.lazyPut<HostLivestreamController>(
      () => HostLivestreamController(),
    );
  }
}
