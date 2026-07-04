import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand
  static const Color primary = Color(0xFF6B3FA0);
  static const Color primaryLight = Color(0xFF9B6FD0);
  static const Color primaryDark = Color(0xFF3D1A6E);

  // Secondary
  static const Color secondary = Color(0xFFFF6B9D);
  static const Color secondaryLight = Color(0xFFFF9BC4);
  static const Color secondaryDark = Color(0xFFCC3D71);

  // Accent
  static const Color accent = Color(0xFFFFD700);
  static const Color accentLight = Color(0xFFFFE87C);

  // Neutral
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color surface = Color(0xFFF8F4FF);
  static const Color surfaceDark = Color(0xFF1A1025);
  static const Color cardBg = Color(0xFFFFFFFF);
  static const Color cardBgDark = Color(0xFF2A1F3D);

  // Text
  static const Color textPrimary = Color(0xFF1A0A2E);
  static const Color textSecondary = Color(0xFF6B5B8A);
  static const Color textLight = Color(0xFF9B8BB4);
  static const Color textOnDark = Color(0xFFEEE8FF);

  // Status
  static const Color success = Color(0xFF4CAF50);
  static const Color error = Color(0xFFE53935);
  static const Color warning = Color(0xFFFF9800);
  static const Color info = Color(0xFF2196F3);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF6B3FA0), Color(0xFFFF6B9D)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF1A0A2E), Color(0xFF3D1A6E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFFE0D0FF), Color(0xFFF0E8FF), Color(0xFFE0D0FF)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}
