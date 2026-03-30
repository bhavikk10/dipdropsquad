import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Step 1: marketing intro for becoming a dropper.
class BecomeDropperIntroScreen extends StatelessWidget {
  const BecomeDropperIntroScreen({super.key});

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
            middle: const Text(
              'Become a Dropper',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                letterSpacing: 0.4,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(28),
                        gradient: const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            AppColors.joinGradientStart,
                            AppColors.joinGradientEnd,
                          ],
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.topCenter,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 40),
                              child: Icon(
                                CupertinoIcons.cube_fill,
                                size: 120,
                                color: AppColors.background.withOpacity(0.9),
                              ),
                            ),
                          ),
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.welcomeCardShadow,
                                  blurRadius: 18,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                            child: const Icon(
                              CupertinoIcons.checkmark_seal_fill,
                              size: 44,
                              color: AppColors.background,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Text(
                      'START SELLING. BECOME A DROPPER.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.8,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Turn your followers into buyers. Apply to get exclusive access to post Drops and monetize your Dips.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        height: 1.45,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'MINIMUM ELIGIBILITY (ANY ONE):',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.9,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const _EligibilityTile(
                      icon: CupertinoIcons.camera_fill,
                      label: '20k+ followers on Instagram',
                    ),
                    const SizedBox(height: 12),
                    const _EligibilityTile(
                      icon: CupertinoIcons.play_rectangle_fill,
                      label: '50k+ subscribers on YouTube',
                    ),
                    const SizedBox(height: 12),
                    const _EligibilityTile(
                      icon: CupertinoIcons.at,
                      label: '20k+ followers on X (Twitter)',
                    ),
                    const SizedBox(height: 12),
                    const _EligibilityTile(
                      icon: CupertinoIcons.person_2_fill,
                      label: '10k+ followers on MyDipSquad',
                    ),
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColors.accent,
                      onPressed: () => context.push('/profile/dropper/apply'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Apply Now',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.background,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(
                            CupertinoIcons.arrow_right,
                            size: 18,
                            color: AppColors.background,
                          ),
                        ],
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

class _EligibilityTile extends StatelessWidget {
  const _EligibilityTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, size: 22, color: AppColors.accent),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

