// lib/core/config/app_constants.dart
import 'package:flutter/material.dart';

class AppConstants {
  // --- Colors ---
  static const Color primaryColor = Color(0xFF1A73E8); // أزرق جوجل
  static const Color secondaryColor = Color(0xFF34A853); // أخضر جوجل
  static const Color accentColor = Color(0xFFEA4335); // أحمر جوجل (للتأكيد)
  static const Color errorColor = Color(0xFFB00020); // لون خطأ قياسي
  static const Color successColor = Color(0xFF00C853); // لون نجاح
  static const Color warningColor = Color(0xFFFFAB00); // لون تحذير
  static const Color textColorDark = Color(0xFF202124); // أسود تقريبًا
  static const Color textColorLight = Color(0xFFFFFFFF); // أبيض
  static const Color backgroundColorLight = Color(0xFFFAFAFA); // أبيض فاتح جدًا
  static Color backgroundColorDark = Colors.grey.shade900;
  static const Color shadowColor = Color(0x42000000);
  static const Color disabledColor = Color(0xFFE0E0E0);
  static const Color cardBackgroundColor = Color(0xFFFFFFFF);
  static Color iconColor = AppConstants.textColorDark;
  static const Color blueDark = Color.fromARGB(255, 4, 55, 149);
  static Color greyColor = Colors.grey.shade300;
  static Color greyTextColor = Colors.blueGrey.shade800;


  // --- Gradients (Optional) ---
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF448AFF), Color(0xFF2962FF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // --- Quiz ---
  static const Color correctColor = successColor;
  static const Color wrongColor = errorColor;
  static const String correctAnswerSound = 'assets/sounds/correct.mp3';
  static const String wrongAnswerSound = 'assets/sounds/wrong.mp3';
  static const double conjugationCardRadius = 12.0;

  // --- Quiz Options Dialog Strings ---
  static const String quizOptionsTitle = "Quiz Options";
  static const String showTheWordOption = "Show The Word";
  static const String autoplayAudioOption = "Autoplay Audio";
  static const String backButtonText = "Back";
  static const String startQuizButtonText = "Start Quiz";

  // --- Sizes ---
  static const double defaultElevation = 4.0;
  static const double cardRadius = 12.0;
  static const double cardMarginVertical = 8.0;
  static const double cardMarginHorizontal = 16.0;
  static const double borderRadiusSmall = 2.0;
  static const double borderRadiusMedium = 8.0;
  static const double borderRadiusLarge = 12.0;

  // --- Fonts ---
  static const String defaultFontFamily = 'Roboto';
  static const double fontSizeSmall = 14.0;
  static const double fontSizeMedium = 16.0;
  static const double fontSizeLarge = 18.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeExtraSmall = 12.0;
  static const double fontSizeExtraLarge = 20.0;

  // --- Paddings ---
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingExtraSmall = 4.0;
  static const double paddingExtraLarge = 32.0;

  // --- Margins (From theme_constants) ---
  static const double marginExtraSmall = 4.0;
  static const double marginSmall = 8.0;
  static const double marginMedium = 16.0;
  static const double marginLarge = 24.0;
  static const double marginExtraLarge = 32.0;

  // --- Icons Sizes ---
  static const double iconSizeSmall = 24.0;
  static const double iconSizeMedium = 32.0;
  static const double iconSizeExtraSmall = 16.0;
  static const double iconSizeLarge = 40.0;
  static const double iconSizeExtraLarge = 48.0;

  // --- Animation durations ---
  static const Duration animationDurationMedium = Duration(milliseconds: 500);
  static const Duration animationDurationShort = Duration(milliseconds: 200);
  static const Duration animationDurationLong = Duration(milliseconds: 900);

    // --- Buttons Heights ---
  static const double buttonHeightSmall = 40.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  // --- Buttons Widths ---
  static const double buttonWidthSmall = 120.0;
  static const double buttonWidthMedium = 160.0;
  static const double buttonWidthLarge = 200.0;
}