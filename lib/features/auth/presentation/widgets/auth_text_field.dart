import 'package:flutter/cupertino.dart';

import '../../../../theme/app_colors.dart';

/// Cupertino labeled field (no Material [TextField]).
class AuthTextField extends StatelessWidget {
  final String label;
  final String placeholder;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;

  const AuthTextField({
    super.key,
    required this.label,
    required this.placeholder,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        CupertinoTextField(
          controller: controller,
          placeholder: placeholder,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 16),
          placeholderStyle: const TextStyle(color: AppColors.textMuted),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
