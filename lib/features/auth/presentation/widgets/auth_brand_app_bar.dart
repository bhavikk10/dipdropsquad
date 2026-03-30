import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_icons.dart';

class AuthBrandAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AuthBrandAppBar({
    super.key,
    required this.onLeading,
    this.leadingIcon = AppIcons.backChevron,
    this.leadingColor,
  });

  final VoidCallback onLeading;
  final IconData leadingIcon;
  final Color? leadingColor;

  @override
  Size get preferredSize => const Size.fromHeight(54);

  @override
  Widget build(BuildContext context) {
    final fg = leadingColor ?? AppColors.authNavy;
    return AppBar(
      toolbarHeight: 54,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
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
        ),
      ),
      leading: IconButton(
        icon: Icon(leadingIcon, color: fg, size: 22),
        onPressed: onLeading,
      ),
      title: Text(
        'MYDIPSQUAD',
        style: AppTypography.headerDisplay,
      ),
      centerTitle: true,
    );
  }
}
