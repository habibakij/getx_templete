import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class BuildProgressBar extends StatelessWidget {
  final Animation<double> progressAnimation;
  const BuildProgressBar({super.key, required this.progressAnimation});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
          width: size.width * 0.55,
          height: 3,
          decoration: BoxDecoration(
            color: AppColors.darkCard,
            borderRadius: BorderRadius.circular(100),
          ),
          child: AnimatedBuilder(
            animation: progressAnimation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progressAnimation.value,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    gradient: const LinearGradient(colors: [AppColors.primary, AppColors.accent]),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.6),
                        blurRadius: 8,
                        spreadRadius: 0,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        AnimatedBuilder(
          animation: progressAnimation,
          builder: (context, _) {
            final percent = (progressAnimation.value * 100).toInt();
            return Text(
              'Loading... $percent%',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: AppColors.textMuted,
                letterSpacing: 0.5,
              ),
            );
          },
        ),
      ],
    );
  }
}
