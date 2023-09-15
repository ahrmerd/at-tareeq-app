import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:at_tareeq/app/data/services/error_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

import 'data/providers/api/api_client.dart';
import 'data/providers/shared_preferences_helper.dart';

class Dependancies {
  static Future<void> init() async {
    await SharedPreferencesHelper.init();
    Get.put(ApiClient());
    await Get.putAsync(() => AuthService().init());
    Get.put(AudioPlayer());
    Get.put(ErrorService());
    // await NotificationService.initializeLocalNotifications();
  }

  static AudioPlayer audioPlayer() => Get.find<AudioPlayer>();
  static ErrorService get errorService => Get.find<ErrorService>();

  static ApiClient apiClient() => Get.find<ApiClient>();
  static Dio http() => apiClient().req;
  static AuthService authService() => Get.find<AuthService>();
}
