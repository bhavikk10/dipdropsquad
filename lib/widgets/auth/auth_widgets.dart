import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final Widget? prefix;
  final Widget? suffix;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefix,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const fill = Color(0xFF1A1A1A);
    final outline = OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    );

    return SizedBox(
      height: 56,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textAlignVertical: TextAlignVertical.center,
        style: const TextStyle(color: Colors.white),
        cursorColor: cs.primary,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Color(0xFF777777)),
          filled: true,
          fillColor: fill,
          prefix: prefix,
          suffixIcon: suffix,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          border: outline,
          enabledBorder: outline,
          focusedBorder: outline,
          disabledBorder: outline,
          errorBorder: outline,
        ),
      ),
    );
  }
}

class NeonPillButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool disabled;

  const NeonPillButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.disabled = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final neon = cs.primary;
    final isLight = Theme.of(context).brightness == Brightness.light;

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: disabled ? const Color(0xFF3A3A3A) : neon,
          borderRadius: BorderRadius.circular(16),
          boxShadow: disabled || isLight
              ? null
              : [
                  BoxShadow(
                    color: neon.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: disabled ? null : onPressed,
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: disabled ? const Color(0xFF777777) : Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class NeonOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Widget leadingIcon;

  const NeonOutlineButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.leadingIcon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Colors.white, width: 1),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: Colors.black,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leadingIcon,
            const SizedBox(width: 10),
            Text(
              text,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}

