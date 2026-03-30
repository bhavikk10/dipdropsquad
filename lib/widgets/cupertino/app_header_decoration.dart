import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_shadows.dart';

/// Shared with [MainAppHeader]: white bar, 1.5px bottom border, subtle shadow.
class AppHeaderDecoration {
  AppHeaderDecoration._();

  static BoxDecoration get box => BoxDecoration(
        color: AppColors.background,
        border: const Border(
          bottom: BorderSide(color: Color(0xFFC7C7CC), width: 1.5),
        ),
        boxShadow: AppShadows.headerBar,
      );
}
