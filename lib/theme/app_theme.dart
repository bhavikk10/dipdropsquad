import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/theme/app_typography.dart';
import 'app_colors.dart';

class AppTheme {
  static PageTransitionsTheme _buildPageTransitionsTheme() {
    return const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.macOS: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.windows: FadeUpwardsPageTransitionsBuilder(),
        TargetPlatform.linux: FadeUpwardsPageTransitionsBuilder(),
      },
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.accent,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        secondary: AppColors.accent,
        background: AppColors.background,
        onBackground: AppColors.textPrimary,
        surface: AppColors.background,
        onSurface: AppColors.textPrimary,
        surfaceVariant: AppColors.background,
        onSurfaceVariant: AppColors.textMuted,
        outline: AppColors.border,
        outlineVariant: AppColors.border,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        surfaceTint: Colors.transparent,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.light().textTheme)
          .apply(
            bodyColor: AppColors.textPrimary,
            displayColor: AppColors.textPrimary,
          )
          .copyWith(
            displayLarge: AppTypography.h1,
            headlineSmall: AppTypography.h2,
            titleLarge: AppTypography.h1,
            titleMedium: AppTypography.h2,
            bodyLarge: AppTypography.bodyPrimary,
            bodyMedium: AppTypography.bodyPrimary,
            bodySmall: AppTypography.bodySecondary,
            labelLarge: AppTypography.buttonText,
            labelSmall: AppTypography.microLabel,
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.textPrimary),
      ),
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.background,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: AppColors.border,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.dipBlue,
      scaffoldBackgroundColor: AppColors.darkBackground,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.dipBlue,
        secondary: AppColors.dipBlue,
        background: AppColors.darkBackground,
        onBackground: AppColors.darkOnSurface,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkOnSurface,
        surfaceVariant: AppColors.darkPillSurface,
        onSurfaceVariant: AppColors.darkTextMuted,
        outlineVariant: AppColors.darkBorder,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme)
          .apply(
            bodyColor: AppColors.darkOnSurface,
            displayColor: AppColors.darkOnSurface,
          )
          .copyWith(
            displayLarge: AppTypography.h1.copyWith(color: AppColors.darkOnSurface),
            headlineSmall: AppTypography.h2.copyWith(color: AppColors.darkOnSurface),
            titleLarge: AppTypography.h1.copyWith(color: AppColors.darkOnSurface),
            titleMedium: AppTypography.h2.copyWith(color: AppColors.darkOnSurface),
            bodyLarge: AppTypography.bodyPrimary.copyWith(color: AppColors.darkOnSurface),
            bodyMedium: AppTypography.bodyPrimary.copyWith(color: AppColors.darkOnSurface),
            bodySmall: AppTypography.bodySecondary.copyWith(color: AppColors.darkTextMuted),
            labelLarge: AppTypography.buttonText.copyWith(color: AppColors.darkOnSurface),
            labelSmall: AppTypography.microLabel.copyWith(color: AppColors.darkOnSurface),
          ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkOnSurface,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColors.darkOnSurface),
      ),
      pageTransitionsTheme: _buildPageTransitionsTheme(),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkBackground,
        selectedItemColor: AppColors.dipBlue,
        unselectedItemColor: AppColors.darkTextMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      dividerColor: AppColors.darkBorder,
    );
  }
}
