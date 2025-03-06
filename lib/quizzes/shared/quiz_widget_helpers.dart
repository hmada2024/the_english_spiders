import 'package:flutter/material.dart';

ButtonStyle getButtonStyleForAnswer(
  bool isCorrect,
  bool isWrong, {
  Color? textColor,
  Color? correctColor,
  Color? wrongColor,
  Color? defaultColor,
}) {
  final theme =
      ThemeData(); // Create a ThemeData object to access colorScheme.
  Color buttonColor;
  if (isCorrect) {
    buttonColor = correctColor ?? theme.colorScheme.secondary; // MODIFIED
  } else if (isWrong) {
    buttonColor = wrongColor ?? theme.colorScheme.error; // MODIFIED
  } else {
    buttonColor = defaultColor ?? theme.colorScheme.primary; // MODIFIED
  }
  return ElevatedButton.styleFrom(
    foregroundColor: textColor ?? theme.colorScheme.onSurface, // MODIFIED
    backgroundColor: buttonColor,
    padding: EdgeInsets.zero,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
    ),
    elevation: 5.0,
  );
}

BoxDecoration getBoxDecorationForAnswer(bool isCorrect, bool isWrong,
    {required double borderRadius,
    required double shadowBlurRadius,
    required double shadowOffset,
    Color? defaultColor,
    Color? correctColor,
    Color? wrongColor,
    BoxBorder? border}) {
  final theme =
      ThemeData(); // Create a ThemeData object to access colorScheme and other theme properties.

  Color borderColor;

  if (isCorrect) {
    borderColor = correctColor ?? theme.colorScheme.secondary; // MODIFIED
  } else if (isWrong) {
    borderColor = wrongColor ?? theme.colorScheme.error; // MODIFIED
  } else {
    borderColor =
        defaultColor ?? theme.colorScheme.onSurface.withValues(alpha:0.5); // MODIFIED
  }
  return BoxDecoration(
    borderRadius: BorderRadius.circular(borderRadius),
    border: border ??
        Border.all(
          color: borderColor,
          width: 1.0, // MODIFIED
        ),
    boxShadow: [
      BoxShadow(
        color: theme.shadowColor, //MODIFIED
        spreadRadius: 0,
        blurRadius: shadowBlurRadius,
        offset: Offset(shadowOffset, shadowOffset),
      ),
    ],
  );
}