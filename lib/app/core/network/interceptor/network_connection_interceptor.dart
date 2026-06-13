import 'package:dio/dio.dart';
import 'package:price_sense/app/core/constants/app_constants.dart';
import 'package:price_sense/app/core/widget/app_snack_bar.dart';

final class NetworkConnectionInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
        AppSnackBar.networkError('Connection timed out. Your network may be slow — retrying…');
        handler.next(err.copyWith(message: 'connection_timeout'));

      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        AppSnackBar.networkError('Request timed out. Please check your connection speed.');
        handler.next(err.copyWith(message: 'request_timeout'));

      case DioExceptionType.connectionError:
        if ((err.requestOptions.extra['retries'] as int? ?? 0) >= AppConstants.maxRetryAttempts) {
          AppSnackBar.networkError('Unable to reach the server. Please check your connection.');
        }
        handler.next(err);
      case DioExceptionType.badResponse:
        final code = err.response?.statusCode;
        if (code != null && code >= 500) AppSnackBar.serverError(code);
        handler.next(err);
      default:
        handler.next(err);
    }
  }
}
