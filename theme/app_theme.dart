import 'package:flutter/material.dart';

class AppColors {
  // Background
  static const background = Color(0xFF0A0A0A);
  static const surface = Color(0xFF141414);
  static const surfaceAlt = Color(0xFF1A1A1A);
  static const border = Color(0xFF2A2A2A);
  static const borderAlt = Color(0xFF1E1E1E);

  // Text
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFF888888);
  static const textMuted = Color(0xFF555555);
  static const textDisabled = Color(0xFF444444);

  // Accent
  static const orange = Color(0xFFFF6D00);
  static const orangeLight = Color(0x26FF6D00); // 15% opacity
  static const blue = Color(0xFF2196F3);
  static const blueLight = Color(0x262196F3); // 15% opacity
}

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark().copyWith(
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.dark(
        primary: Colors.white,
        secondary: AppColors.orange,
        surface: AppColors.surface,
      ),
    );
  }
}