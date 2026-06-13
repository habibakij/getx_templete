import 'package:flutter/material.dart';

class ExtraSmall extends StatelessWidget {
  final String label;
  final EdgeInsets? padding;
  final bool toUpperCase;
  final Color? textColor;

  const ExtraSmall({super.key, required this.label, this.padding, this.toUpperCase = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        toUpperCase ? label.toUpperCase() : label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.primary,
              letterSpacing: 0.1,
            ),
      ),
    );
  }
}
