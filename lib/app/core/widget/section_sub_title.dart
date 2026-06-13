import 'package:flutter/material.dart';

class SectionSubTitle extends StatelessWidget {
  final String label;
  final EdgeInsets? padding;
  final bool toUpperCase;
  final Color? textColor;

  const SectionSubTitle({super.key, required this.label, this.padding, this.toUpperCase = false, this.textColor});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        toUpperCase ? label.toUpperCase() : label,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.0,
              height: 1.12,
            ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
