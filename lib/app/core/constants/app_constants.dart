import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // API
  static const int connectTimeout = 15; // sec
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
  static const int maxRetryAttempts = 3;
  static const int retryBaseDelay = 300; // ms

  // Auth Keys
  static const String accessTokenKey = 'access_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String pinKey = 'wallet_pin';

  // Settings Keys
  static const sTheme = 'theme_mode';
  static const sLocale = 'locale';
  static const sPrimaryColor = 'primary_color';
  static const sNotifications = 'notifications';
  static const sSound = 'sound';
  static const sVibration = 'vibration';
  static const sTextSize = 'text_size';
  static const sBiometric = 'biometric';
  static const sAutoLock = 'auto_lock';

  // Transaction
  static const double minTransactionAmount = 0.01;
  static const double maxTransactionAmount = 50000.0;
  static const int transactionPageSize = 20;

  // Token
  static const int tokenRefreshBufferSeconds = 60;
  static const String placeHolderImage = "https://developers.elementor.com/docs/assets/img/elementor-placeholder-image.png";

  /// SHA-256 fingerprints of your server leaf / intermediate certs.
  static const pinnedFingerprints = <String>[
    'AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99:AA:BB:CC:DD:EE:FF:00:11:22:33:44:55:66:77:88:99',
  ];

  /// HMAC request-signing secret — load from dart-define / flutter_secure_storage in prod.
  static const signingSecret = String.fromEnvironment('API_SIGNING_SECRET', defaultValue: '');
}
