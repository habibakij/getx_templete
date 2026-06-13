import 'package:flutter/material.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class FloatingShadow extends StatelessWidget {
  final AnimationController pulseController;
  const FloatingShadow({super.key, required this.pulseController});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final positions = [
      [0.1, 0.2],
      [0.85, 0.15],
      [0.05, 0.7],
      [0.9, 0.65],
      [0.5, 0.1],
      [0.2, 0.85],
      [0.75, 0.88]
    ];
    return Stack(
      children: positions.asMap().entries.map((entry) {
        final i = entry.key;
        final pos = entry.value;
        return Positioned(
          left: pos[0] * size.width,
          top: pos[1] * size.height,
          child: AnimatedBuilder(
            animation: pulseController,
            builder: (context, child) {
              final offset = (i % 2 == 0 ? 1 : -1) * pulseController.value * 10;
              return Transform.translate(offset: Offset(0, offset), child: child);
            },
            child: Container(
              width: i % 3 == 0 ? 6.0 : 4.0,
              height: i % 3 == 0 ? 6.0 : 4.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i % 2 == 0
                    ? AppColors.primary.withValues(alpha: 0.4)
                    : AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
