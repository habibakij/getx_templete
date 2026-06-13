import 'package:flutter/material.dart';
import 'package:price_sense/app/core/theme/app_colors.dart';

class AppButton extends StatelessWidget {
  final Widget titleWidget;
  final VoidCallback? onPressed;
  final double height;
  final double borderRadius;
  final double elevation;
  final Color? backgroundColor;
  final bool isLoading;
  final EdgeInsetsGeometry padding;
  final IconData? prefixIcon;

  const AppButton({super.key, required this.titleWidget, required this.onPressed, this.height = 48, this.borderRadius = 8, this.elevation = 0.5, this.backgroundColor, this.isLoading = false, this.padding = const EdgeInsets.symmetric(horizontal: 16), this.prefixIcon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          elevation: elevation,
          backgroundColor: backgroundColor ?? AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(borderRadius)),
          padding: padding,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor: AlwaysStoppedAnimation(AppColors.pureWhite),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (prefixIcon != null) ...[
                    Icon(prefixIcon, size: 22, color: AppColors.pureWhite),
                    const SizedBox(width: 8),
                  ],
                  titleWidget,
                ],
              ),
      ),
    );
  }
}
