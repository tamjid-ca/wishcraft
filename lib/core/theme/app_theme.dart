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
        onPrimary: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        surfaceTintColor: AppColors.primary.withValues(alpha: 0.05),
        titleTextStyle: AppTextStyles.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        foregroundColor: AppColors.textPrimary,
      ),
      textTheme: _buildTextTheme(Brightness.light),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 2,
        shadowColor: AppColors.primary.withValues(alpha: 0.12),
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
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
        selectedColor: AppColors.primary.withValues(alpha: 0.15),
        labelStyle: AppTextStyles.poppins(fontSize: 13, color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(color: AppColors.primary, width: 1),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primary : Colors.grey.shade400,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primary.withValues(alpha: 0.4)
              : Colors.grey.shade200,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.primary.withValues(alpha: 0.1),
        thickness: 1,
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
        onPrimary: Colors.white,
        secondary: AppColors.secondaryLight,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textOnDark,
        error: AppColors.error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: AppColors.surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surfaceDark,
        elevation: 0,
        scrolledUnderElevation: 2,
        centerTitle: true,
        surfaceTintColor: AppColors.primaryLight.withValues(alpha: 0.05),
        titleTextStyle: AppTextStyles.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: AppColors.textOnDark,
        ),
        iconTheme: const IconThemeData(color: AppColors.textOnDark),
        foregroundColor: AppColors.textOnDark,
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      cardTheme: CardThemeData(
        color: AppColors.cardBgDark,
        elevation: 2,
        shadowColor: Colors.black38,
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
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primaryLight,
          side: const BorderSide(color: AppColors.primaryLight, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBgDark,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.3)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryLight.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.primaryLight, width: 2),
        ),
        labelStyle: AppTextStyles.poppins(
            color: AppColors.textOnDark.withValues(alpha: 0.8)),
        hintStyle: AppTextStyles.poppins(
            color: AppColors.textOnDark.withValues(alpha: 0.4)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.cardBgDark,
        selectedColor: AppColors.primaryLight.withValues(alpha: 0.25),
        labelStyle: AppTextStyles.poppins(fontSize: 13, color: AppColors.textOnDark),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
          side: const BorderSide(color: AppColors.primaryLight, width: 1),
        ),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? AppColors.primaryLight : Colors.grey.shade600,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected)
              ? AppColors.primaryLight.withValues(alpha: 0.4)
              : Colors.grey.shade800,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: AppColors.primaryLight.withValues(alpha: 0.15),
        thickness: 1,
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
