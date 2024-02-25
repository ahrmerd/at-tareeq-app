import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:dio/dio.dart';

class UnAuthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      await AuthService.signOut();
    }
    return super.onError(err, handler);
  }
}
