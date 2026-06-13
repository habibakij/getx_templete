import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/constants/app_constants.dart';

/// GetX service — lives for the full app lifecycle.
/// Wraps [FlutterSecureStorage] with platform-specific encryption options.
class SecureStorageService extends GetxService {
  static SecureStorageService get to => Get.find();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AndroidOptions _android = const AndroidOptions(encryptedSharedPreferences: true);
  final IOSOptions _ios = const IOSOptions();

  Future<void> _save(String key, String value) async {
    await _storage.write(key: key, value: value, aOptions: _android, iOptions: _ios);
  }

  Future<String?> _get(String key) async {
    return await _storage.read(key: key, aOptions: _android, iOptions: _ios);
  }

  Future<void> remove(String key) async {
    await _storage.delete(key: key, aOptions: _android, iOptions: _ios);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll(aOptions: _android, iOptions: _ios);
  }

  Future<bool> hasValidSession() async {
    final t = await getAccessToken();
    return t != null && t.isNotEmpty;
  }

  // Auth
  Future<void> saveAccessToken(String token) async => await _save(AppConstants.accessTokenKey, token);
  Future<void> saveRefreshToken(String token) async => await _save(AppConstants.refreshTokenKey, token);
  Future<void> saveUserId(String id) async => await _save(AppConstants.userIdKey, id);

  Future<String?> getAccessToken() async => await _get(AppConstants.accessTokenKey);
  Future<String?> getRefreshToken() async => await _get(AppConstants.refreshTokenKey);
  Future<String?> getUserId() async => await _get(AppConstants.userIdKey);

  // Settings
  Future<void> saveTheme(String value) async => await _save(AppConstants.sTheme, value);
  Future<void> saveLocale(String value) async => await _save(AppConstants.sLocale, value);
  Future<void> saveColor(String value) async => await _save(AppConstants.sPrimaryColor, value);
  Future<void> saveNotification(String value) async => await _save(AppConstants.sNotifications, value);
  Future<void> saveTextSize(String value) async => await _save(AppConstants.sTextSize, value);
  Future<void> saveSound(String value) async => await _save(AppConstants.sSound, value);
  Future<void> saveVibrate(String value) async => await _save(AppConstants.sVibration, value);
  Future<void> saveBiometric(String value) async => await _save(AppConstants.sBiometric, value);
  Future<void> saveAutoLock(String value) async => await _save(AppConstants.sAutoLock, value);

  Future<String?> getTheme() async => await _get(AppConstants.sTheme);
  Future<String?> getLocale() async => await _get(AppConstants.sLocale);
  Future<String?> getColor() async => await _get(AppConstants.sPrimaryColor);
  Future<String?> getNotification() async => await _get(AppConstants.sNotifications);
  Future<String?> getTextSize() async => await _get(AppConstants.sTextSize);
  Future<String?> getSound() async => await _get(AppConstants.sSound);
  Future<String?> getVibrate() async => await _get(AppConstants.sVibration);
  Future<String?> getBiometric() async => await _get(AppConstants.sBiometric);
  Future<String?> getAutoLock() async => await _get(AppConstants.sAutoLock);
}
