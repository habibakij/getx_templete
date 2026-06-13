import 'dart:math';

import 'package:dio/dio.dart';
import 'package:price_sense/app/core/constants/app_constants.dart';

final class RetryInterceptor extends Interceptor {
  final Dio _dio;
  static final _rng = Random();
  RetryInterceptor(this._dio);

  static const _retryAbleTypes = {DioExceptionType.connectionTimeout, DioExceptionType.receiveTimeout, DioExceptionType.connectionError};

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    final opts = err.requestOptions;
    final retries = opts.extra['retries'] as int? ?? 0;
    final noRetry = opts.extra['noRetry'] as bool? ?? false;

    final shouldRetry = !noRetry && _retryAbleTypes.contains(err.type) && retries < AppConstants.maxRetryAttempts;

    if (!shouldRetry) return handler.next(err);

    // Exponential back-off: base * 2^attempt + jitter(0..300ms)
    final delay = AppConstants.retryBaseDelay * pow(2, retries).toInt() + _rng.nextInt(300);
    await Future.delayed(Duration(milliseconds: delay));
    opts.extra['retries'] = retries + 1;
    try {
      return handler.resolve(await _dio.fetch(opts));
    } on DioException catch (retryErr) {
      return handler.next(retryErr);
    }
  }
}
