import 'package:dio/dio.dart';
import 'package:get/get_connect/http/src/response/client_response.dart';

final class ResponseIntegrityInterceptor extends Interceptor {
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final contentType = response.headers.value(HttpHeaders.contentTypeHeader) ?? '';
    // Reject unexpected content-types on JSON endpoints (prevents MIME sniffing attacks).
    if (response.requestOptions.headers[HttpHeaders.acceptHeader] == 'application/json' && !contentType.contains('application/json') && response.statusCode != 204) {
      return handler.reject(DioException(requestOptions: response.requestOptions, response: response, type: DioExceptionType.badResponse, message: 'Unexpected content-type: $contentType'));
    }
    handler.next(response);
  }
}
