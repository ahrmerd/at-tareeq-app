import 'package:at_tareeq/app/controllers/login_controller.dart';
import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:get/get.dart';

import '../controllers/register_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(),
    );
  }
}
