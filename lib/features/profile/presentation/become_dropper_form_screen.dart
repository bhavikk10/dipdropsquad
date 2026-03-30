import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Step 2: application form to become a dropper.
class BecomeDropperFormScreen extends StatefulWidget {
  const BecomeDropperFormScreen({super.key});

  @override
  State<BecomeDropperFormScreen> createState() => _BecomeDropperFormScreenState();
}

class _BecomeDropperFormScreenState extends State<BecomeDropperFormScreen> {
  final _handleCtrl = TextEditingController(text: '@user_drops');
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _igCtrl = TextEditingController();
  final _ytCtrl = TextEditingController();
  final _xCtrl = TextEditingController();
  final _messageCtrl = TextEditingController();
  bool _hasMyDipFollowers = true;

  static const _sectionColor = AppColors.authNavy;

  @override
  void dispose() {
    _handleCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _igCtrl.dispose();
    _ytCtrl.dispose();
    _xCtrl.dispose();
    _messageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.authScreenGrey,
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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 36),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'BECOME A DROPPER\nAPPLICATION FORM',
                      style: AppTypography.h1.copyWith(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        height: 1.25,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    _sectionLabel('SQUAD VERIFICATION'),
                    const SizedBox(height: 12),
                    _HandleField(controller: _handleCtrl),
                    const SizedBox(height: 12),
                    _SoftField(
                      placeholder: 'Email address',
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 12),
                    _SoftField(
                      placeholder: 'Phone number',
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 28),
                    _sectionLabel('VERIFY YOUR ELIGIBILITY'),
                    const SizedBox(height: 12),
                    _ProofBlock(
                      linkLabel: 'Instagram Profile Link',
                      controller: _igCtrl,
                      icon: CupertinoIcons.camera_fill,
                    ),
                    const SizedBox(height: 16),
                    _ProofBlock(
                      linkLabel: 'YouTube Channel Link',
                      controller: _ytCtrl,
                      icon: CupertinoIcons.play_rectangle_fill,
                    ),
                    const SizedBox(height: 16),
                    _ProofBlock(
                      linkLabel: 'X (Twitter) Profile Link',
                      controller: _xCtrl,
                      icon: CupertinoIcons.at,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 0,
                          onPressed: () => setState(() => _hasMyDipFollowers = !_hasMyDipFollowers),
                          child: Container(
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              color: _hasMyDipFollowers ? AppColors.accent : AppColors.background,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: _hasMyDipFollowers
                                ? const Icon(CupertinoIcons.check_mark, size: 14, color: AppColors.background)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            'I have 10k+ followers on MyDipSquad.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _sectionLabel('ADDITIONAL MESSAGE TO ADMIN'),
                    const SizedBox(height: 10),
                    _MultilineBox(controller: _messageCtrl),
                    const SizedBox(height: 32),
                    CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(26),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      color: AppColors.accent,
                      onPressed: () => context.go('/profile/dropper/status'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Submit Application',
                            style: AppTypography.buttonText.copyWith(
                              fontSize: 16,
                              color: AppColors.background,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(CupertinoIcons.arrow_right, size: 18, color: AppColors.background),
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: AppTypography.microLabel.copyWith(
        fontSize: 11,
        fontWeight: FontWeight.w800,
        letterSpacing: 1.0,
        color: _sectionColor,
      ),
    );
  }
}

class _HandleField extends StatelessWidget {
  const _HandleField({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _softFieldDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Row(
        children: [
          const Icon(CupertinoIcons.person_crop_circle, size: 20, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: CupertinoTextField(
              controller: controller,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: const BoxDecoration(color: Color(0x00000000)),
              style: AppTypography.bodyPrimary.copyWith(fontSize: 15),
              placeholderStyle: AppTypography.bodySecondary.copyWith(fontSize: 15),
            ),
          ),
          Icon(CupertinoIcons.pencil, size: 18, color: AppColors.textMuted.withValues(alpha: 0.7)),
        ],
      ),
    );
  }
}

class _SoftField extends StatelessWidget {
  const _SoftField({
    required this.placeholder,
    required this.controller,
    this.keyboardType,
  });

  final String placeholder;
  final TextEditingController controller;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _softFieldDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        keyboardType: keyboardType,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: const BoxDecoration(color: Color(0x00000000)),
        style: AppTypography.bodyPrimary.copyWith(fontSize: 15),
        placeholderStyle: AppTypography.bodySecondary.copyWith(fontSize: 15),
      ),
    );
  }
}

BoxDecoration _softFieldDecoration() {
  return BoxDecoration(
    color: AppColors.background,
    borderRadius: BorderRadius.circular(22),
    boxShadow: [
      BoxShadow(
        color: const Color(0x0A000000),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
    border: Border.all(color: AppColors.border.withValues(alpha: 0.6)),
  );
}

class _ProofBlock extends StatelessWidget {
  const _ProofBlock({
    required this.linkLabel,
    required this.controller,
    required this.icon,
  });

  final String linkLabel;
  final TextEditingController controller;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: _softFieldDecoration(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Icon(icon, size: 20, color: AppColors.textMuted),
              const SizedBox(width: 10),
              Expanded(
                child: CupertinoTextField(
                  controller: controller,
                  placeholder: linkLabel,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: const BoxDecoration(color: Color(0x00000000)),
                  style: AppTypography.bodyPrimary.copyWith(fontSize: 15),
                  placeholderStyle: AppTypography.bodySecondary.copyWith(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 56,
          decoration: BoxDecoration(
            color: AppColors.onboardingFieldFill,
            borderRadius: BorderRadius.circular(18),
          ),
          child: CustomPaint(
            painter: _DashedBorderPainter(
              color: AppColors.textMuted.withValues(alpha: 0.4),
              radius: 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    '[Upload Proof Screenshot]',
                    style: AppTypography.caption.copyWith(
                      color: AppColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 14),
                  child: Icon(CupertinoIcons.cloud_upload, size: 22, color: AppColors.accent.withValues(alpha: 0.85)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.5, 0.5, size.width - 1, size.height - 1),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(r);
    const dash = 5.0;
    const gap = 3.5;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = (d + dash).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(d, next),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
        d += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) => oldDelegate.color != color;
}

class _MultilineBox extends StatelessWidget {
  const _MultilineBox({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _softFieldDecoration(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: CupertinoTextField(
        controller: controller,
        placeholder: 'Optional',
        maxLines: 4,
        minLines: 3,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(color: Color(0x00000000)),
        style: AppTypography.bodyPrimary.copyWith(fontSize: 15),
        placeholderStyle: AppTypography.bodySecondary.copyWith(fontSize: 15),
      ),
    );
  }
}
