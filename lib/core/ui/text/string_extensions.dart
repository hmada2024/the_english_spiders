//lib/core/widgets/text/string_extensions.dart
import 'package:flutter/material.dart';

extension StringFormatting on String {
  TextSpan formatWithHighlight(Color highlightColor) {
    final regex = RegExp(r'\*\*(.*?)\*\*');
    final matches = regex.allMatches(this);
    final List<InlineSpan> spans = [];
    int currentIndex = 0;

    for (final match in matches) {
      if (match.start > currentIndex) {
        spans.add(TextSpan(text: substring(currentIndex, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: TextStyle(
            fontWeight: FontWeight.bold, color: highlightColor), // تحديد النمط مرة واحدة
      ));
      currentIndex = match.end;
    }

    if (currentIndex < length) {
      spans.add(TextSpan(text: substring(currentIndex)));
    }

    return TextSpan(children: spans);
  }
}