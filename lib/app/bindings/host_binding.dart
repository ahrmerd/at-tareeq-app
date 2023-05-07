import 'package:at_tareeq/app/controllers/host_controller.dart';
import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class HostBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostController>(
      () => HostController(),
    );
  }
}
