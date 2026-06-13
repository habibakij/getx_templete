import 'package:dio/dio.dart';

final class CustomBaseUrlInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final customBase = options.extra['baseUrl'] as String?;
    if (customBase != null && customBase.isNotEmpty) {
      final uri = Uri.parse(customBase).resolve(options.path);
      options.path = uri.toString();
      options.baseUrl = '';
    }
    handler.next(options);
  }
}
