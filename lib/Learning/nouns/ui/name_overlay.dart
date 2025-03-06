//lib/core/widgets/shared/name_overlay.dart
import 'package:flutter/material.dart';

class NameOverlay extends StatelessWidget {
  final String name;
  final double fontSize;
  final Color? textColor;

  const NameOverlay({
    super.key,
    required this.name,
    required this.fontSize,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      name,
      textAlign: TextAlign.center,
      style: theme.textTheme.titleMedium!.copyWith(
        fontSize: fontSize.clamp(14.0, 24.0),
        fontWeight: FontWeight.bold,
        color: textColor ?? theme.colorScheme.onSurface, 
      ),
    );
  }
}