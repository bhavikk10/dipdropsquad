import 'package:flutter/material.dart';

/// Subtle elevation tokens shared across bars, cards, and floating actions.
abstract final class AppShadows {
  AppShadows._();

  // —— Top bars (MainAppHeader, AppHeaderBar, auth app bars) ——
  static List<BoxShadow> get headerBar => const [
        BoxShadow(
          color: Color(0x14000000),
          offset: Offset(0, 2),
          blurRadius: 10,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 1),
          blurRadius: 3,
          spreadRadius: 0,
        ),
      ];

  // —— Bottom tab strip (casts upward onto content) ——
  static List<BoxShadow> bottomNavBar({required bool isLight}) => [
        BoxShadow(
          color: isLight
              ? const Color(0x12000000)
              : const Color(0x66000000),
          offset: const Offset(0, -3),
          blurRadius: 14,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: isLight
              ? const Color(0x08000000)
              : const Color(0x40000000),
          offset: const Offset(0, -1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  // —— Glass / frosted panels (e.g. welcome auth card) ——
  static List<BoxShadow> get frostedPanel => const [
        BoxShadow(
          color: Color(0x12000000),
          offset: Offset(0, 12),
          blurRadius: 24,
          spreadRadius: -2,
        ),
      ];

  // —— Cards & rounded panels ——
  static List<BoxShadow> get card => const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 4),
          blurRadius: 14,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: Color(0x08000000),
          offset: Offset(0, 1),
          blurRadius: 4,
          spreadRadius: 0,
        ),
      ];

  // —— Circular icon buttons (product detail, overlays) ——
  static List<BoxShadow> get softCircle => const [
        BoxShadow(
          color: Color(0x14000000),
          offset: Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];

  // —— Hairline under sticky headers / tab strips ——
  static List<BoxShadow> get hairlineDown => const [
        BoxShadow(
          color: Color(0x0F000000),
          offset: Offset(0, 2),
          blurRadius: 6,
          spreadRadius: 0,
        ),
      ];

  // —— Search fields & inputs that sit on flat backgrounds ——
  static List<BoxShadow> get searchField => const [
        BoxShadow(
          color: Color(0x0A000000),
          offset: Offset(0, 2),
          blurRadius: 8,
          spreadRadius: 0,
        ),
      ];

  // —— Center FAB (light mode: soft lift; dark uses primary glow in widget) ——
  static List<BoxShadow> fabLight(Color primary) => [
        BoxShadow(
          color: primary.withValues(alpha: 0.28),
          offset: const Offset(0, 6),
          blurRadius: 18,
          spreadRadius: -2,
        ),
        BoxShadow(
          color: const Color(0x18000000),
          offset: const Offset(0, 4),
          blurRadius: 12,
          spreadRadius: 0,
        ),
      ];
}
