import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_shadows.dart';
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

/// Auth actions card. Constructor is intentionally non-`const` so hot reload can update this widget
/// after shape/token changes without “Const class cannot remove fields” failures.
class _WelcomeAuthCard extends StatelessWidget {
  _WelcomeAuthCard({
    required this.onLogIn,
    required this.onSignUp,
    required this.onGoogle,
  });

  final VoidCallback onLogIn;
  final VoidCallback onSignUp;
  final VoidCallback onGoogle;

  /// Card corners — tighter than pill buttons; pairs with [LoginScreen] field/button radius family.
  static const _cardRadius = 24.0;
  /// Capsule / stadium buttons (fully rounded ends), shared with [LoginScreen] primary CTAs.
  static final _pillShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(999),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_cardRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(24, 28, 24, 26),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(_cardRadius),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.72),
              width: 1.2,
            ),
            boxShadow: AppShadows.frostedPanel,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton(
                  onPressed: onLogIn,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.authFlowPrimary,
                    foregroundColor: Colors.white,
                    elevation: 4,
                    shadowColor:
                        AppColors.authFlowPrimary.withValues(alpha: 0.35),
                    shape: _pillShape,
                  ),
                  child: Text(
                    'Log In',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 1,
                      color: Colors.white,
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
                    elevation: 0,
                    shape: _pillShape,
                  ),
                  child: Text(
                    'Sign Up',
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 0.5,
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
                    side: BorderSide(
                      color: const Color(0xFF2C2C2E).withValues(alpha: 0.85),
                      width: 1,
                    ),
                    shape: _pillShape,
                    backgroundColor: Colors.white.withValues(alpha: 0.92),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const GoogleGLogo(size: 22),
                      const SizedBox(width: 12),
                      Text(
                        'Continue with Google',
                        style: GoogleFonts.inter(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
