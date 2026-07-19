import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Test-aware poppins helper
  static TextStyle poppins({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
    double? letterSpacing,
    double? height,
  }) {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return TextStyle(
        fontFamily: 'sans-serif',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        height: height,
      );
    }
    return GoogleFonts.poppins(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      fontStyle: fontStyle,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  // Test-aware getFont helper
  static TextStyle getFont(
    String fontFamily, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    FontStyle? fontStyle,
  }) {
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return TextStyle(
        fontFamily: 'sans-serif',
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
      );
    }
    try {
      return GoogleFonts.getFont(
        fontFamily,
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
      );
    } catch (_) {
      return poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        fontStyle: fontStyle,
      );
    }
  }

  // Display
  static TextStyle display({Color? color}) => poppins(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle headline({Color? color}) => poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle title({Color? color}) => poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle body({Color? color}) => poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle bodySmall({Color? color}) => poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textLight,
        height: 1.5,
      );

  static TextStyle label({Color? color}) => poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle button({Color? color}) => poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: color ?? Colors.white,
      );

  // Card-specific text styles
  static TextStyle cardWishText({
    String fontFamily = 'Playfair Display',
    double fontSize = 18,
    Color? color,
  }) {
    return getFont(
      fontFamily,
      fontSize: fontSize,
      color: color,
    );
  }
}
