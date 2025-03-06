// lib/core/constants/screen_size.dart
import 'package:flutter/material.dart';

class ScreenSize {
  static double getWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double getHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  // إضافة دالة التحقق من الجهاز اللوحي
  static bool isTablet(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final shortestSide = size.shortestSide;
    return shortestSide >= 600; // 600 بكسل هو الحد الفاصل عادةً للأجهزة اللوحية
  }
}
