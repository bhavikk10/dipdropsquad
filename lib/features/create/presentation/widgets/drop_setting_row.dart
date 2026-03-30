import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Settings row for create-drop details (switch or chevron).
class DropSettingRow extends StatelessWidget {
  final String title;
  final bool isSwitch;
  final bool switchValue;
  final ValueChanged<bool>? onChanged;
  final bool showBottomBorder;
  final IconData? icon;

  const DropSettingRow(
    this.title, {
    super.key,
    this.isSwitch = false,
    this.switchValue = false,
    this.onChanged,
    this.showBottomBorder = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, color: AppColors.accent, size: 22),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isSwitch)
                CupertinoSwitch(
                  value: switchValue,
                  onChanged: onChanged ?? (_) {},
                  activeTrackColor: AppColors.accent,
                )
              else
                const Icon(
                  CupertinoIcons.chevron_forward,
                  color: AppColors.textMuted,
                  size: 20,
                ),
            ],
          ),
        ),
        if (showBottomBorder)
          Container(height: 1, color: AppColors.border),
      ],
    );
  }
}
