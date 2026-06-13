import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/service/secure_store_service.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

enum AppThemeMode { light, dark, system }

enum TextSizeOption { small, medium, large }

class SettingsController extends GetxController {
  final storage = Get.find<SecureStorageService>();

  /// Default Reactive States
  AppThemeMode _themeMode = AppThemeMode.light;
  Locale _locale = const Locale('en');
  Color _primaryColor = AppColors.primary;
  TextSizeOption _textSize = TextSizeOption.medium;
  bool _notifications = true;
  bool _sound = true;
  bool _vibration = true;
  bool _biometric = false;
  bool _autoLock = false;

  // Getters
  AppThemeMode get themeMode => _themeMode;
  Locale get locale => _locale;
  TextSizeOption get textSize => _textSize;
  Color get primaryColor => _primaryColor;
  bool get notifications => _notifications;
  bool get sound => _sound;
  bool get vibration => _vibration;
  bool get biometric => _biometric;
  bool get autoLock => _autoLock;

  ThemeMode get flutterThemeMode {
    switch (_themeMode) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  }

  double get fontScaleFactor {
    switch (_textSize) {
      case TextSizeOption.small:
        return 0.85;
      case TextSizeOption.medium:
        return 1.0;
      case TextSizeOption.large:
        return 1.2;
    }
  }

  // Initial default settings
  Future<void> initSettings() async {
    final themeName = await storage.getTheme();
    _themeMode = AppThemeMode.values.firstWhere(
      (e) => e.name.toString() == themeName.toString(),
      orElse: () => AppThemeMode.light,
    );

    final localeLang = await storage.getLocale();
    if (localeLang != null && localeLang.isNotEmpty) {
      _locale = Locale(localeLang);
    } else {
      _locale = const Locale('en');
    }

    final sizeName = await storage.getTextSize();
    _textSize = TextSizeOption.values.firstWhere(
      (e) => e.name.toString() == sizeName.toString(),
      orElse: () => TextSizeOption.medium,
    );

    final colorValue = await storage.getColor();
    if (colorValue != null) {
      _primaryColor = Color(int.parse(colorValue.toString()));
    }

    _notifications = (await storage.getNotification()) == "true";
    _sound = (await storage.getSound()) == "true";
    _vibration = (await storage.getVibrate()) == "true";
    _biometric = (await storage.getBiometric()) == "true";
    _autoLock = (await storage.getAutoLock()) == "true";
    update();
  }

  // Setters
  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await storage.saveTheme(mode.name);
    update();
  }

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    await storage.saveLocale(locale.languageCode);
    Get.updateLocale(locale);
    update();
  }

  Future<void> setPrimaryColor(Color color) async {
    _primaryColor = color;
    await storage.saveColor(color.value.toString());
    update();
  }

  Future<void> setTextSize(TextSizeOption size) async {
    _textSize = size;
    await storage.saveTextSize(size.name);
    update();
  }

  Future<void> setNotifications(bool value) async {
    _notifications = value;
    await storage.saveNotification(value.toString());
    update();
  }

  Future<void> setSound(bool value) async {
    _sound = value;
    await storage.saveSound(value.toString());
    update();
  }

  Future<void> setVibration(bool value) async {
    _vibration = value;
    await storage.saveVibrate(value.toString());
    update();
  }

  Future<void> setBiometric(bool value) async {
    _biometric = value;
    await storage.saveBiometric(value.toString());
    update();
  }

  Future<void> setAutoLock(bool value) async {
    _autoLock = value;
    storage.saveAutoLock(value.toString());
    update();
  }

  Future<void> resetToDefaults() async {
    _themeMode = AppThemeMode.light;
    _locale = const Locale('en');
    _primaryColor = const Color(0xFF6750A4);
    _notifications = true;
    _sound = true;
    _vibration = true;
    _textSize = TextSizeOption.medium;
    _biometric = false;
    _autoLock = false;
    await storage.clearAll();
    update();
  }
}
