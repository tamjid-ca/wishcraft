import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      textTheme: _buildTextTheme(Brightness.light),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 4,
        shadowColor: AppColors.primary.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          textStyle: AppTextStyles.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: AppTextStyles.poppins(color: AppColors.textSecondary),
        hintStyle: AppTextStyles.poppins(color: AppColors.textLight),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surface,
        selectedColor: AppColors.primary.withOpacity(0.15),
        labelStyle: AppTextStyles.poppins(fontSize: 13),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primaryLight,
        secondary: AppColors.secondaryLight,
        surface: AppColors.surfaceDark,
        error: AppColors.error,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      cardTheme: CardThemeData(
        color: AppColors.cardBgDark,
        elevation: 4,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryLight,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          textStyle: AppTextStyles.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBgDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight.withOpacity(0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight.withOpacity(0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        labelStyle: AppTextStyles.poppins(color: AppColors.textOnDark.withOpacity(0.8)),
        hintStyle: AppTextStyles.poppins(color: AppColors.textOnDark.withOpacity(0.4)),
      ),
    );
  }

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseColor =
        brightness == Brightness.light ? AppColors.textPrimary : AppColors.textOnDark;
    return TextTheme(
      displayLarge: AppTextStyles.poppins(
          fontSize: 57, fontWeight: FontWeight.w700, color: baseColor),
      displayMedium: AppTextStyles.poppins(
          fontSize: 45, fontWeight: FontWeight.w600, color: baseColor),
      displaySmall: AppTextStyles.poppins(
          fontSize: 36, fontWeight: FontWeight.w600, color: baseColor),
      headlineLarge: AppTextStyles.poppins(
          fontSize: 32, fontWeight: FontWeight.w700, color: baseColor),
      headlineMedium: AppTextStyles.poppins(
          fontSize: 28, fontWeight: FontWeight.w600, color: baseColor),
      headlineSmall: AppTextStyles.poppins(
          fontSize: 24, fontWeight: FontWeight.w600, color: baseColor),
      titleLarge: AppTextStyles.poppins(
          fontSize: 22, fontWeight: FontWeight.w600, color: baseColor),
      titleMedium: AppTextStyles.poppins(
          fontSize: 16, fontWeight: FontWeight.w600, color: baseColor),
      titleSmall: AppTextStyles.poppins(
          fontSize: 14, fontWeight: FontWeight.w500, color: baseColor),
      bodyLarge: AppTextStyles.poppins(
          fontSize: 16, fontWeight: FontWeight.w400, color: baseColor),
      bodyMedium: AppTextStyles.poppins(
          fontSize: 14, fontWeight: FontWeight.w400, color: baseColor),
      bodySmall: AppTextStyles.poppins(
          fontSize: 12, fontWeight: FontWeight.w400, color: baseColor),
      labelLarge: AppTextStyles.poppins(
          fontSize: 14, fontWeight: FontWeight.w600, color: baseColor),
      labelMedium: AppTextStyles.poppins(
          fontSize: 12, fontWeight: FontWeight.w500, color: baseColor),
      labelSmall: AppTextStyles.poppins(
          fontSize: 10, fontWeight: FontWeight.w500, color: baseColor),
    );
  }
}
