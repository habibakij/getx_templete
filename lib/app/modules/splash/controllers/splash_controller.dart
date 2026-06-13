import 'package:flutter/animation.dart';
import 'package:get/get.dart';
import 'package:price_sense/app/core/routes/app_routes.dart';

class SplashController extends GetxController with SingleGetTickerProviderMixin {
  late AnimationController logoController;
  late AnimationController textController;
  late AnimationController pulseController;
  late AnimationController progressController;

  late Animation<double> logoScale;
  late Animation<double> logoOpacity;
  late Animation<Offset> textSlide;
  late Animation<double> textOpacity;
  late Animation<double> pulseAnimation;
  late Animation<double> progressAnimation;

  @override
  void onInit() {
    super.onInit();
    logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    pulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))
      ..repeat(reverse: true);
    progressController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    logoScale = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: logoController, curve: Curves.elasticOut));
    logoOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: logoController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)));

    textSlide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: textController, curve: Curves.easeOutCubic));
    textOpacity = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));
    pulseAnimation = Tween<double>(begin: 0.95, end: 1.05)
        .animate(CurvedAnimation(parent: pulseController, curve: Curves.easeInOut));
    progressAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: progressController, curve: Curves.easeInOut));

    _startAnimations();
    _navigateToDashboard();
  }

  @override
  void dispose() {
    logoController.dispose();
    textController.dispose();
    pulseController.dispose();
    progressController.dispose();
    super.dispose();
  }

  Future<void> _navigateToDashboard() async {
    await Future.delayed(const Duration(seconds: 5));
    Get.offAllNamed(AppRoutes.settings);
  }

  Future<void> _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    logoController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    textController.forward();
    await Future.delayed(const Duration(milliseconds: 200));
    progressController.forward();
  }
}
