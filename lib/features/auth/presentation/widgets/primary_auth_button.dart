import 'package:flutter/cupertino.dart';

import '../../../../core/theme/app_typography.dart';
import '../../../../theme/app_colors.dart';

/// Full-width pill primary action (Cupertino only).
class PrimaryAuthButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback? onPressed;

  const PrimaryAuthButton({
    super.key,
    required this.text,
    required this.color,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: CupertinoButton.filled(
        borderRadius: BorderRadius.circular(28),
        color: color,
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTypography.buttonText.copyWith(
            fontSize: 16,
            color: AppColors.background,
          ),
        ),
      ),
    );
  }
}
