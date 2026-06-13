import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';
import 'package:price_sense/app/modules/splash/controllers/splash_controller.dart';
import 'package:price_sense/app/modules/splash/views/widgets/build_background.dart';
import 'package:price_sense/app/modules/splash/views/widgets/build_floating_logo.dart';
import 'package:price_sense/app/modules/splash/views/widgets/build_progress_bar.dart';
import 'package:price_sense/app/modules/splash/views/widgets/build_text_title.dart';
import 'package:price_sense/app/modules/splash/views/widgets/floating_shadow.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BuildBackground(),
          FloatingShadow(pulseController: controller.pulseController),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: Listenable.merge(
                    [controller.logoController, controller.pulseController],
                  ),
                  builder: (context, child) {
                    return Opacity(
                      opacity: controller.logoOpacity.value,
                      child: Transform.scale(
                        scale: controller.logoScale.value * controller.pulseAnimation.value,
                        child: child,
                      ),
                    );
                  },
                  child: const BuildFloatingLogo(),
                ),
                const SizedBox(height: 36),
                SlideTransition(
                  position: controller.textSlide,
                  child: FadeTransition(
                    opacity: controller.textOpacity,
                    child: const BuildTextTitle(),
                  ),
                ),
                const SizedBox(height: 64),
                FadeTransition(
                  opacity: controller.textOpacity,
                  child: BuildProgressBar(progressAnimation: controller.progressAnimation),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: controller.textOpacity,
              child: Text(
                'v1.0.0',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: AppColors.textMuted,
                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
