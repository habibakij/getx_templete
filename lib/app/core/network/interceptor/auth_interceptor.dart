import 'dart:async';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/network/api_endpoint.dart';
import 'package:price_sense/app/core/service/secure_store_service.dart';
import 'package:price_sense/app/core/widget/app_snack_bar.dart';

final class AuthInterceptor extends Interceptor {
  final Dio _dio;
  final storage = Get.find<SecureStorageService>();
  AuthInterceptor(this._dio);
  Completer<String>? _refreshCompleter;
  static const _publicPaths = {ApiEndpoints.login, ApiEndpoints.refreshToken};

  @override
  Future<void> onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (_isPublic(options.path)) return handler.next(options);
    final token = storage.getAccessToken();
    options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  Future<void> onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401 || _isPublic(err.requestOptions.path)) {
      return handler.next(err);
    }
    if (_refreshCompleter != null) {
      try {
        final newToken = await _refreshCompleter!.future;
        err.requestOptions.headers['Authorization'] = 'Bearer $newToken';
        return handler.resolve(await _dio.fetch(err.requestOptions));
      } catch (_) {
        return handler.next(err);
      }
    }
    _refreshCompleter = Completer<String>();

    try {
      final refreshToken = storage.getRefreshToken();
      final res = await _dio.post(ApiEndpoints.refreshToken, data: {'refresh_token': refreshToken});
      final newAccess = res.data['access_token'] as String;
      final newRefresh = res.data['refresh_token'] as String;
      await storage.saveAccessToken(newAccess);
      await storage.saveRefreshToken(newRefresh);
      _refreshCompleter!.complete(newAccess);
      err.requestOptions.headers['Authorization'] = 'Bearer $newAccess';
      return handler.resolve(await _dio.fetch(err.requestOptions));
    } catch (err2) {
      _refreshCompleter!.completeError(err2); // unblock queued with error
      await storage.clearAll();
      AppSnackBar.tokenExpired();
      // Navigate to login — replace with your route name.
      Get.offAllNamed('/login');
      handler.reject(err);
    } finally {
      _refreshCompleter = null;
    }
  }

  bool _isPublic(String path) => _publicPaths.any((p) => path.contains(p));
}
