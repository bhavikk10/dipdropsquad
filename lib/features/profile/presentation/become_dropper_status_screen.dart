import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Step 3: application submitted / pending screen.
class BecomeDropperStatusScreen extends StatelessWidget {
  const BecomeDropperStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 28),
            ),
            middle: Text(
              'Become a Dropper',
              style: AppTypography.h2.copyWith(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(36),
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              blurRadius: 24,
                              offset: const Offset(0, 12),
                            ),
                          ],
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Icon(
                              CupertinoIcons.hourglass,
                              size: 56,
                              color: AppColors.accent.withValues(alpha: 0.9),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: AppColors.accent.withValues(alpha: 0.35)),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x08000000),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'STATUS: PENDING APPROVAL',
                          style: AppTypography.microLabel.copyWith(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.9,
                            color: AppColors.authNavy,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'APPLICATION RECEIVED',
                      textAlign: TextAlign.center,
                      style: AppTypography.h1.copyWith(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        height: 1.15,
                        letterSpacing: 0.5,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Your credentials are currently being reviewed by our verification team. '
                      'This typically takes 24–48 hours.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySecondary.copyWith(
                        fontSize: 15,
                        height: 1.5,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 36),
                    Row(
                      children: [
                        Expanded(
                          child: _InfoTile(
                            label: 'SUBMITTED',
                            value: 'Today',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _InfoTile(
                            label: 'PRIORITY',
                            value: 'Standard',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColors.accent,
                      onPressed: () => context.go('/profile'),
                      child: Text(
                        'Return to Profile',
                        style: AppTypography.buttonText.copyWith(
                          fontSize: 16,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: const Color(0x06000000),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTypography.microLabel.copyWith(
              fontSize: 10,
              letterSpacing: 0.85,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: AppTypography.bodyPrimary.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
