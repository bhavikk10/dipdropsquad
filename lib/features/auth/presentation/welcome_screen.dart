import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import 'widgets/google_g_logo.dart';
import 'widgets/wavy_welcome_background.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const _bgAsset = 'assets/images/welcome_background.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: Image.asset(
              _bgAsset,
              fit: BoxFit.cover,
              alignment: Alignment.center,
              filterQuality: FilterQuality.high,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: AppColors.background,
                child: WavyWelcomeBackground(),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const SizedBox(height: 56),
                Text(
                  'MYDIPSQUAD',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.6,
                    color: const Color(0xFF1A1A1A),
                    height: 1.1,
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 28),
                  child: _WelcomeAuthCard(
                    onLogIn: () => context.push('/auth/login'),
                    onSignUp: () => context.push('/auth/signup'),
                    onGoogle: () {},
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeAuthCard extends StatelessWidget {
  const _WelcomeAuthCard({
    required this.onLogIn,
    required this.onSignUp,
    required this.onGoogle,
  });

  final VoidCallback onLogIn;
  final VoidCallback onSignUp;
  final VoidCallback onGoogle;

  static const _radius = 36.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(_radius),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.95),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 36,
            offset: const Offset(0, 18),
            spreadRadius: -6,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(27),
              boxShadow: [
                BoxShadow(
                  color: AppColors.authFlowPrimary.withValues(alpha: 0.42),
                  blurRadius: 14,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 54,
              child: FilledButton(
                onPressed: onLogIn,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.authFlowPrimary,
                  foregroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
                child: Text(
                  'Log In',
                  style: AppTypography.buttonText.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: FilledButton(
              onPressed: onSignUp,
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFE5E5EA),
                foregroundColor: const Color(0xFF1A1A1A),
                shape: const StadiumBorder(),
                elevation: 0,
              ),
              child: Text(
                'Sign Up',
                style: AppTypography.buttonText.copyWith(
                  fontSize: 16,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              Expanded(
                child: Divider(
                  color: AppColors.textMuted.withValues(alpha: 0.35),
                  thickness: 1,
                  height: 1,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'OR',
                  style: AppTypography.caption.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
              Expanded(
                child: Divider(
                  color: AppColors.textMuted.withValues(alpha: 0.35),
                  thickness: 1,
                  height: 1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: OutlinedButton(
              onPressed: onGoogle,
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1A1A1A),
                side: const BorderSide(color: Color(0xFF2C2C2E), width: 1),
                shape: const StadiumBorder(),
                backgroundColor: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const GoogleGLogo(size: 22),
                  const SizedBox(width: 12),
                  Text(
                    'Continue with Google',
                    style: AppTypography.buttonText.copyWith(
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
