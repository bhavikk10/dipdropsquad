import 'package:flutter/cupertino.dart';

import '../../theme/app_colors.dart';

/// Cupertino-only labeled text field (no Material).
class CustomCupertinoInput extends StatelessWidget {
  final String label;
  final String placeholder;
  final int maxLines;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Widget? prefix;

  const CustomCupertinoInput({
    super.key,
    required this.label,
    required this.placeholder,
    this.maxLines = 1,
    this.controller,
    this.keyboardType,
    this.prefix,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          maxLines: maxLines,
          keyboardType: keyboardType,
          padding: const EdgeInsets.all(16),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          placeholderStyle: const TextStyle(color: AppColors.textMuted),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
          prefix: prefix,
        ),
      ],
    );
  }
}
