import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/binding/initial_binding.dart';

import 'app/core/routes/app_pages.dart';
import 'app/core/routes/app_routes.dart';
import 'app/core/service/secure_store_service.dart';
import 'app/core/theme/app_theme.dart';
import 'app/modules/settings/controllers/settings_controller.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Device Orientation
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// System UI Style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  /// Initialize Secure Storage
  await Get.putAsync<SecureStorageService>(() async => SecureStorageService(), permanent: true);

  /// Initialize Settings Service
  final settingsService = Get.put<SettingsController>(SettingsController(), permanent: true);

  /// Load Saved Settings
  await settingsService.initSettings();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingsController>(builder: (settings) {
      return GetMaterialApp(
        title: 'Easy Scanner',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light(settings.primaryColor),
        darkTheme: AppTheme.dark(settings.primaryColor),
        themeMode: settings.flutterThemeMode,
        locale: settings.locale,
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        initialRoute: AppRoutes.splash,
        initialBinding: InitialBinding(),
        getPages: AppPages.routes,
        defaultTransition: Transition.fadeIn,
        transitionDuration: const Duration(milliseconds: 400),
        builder: (context, child) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(
              textScaler: TextScaler.linear(settings.fontScaleFactor),
            ),
            child: child!,
          );
        },
      );
    });
  }
}
