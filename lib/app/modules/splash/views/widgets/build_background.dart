import 'package:flutter/material.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class BuildBackground extends StatelessWidget {
  const BuildBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(decoration: const BoxDecoration(color: AppColors.darkBg)),
        Positioned(
          top: -size.height * 0.1,
          left: -size.width * 0.2,
          child: Container(
            width: size.width * 0.8,
            height: size.width * 0.8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.primary.withValues(alpha: 0.25), Colors.transparent],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -size.height * 0.05,
          right: -size.width * 0.2,
          child: Container(
            width: size.width * 0.7,
            height: size.width * 0.7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [AppColors.accent.withValues(alpha: 0.12), Colors.transparent],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
