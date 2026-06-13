import 'package:get/get.dart';
import 'package:price_sense/app/modules/settings/bindings/settings_binding.dart';
import 'package:price_sense/app/modules/settings/views/settings_view.dart';
import 'package:price_sense/app/modules/splash/bindings/splash_binding.dart';
import 'package:price_sense/app/modules/splash/views/splash_view.dart';

import 'app_routes.dart';

abstract class AppPages {
  static final routes = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
      transition: Transition.fadeIn,
    ),
  ];
}
