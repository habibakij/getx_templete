import 'package:flutter/material.dart';

class DecoratedIcon extends StatelessWidget {
  final IconData icon;
  final double padding;
  const DecoratedIcon({super.key, required this.icon, this.padding = 8.0});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(color: scheme.primaryContainer, borderRadius: BorderRadius.circular(10.0)),
      child: Icon(icon, color: scheme.onPrimaryContainer, size: 20),
    );
  }
}
