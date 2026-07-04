import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  // Display
  static TextStyle display({Color? color}) => GoogleFonts.poppins(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: color ?? AppColors.textPrimary,
        height: 1.2,
      );

  static TextStyle headline({Color? color}) => GoogleFonts.poppins(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: color ?? AppColors.textPrimary,
        height: 1.3,
      );

  static TextStyle title({Color? color}) => GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: color ?? AppColors.textPrimary,
        height: 1.4,
      );

  static TextStyle body({Color? color}) => GoogleFonts.poppins(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textSecondary,
        height: 1.6,
      );

  static TextStyle bodySmall({Color? color}) => GoogleFonts.poppins(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: color ?? AppColors.textLight,
        height: 1.5,
      );

  static TextStyle label({Color? color}) => GoogleFonts.poppins(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: color ?? AppColors.textSecondary,
      );

  static TextStyle button({Color? color}) => GoogleFonts.poppins(
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
    switch (fontFamily) {
      case 'Dancing Script':
        return GoogleFonts.dancingScript(fontSize: fontSize, color: color ?? Colors.white);
      case 'Montserrat':
        return GoogleFonts.montserrat(
            fontSize: fontSize, fontWeight: FontWeight.w500, color: color ?? Colors.white);
      case 'Lato':
        return GoogleFonts.lato(fontSize: fontSize, color: color ?? Colors.white);
      case 'Sacramento':
        return GoogleFonts.sacramento(fontSize: fontSize, color: color ?? Colors.white);
      case 'Nunito':
        return GoogleFonts.nunito(fontSize: fontSize, color: color ?? Colors.white);
      default:
        return GoogleFonts.playfairDisplay(
            fontSize: fontSize, fontWeight: FontWeight.w500, color: color ?? Colors.white);
    }
  }
}
