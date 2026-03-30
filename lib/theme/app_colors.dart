import 'package:flutter/material.dart';

/// Premium light product palette (Cupertino screens, design system).
class AppColors {
  static const Color background = Color(0xFFFFFFFF);
  /// Search bar, text fields, and other elevated light surfaces.
  static const Color surface = Color(0xFFF2F2F7);
  static const Color accent = Color(0xFF4F85F6);
  static const Color textPrimary = Color(0xFF111111);
  static const Color textMuted = Color(0xFF8E8E93);
  static const Color border = Color(0xFFEAEAEA);
  static const Color chatReceiverBg = Color(0xFFF2F2F7);
  static const Color chatSenderBg = Color(0xFFE1EDFF);
  static const Color success = Color(0xFF34C759);

  /// Same as [accent]; kept for existing Material light theme wiring.
  static const Color trustBlue = Color(0xFF4F85F6);

  // —— Dark / legacy Material theme ——
  static const Color darkBackground = Color(0xFF000000);
  static const Color darkSurface = Color(0xFF0C0C0C);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkTextMuted = Color(0xFFA0A0A0);
  static const Color darkBorder = Color(0xFF1A1A1A);
  static const Color darkPillSurface = Color(0xFF1A1A1A);
  static const Color dipBlue = Color(0xFF4A72B2);
  static const Color dipBlueDark = Color(0xFF1A2A4A);

  /// Placeholder behind grid images in dark contexts.
  static const Color surfaceLight = Color(0xFF1A1A1A);

  // —— Auth / marketing screens (light) ——
  /// Primary CTA background for welcome / login / signup / verify / terms agree.
  static const Color authFlowPrimary = Color(0xFF5D87FF);
  static const Color welcomeLoginBlue = Color(0xFF6482B4);
  static const Color welcomeSignUpFill = Color(0xFFE8E8EC);
  static const Color welcomeCardShadow = Color(0x1A000000);
  static const Color authScreenGrey = Color(0xFFF8F9FA);
  static const Color authNavy = Color(0xFF436195);
  static const Color rulesAccentBlue = Color(0xFF4A6D9C);
  static const Color brandPeriwinkle = Color(0xFFB8C5F0);
  static const Color joinGradientStart = Color(0xFF5B7FC4);
  static const Color joinGradientEnd = Color(0xFFC9B8F0);
  static const Color rulesPageBg = Color(0xFFF5F5F5);
  static const Color onboardingFieldFill = Color(0xFFF5F5F5);
  /// Light card behind “Secure enrollment” on signup.
  static const Color secureEnrollmentSurface = Color(0xFFE8EEF9);
}
