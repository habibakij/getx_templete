import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:get/get.dart' hide Response;
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:price_sense/app/core/constants/app_constants.dart';
import 'package:price_sense/app/core/network/api_endpoint.dart';
import 'package:price_sense/app/core/network/interceptor/auth_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/connectivity_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/custom_baseurl_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/network_connection_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/request_header_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/response_interceptor.dart';
import 'package:price_sense/app/core/network/interceptor/retry_interceptor.dart';

final class ApiService extends GetxService {
  static ApiService get to => Get.find();
  late final Dio _dio;

  @override
  void onInit() {
    super.onInit();
    _dio = Dio(_baseOptions());
    _attachSecurity();
    _attachInterceptors();
  }

  // Options
  BaseOptions _baseOptions() => BaseOptions(
        baseUrl: ApiEndpoints.baseUrl,
        connectTimeout: const Duration(seconds: AppConstants.connectTimeout),
        receiveTimeout: const Duration(seconds: AppConstants.receiveTimeout),
        sendTimeout: const Duration(seconds: AppConstants.sendTimeout),
        headers: {
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.acceptHeader: 'application/json',
          'X-Platform': Platform.isAndroid ? 'android' : 'ios',
          'X-App-Version': const String.fromEnvironment('APP_VERSION', defaultValue: '1.0.0'),
        },
        validateStatus: (s) => s != null && s < 500,
      );

  // Certificate pinning
  void _attachSecurity() {
    (_dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
      final client = HttpClient();
      client.badCertificateCallback = (cert, host, port) => false; // strict
      return client;
    };
  }

  // Interceptors
  void _attachInterceptors() {
    _dio.interceptors.addAll([
      ConnectivityInterceptor(), // ① gate: reject early if offline
      CustomBaseUrlInterceptor(), // ② rewrite base URL if provided
      RequestHeaderInterceptor(), // ③ add HMAC + nonce headers
      AuthInterceptor(_dio), // ④ attach / refresh tokens
      RetryInterceptor(_dio), // ⑤ retry on transient failures
      ResponseIntegrityInterceptor(), // ⑥ validate response shape
      NetworkConnectionInterceptor(), // ⑦ humanize error messages
      if (_isDebug) PrettyDioLogger(requestBody: true, responseBody: true, error: true, compact: true),
    ]);
  }

  static bool get _isDebug {
    bool debug = false;
    assert(() {
      debug = true;
      return true;
    }());
    return debug;
  }

  // Public API
  Future<Response<T>> get<T>(String path, {Map<String, dynamic>? query, Options? options, String? customBaseUrl}) => _dio.get(path, queryParameters: query, options: _mergeOptions(options, customBaseUrl));

  Future<Response<T>> post<T>(String path, {dynamic data, Options? options, String? customBaseUrl}) => _dio.post(path, data: data, options: _mergeOptions(options, customBaseUrl));

  Future<Response<T>> put<T>(String path, {dynamic data, Options? options, String? customBaseUrl}) => _dio.put(path, data: data, options: _mergeOptions(options, customBaseUrl));

  Future<Response<T>> delete<T>(String path, {Options? options, String? customBaseUrl}) => _dio.delete(path, options: _mergeOptions(options, customBaseUrl));

  Options _mergeOptions(Options? options, String? customBaseUrl) {
    final extra = {...?options?.extra};
    if (customBaseUrl != null) extra['baseUrl'] = customBaseUrl;
    return (options ?? Options()).copyWith(extra: extra);
  }
}

// Placeholder stubs (replace with your real implementations)
class UnauthorizedException implements Exception {
  const UnauthorizedException();
}
