import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:price_sense/app/core/constants/app_constants.dart';

// Interceptor ③: Request signing (HMAC-SHA256)
//
// Adds:
//   X-Request-Timestamp: unix epoch (ms)
//   X-Request-Nonce:     random 16-byte hex
//   X-Request-Signature: HMAC-SHA256(secret, "timestamp.nonce.method.path")
//
// backend verifies the signature and rejects replays older than ±5 min.

final class RequestHeaderInterceptor extends Interceptor {
  static final _rng = Random.secure();

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (AppConstants.signingSecret.isEmpty) return handler.next(options);
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final nonce = _generateNonce();
    final method = options.method.toUpperCase();
    final path = options.path;
    final payload = '$timestamp.$nonce.$method.$path';
    final signature = _hmac(AppConstants.signingSecret, payload);
    options.headers['X-Request-Timestamp'] = timestamp;
    options.headers['X-Request-Nonce'] = nonce;
    options.headers['X-Request-Signature'] = signature;
    handler.next(options);
  }

  String _generateNonce() {
    final bytes = List<int>.generate(16, (_) => _rng.nextInt(256));
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  String _hmac(String secret, String message) {
    final key = utf8.encode(secret);
    final data = utf8.encode(message);
    return Hmac(sha256, key).convert(data).toString();
  }
}
