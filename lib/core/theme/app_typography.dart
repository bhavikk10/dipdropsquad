import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

/// Centralized Inter typography: weights, sizes, and tracking per UI context.
abstract final class AppTypography {
  AppTypography._();

  /// Top app bar: "MYDIPSQUAD" and matching brand strips.
  static TextStyle get headerDisplay => GoogleFonts.inter(
        fontSize: 18,
        fontWeight: FontWeight.w900,
        letterSpacing: 1.5,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );

  /// Main page titles (product names, "Welcome Back", etc.).
  static TextStyle get h1 => GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );

  /// Section / list headers ("New", "SELECT FINISH", etc.).
  static TextStyle get h2 => GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );

  /// Standard body, primary chat lines, names, descriptions.
  static TextStyle get bodyPrimary => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );

  /// Secondary lines, @usernames, subdued descriptions.
  static TextStyle get bodySecondary => GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        decoration: TextDecoration.none,
      );

  /// Timestamps, hints, feed/chat meta ("2m", "• 4h").
  static TextStyle get caption => GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textMuted,
        decoration: TextDecoration.none,
      );

  /// Primary and filled buttons.
  static TextStyle get buttonText => GoogleFonts.inter(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );

  /// Small tags: "IN STOCK", unread badges, ALL CAPS micro labels.
  static TextStyle get microLabel => GoogleFonts.inter(
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.5,
        color: AppColors.textPrimary,
        decoration: TextDecoration.none,
      );
}
