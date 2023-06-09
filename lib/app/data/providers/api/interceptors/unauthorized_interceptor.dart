import 'package:at_tareeq/app/data/services/auth_service.dart';
import 'package:dio/dio.dart';

class UnAuthorizedInterceptor extends Interceptor {
  @override
  Future onError(DioError err, ErrorInterceptorHandler handler) async {
    print('hit');
    if (err.response?.statusCode == 403 || err.response?.statusCode == 401) {
      await AuthService.signOut();
    }
    return super.onError(err, handler);
  }
}
