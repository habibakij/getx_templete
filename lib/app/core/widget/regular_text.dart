import 'package:flutter/material.dart';

class RegularText extends StatelessWidget {
  final String label;
  final EdgeInsets? padding;
  final bool toUpperCase;
  final Color? textColor;
  final int? maxLine;
  final bool? centerAlign;

  const RegularText({super.key, required this.label, this.padding, this.toUpperCase = false, this.textColor, this.maxLine, this.centerAlign});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: Text(
        toUpperCase ? label.toUpperCase() : label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor ?? Theme.of(context).colorScheme.primary,
            ),
        maxLines: maxLine,
        overflow: maxLine != null ? TextOverflow.ellipsis : null,
        textAlign: centerAlign != null ? TextAlign.center : null,
      ),
    );
  }
}
