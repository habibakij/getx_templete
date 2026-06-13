import 'package:flutter/material.dart';
import 'package:price_sense/app/core/constants/image_asset.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class BuildFloatingLogo extends StatelessWidget {
  const BuildFloatingLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.primary, AppColors.primaryDark],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.5),
            blurRadius: 40,
            spreadRadius: 0,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 80,
            spreadRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(Icons.flag, size: 48, color: Colors.white.withValues(alpha: 0.2)),
            ClipRRect(
              borderRadius: BorderRadius.circular(24.0),
              child: Image.asset(height: 96, width: 96, getLogo, fit: BoxFit.fitHeight),
            ),
          ],
        ),
      ),
    );
  }
}
