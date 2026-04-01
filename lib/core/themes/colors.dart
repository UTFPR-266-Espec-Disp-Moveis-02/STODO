import 'package:flutter/material.dart';

class AppColors {
  // Primary colors
  static const Color primary = Color(0xFF3a86ff);
  static const Color primaryDark = Color(0xFF0a0e14);
  static const Color primaryMedium = Color(0xFF11171f);
  static const Color primaryDarkAccent = Color(0xFF1f2937);

  // Neutral colors
  static const Color light = Color(0xFFefefef);
  static const Color gray100 = Color(0xFFcfd2d7);
  static const Color gray200 = Color(0xFF959caa);
  static const Color gray300 = Color(0xFF6b7280);
  static const Color gray400 = Color(0xFF464b56);
  static const Color gray500 = Color(0xFF222529);
  static const Color dark = Color(0xFF0c0d0e);

  // Topic colors
  static const Color topicColor1 = Color(0xFF3a86ff);
  static const Color topicColor2 = Color(0xFFf43f5e);
  static const Color topicColor3 = Color(0xFF10b981);
  static const Color topicColor4 = Color(0xFFf59e0b);
  static const Color topicColor5 = Color(0xFFa855f7);
  static const Color topicColor6 = Color(0xFF06b6d4);
  static const Color topicColor7 = Color(0xFF6366f1);
  static const Color topicColor8 = Color(0xFFf97316);

  // Topic colors list for easy access
  static const List<Color> topicColors = [
    topicColor1,
    topicColor2,
    topicColor3,
    topicColor4,
    topicColor5,
    topicColor6,
    topicColor7,
    topicColor8,
  ];

  // Helper method to convert Color to Hex string
  static String colorToHex(Color color) {
    return '#${color.toARGB32().toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }
}
