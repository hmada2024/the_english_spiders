//lib/core/config/button_styles.dart
import 'package:flutter/material.dart';
import 'package:the_english_spiders/core/config/screen_size.dart'; // استيراد

class ButtonStyles {
  static ButtonStyle primaryStyle(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = ScreenSize.getWidth(context); // استخدام ScreenSize
    final fontSize = screenWidth * 0.05;
    final padding = screenWidth * 0.03;

    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.primary, 
      foregroundColor: theme.colorScheme.onPrimary,
      padding:EdgeInsets.symmetric(vertical: padding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      textStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        fontFamily: 'Roboto',
      ),
    );
  }

    static ButtonStyle secondaryStyle(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = ScreenSize.getWidth(context);
    final fontSize = screenWidth * 0.04;
    final padding = screenWidth * 0.025;
    return ElevatedButton.styleFrom(
      backgroundColor: theme.colorScheme.secondary,
      foregroundColor: theme.colorScheme.onSecondary,
      padding: EdgeInsets.symmetric(vertical: padding, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: TextStyle(fontSize: fontSize, fontFamily: 'Roboto'),
    );
  }

  // ... أنماط أخرى ...
}