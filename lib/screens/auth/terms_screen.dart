import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/auth_gate.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_providers.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_icons.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accepted = ref.watch(termsAcceptedProvider);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.rulesPageBg,
        appBar: AppBar(
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
            icon: const Icon(AppIcons.close, color: AppColors.textPrimary, size: 26),
            onPressed: () => context.go('/auth/welcome'),
          ),
          title: Text(
            'MYDIPSQUAD',
            style: AppTypography.headerDisplay,
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'REGISTRATION GATE',
                        style: AppTypography.microLabel.copyWith(
                          letterSpacing: 1,
                          color: AppColors.rulesAccentBlue,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'PLATFORM',
                                style: AppTypography.h1.copyWith(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.5,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 118,
                                height: 5,
                                decoration: BoxDecoration(
                                  color: AppColors.rulesAccentBlue,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 6, bottom: 7),
                            child: Text(
                              ' RULES',
                              style: AppTypography.h1.copyWith(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 0.5,
                                height: 1,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.fromLTRB(22, 22, 22, 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.06),
                              blurRadius: 24,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _section(
                              '1. Acceptance of Terms',
                              'By accessing MyDipSquad you agree to follow these platform rules and any updates we may post. If you do not agree, please discontinue use of the service.',
                            ),
                            _section(
                              '2. Community Standards',
                              'Treat others with respect. Harassment, hate speech, doxxing, and illegal activity are prohibited. We may remove content or accounts that violate these standards.',
                            ),
                            _section(
                              '3. Marketplace & transactions',
                              'MyDipSquad connects buyers and sellers. We are not a party to transactions between users and are not responsible for shipping, refunds, or disputes that occur off-platform.',
                            ),
                            _section(
                              '4. Privacy',
                              'We process personal data as described in our Privacy Policy. By using the app you acknowledge how we collect, use, and protect your information.',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      InkWell(
                        onTap: () {
                          final v = !accepted;
                          ref.read(termsAcceptedProvider.notifier).state = v;
                          AuthGate.termsAccepted = v;
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: accepted
                                        ? AppColors.authFlowPrimary
                                        : Colors.grey.shade400,
                                    width: 1.5,
                                  ),
                                  color: accepted ? AppColors.authFlowPrimary : Colors.white,
                                ),
                                child: accepted
                                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                                    : null,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'I have read and agree to the rules.',
                                  style: AppTypography.bodyPrimary.copyWith(
                                    fontSize: 15,
                                    height: 1.35,
                                  ),
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
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 12),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: FilledButton(
                    onPressed: accepted
                        ? () {
                            AuthGate.termsAccepted = true;
                            context.go('/');
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      disabledBackgroundColor: AppColors.authFlowPrimary.withValues(alpha: 0.4),
                      backgroundColor: AppColors.authFlowPrimary,
                      foregroundColor: Colors.white,
                      elevation: accepted ? 4 : 0,
                      shadowColor: AppColors.authFlowPrimary.withValues(alpha: 0.35),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      'I AGREE',
                      style: AppTypography.buttonText.copyWith(
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  'Last updated: October 2023',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _section(String title, String body) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.buttonText.copyWith(
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            body,
            style: AppTypography.bodySecondary.copyWith(
              height: 1.5,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
