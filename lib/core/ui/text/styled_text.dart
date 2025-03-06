//lib/core/widgets/text/styled_text.dart
import 'package:flutter/material.dart';

class StyledText extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSize;

  const StyledText({
    super.key,
    required this.text,
    required this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: fontSize,
        ),
      ),
    );
  }
}