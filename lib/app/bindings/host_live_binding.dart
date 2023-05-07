import 'package:at_tareeq/app/controllers/add_live_controller.dart';
import 'package:at_tareeq/app/controllers/host_live_controller.dart';
import 'package:at_tareeq/app/controllers/my_lives_controller.dart';
import 'package:get/get.dart';

class HostLiveBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddLiveController>(
      () => AddLiveController(),
    );

    Get.lazyPut<MyLivesController>(
      () => MyLivesController(),
    );

    Get.lazyPut<HostLiveController>(
      () => HostLiveController(),
    );
  }
}
