import 'package:at_tareeq/app/pages/maintenance_mode_page.dart';
import 'package:at_tareeq/app/pages/require_update_page.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';

class RequireUpdateOrMaintenanceInterceptor extends Interceptor {
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 426) {
      // print(err.response?.data);
      String? url;
      if (err.response?.data is Map) {
        url = err.response?.data['url'];
      } else {
        // print(err.requestOptions.path);
      }
      return Get.offAll(() => RequireUpdatePage(
            url: url,
          ));
      // await AuthService.signOut();
    } else if (err.response?.statusCode == 503) {
      return Get.offAll(() => const MaintenanceModePage());
    }
    return super.onError(err, handler);
  }
}
