import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Colors;
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Full-screen new post (“Dip”) composer — no shell / tab bar.
class NewDipScreen extends StatefulWidget {
  const NewDipScreen({super.key});

  @override
  State<NewDipScreen> createState() => _NewDipScreenState();
}

class _NewDipScreenState extends State<NewDipScreen> {
  static const _canvas = Color(0xFFF5F5F5);
  static const _linkDropBg = Color(0xFFE8EEF9);

  final _captionCtrl = TextEditingController();
  bool _linkDrop = false;
  double _mediaScale = 1;

  @override
  void dispose() {
    _captionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _canvas,
      child: Column(
        children: [
          AppHeaderBar(
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.pop(),
              child: const Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 28),
            ),
            middle: const Text(
              'NEW DIP',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 16,
                letterSpacing: 0.4,
                color: AppColors.textPrimary,
              ),
            ),
            trailing: CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minSize: 0,
              onPressed: () {},
              child: const Text(
                'Share',
                style: TextStyle(
                  color: AppColors.authFlowPrimary,
                  fontWeight: FontWeight.w800,
                  fontSize: 17,
                ),
              ),
            ),
          ),
          Expanded(
            child: SafeArea(
              top: false,
              child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
          children: [
            GestureDetector(
              onTapDown: (_) => setState(() => _mediaScale = 0.985),
              onTapUp: (_) => setState(() => _mediaScale = 1),
              onTapCancel: () => setState(() => _mediaScale = 1),
              onTap: () {},
              child: AnimatedScale(
                scale: _mediaScale,
                duration: const Duration(milliseconds: 160),
                curve: Curves.easeOutCubic,
                child: Container(
                  height: MediaQuery.sizeOf(context).height * 0.38,
                  constraints: const BoxConstraints(minHeight: 260, maxHeight: 420),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 92,
                        height: 92,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 92,
                              height: 92,
                              decoration: const BoxDecoration(
                                color: AppColors.surface,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                CupertinoIcons.camera_fill,
                                size: 38,
                                color: AppColors.textMuted,
                              ),
                            ),
                            Positioned(
                              right: 4,
                              bottom: 4,
                              child: Container(
                                width: 26,
                                height: 26,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppColors.border, width: 1),
                                ),
                                child: const Icon(
                                  CupertinoIcons.plus,
                                  size: 16,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Tap to add media',
                        style: TextStyle(
                          fontSize: 15,
                          color: AppColors.textMuted.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CupertinoTextField(
                controller: _captionCtrl,
                placeholder: 'Write a caption or add hashtags...',
                maxLines: 4,
                minLines: 3,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(),
                style: const TextStyle(fontSize: 16, height: 1.35, color: AppColors.textPrimary),
                placeholderStyle: const TextStyle(color: AppColors.textMuted),
              ),
            ),
            const SizedBox(height: 14),
            _linkRow(
              icon: CupertinoIcons.person_crop_circle_badge_plus,
              label: 'Tag People',
              onTap: () {},
            ),
            const SizedBox(height: 10),
            _linkRow(
              icon: CupertinoIcons.location_fill,
              label: 'Add Location',
              onTap: () {},
            ),
            const SizedBox(height: 18),
            AnimatedContainer(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _linkDropBg,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Link a Drop to this Dip',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      CupertinoSwitch(
                        value: _linkDrop,
                        activeTrackColor: AppColors.authFlowPrimary,
                        onChanged: (v) => setState(() => _linkDrop = v),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Allow followers to buy an item directly from this post.',
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.35,
                      color: AppColors.textMuted.withValues(alpha: 0.95),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AnimatedCrossFade(
                    duration: const Duration(milliseconds: 280),
                    firstCurve: Curves.easeOutCubic,
                    secondCurve: Curves.easeOutCubic,
                    crossFadeState: _linkDrop ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                    firstChild: const SizedBox.shrink(),
                    secondChild: CustomPaint(
                      foregroundPainter: _DipDropDashPainter(
                        color: AppColors.border,
                        radius: 14,
                      ),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: const Color(0xFFC7C7CC),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                CupertinoIcons.bag_fill,
                                color: AppColors.background,
                                size: 22,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 8,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Container(
                                    height: 8,
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              CupertinoIcons.add_circled_solid,
                              color: AppColors.authFlowPrimary,
                              size: 28,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
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

  Widget _linkRow({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.authFlowPrimary, size: 22),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const Spacer(),
            Icon(
              CupertinoIcons.chevron_right,
              size: 18,
              color: AppColors.textMuted.withValues(alpha: 0.7),
            ),
          ],
        ),
      ),
    );
  }
}

class _DipDropDashPainter extends CustomPainter {
  _DipDropDashPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(r);
    const dashLen = 5.0;
    const gap = 3.5;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = (d + dashLen).clamp(0.0, metric.length);
        canvas.drawPath(
          metric.extractPath(d, next),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.2,
        );
        d += dashLen + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DipDropDashPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
