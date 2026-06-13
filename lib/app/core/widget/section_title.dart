import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String label;
  final EdgeInsets? padding;
  final bool toUpperCase;
  final Color? textColor;

  const SectionHeader({super.key, required this.label, this.padding, this.toUpperCase = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        toUpperCase ? label.toUpperCase() : label,
        style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
      ),
    );
  }
}
