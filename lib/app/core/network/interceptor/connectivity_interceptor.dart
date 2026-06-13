import 'package:dio/dio.dart';
import 'package:price_sense/app/core/service/connectivity_service.dart';
import 'package:price_sense/app/core/widget/app_snack_bar.dart';

final class ConnectivityInterceptor extends Interceptor {
  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if ((options.extra['retries'] as int? ?? 0) > 0) return handler.next(options);

    final online = await ConnectivityService.to.hasConnection;
    if (!online) {
      AppSnackBar.networkError('No internet connection. Please check your network and try again.');
      return handler.reject(DioException(requestOptions: options, type: DioExceptionType.connectionError, message: 'no_internet'), true);
    }
    handler.next(options);
  }
}
