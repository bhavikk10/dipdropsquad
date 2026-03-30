import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

/// Shared with [MainAppHeader]: white bar, 1.5px bottom border, subtle shadow.
class AppHeaderDecoration {
  AppHeaderDecoration._();

  static BoxDecoration get box => BoxDecoration(
        color: AppColors.background,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFC7C7CC), width: 1.5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.05),
            offset: const Offset(0, 2),
            blurRadius: 4,
          ),
        ],
      );
}
