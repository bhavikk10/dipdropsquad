import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../theme/app_shadows.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Full-screen listing form (no shell / tab bar).
class NewDropScreen extends StatefulWidget {
  const NewDropScreen({super.key});

  @override
  State<NewDropScreen> createState() => _NewDropScreenState();
}

class _NewDropScreenState extends State<NewDropScreen> {
  static const _canvas = Color(0xFFF2F2F7);

  final _titleCtrl = TextEditingController();
  final _priceCtrl = TextEditingController();
  final _descCtrl = TextEditingController();

  int _visualCount = 0;
  static const _maxVisuals = 8;
  String? _category;
  String? _condition;

  @override
  void dispose() {
    _titleCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickCategory() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Category'),
        actions: [
          for (final c in ['Watches', 'Sneakers', 'Apparel', 'Accessories', 'Other'])
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() => _category = c);
                Navigator.pop(ctx);
              },
              child: Text(c),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  Future<void> _pickCondition() async {
    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        title: const Text('Condition'),
        actions: [
          for (final c in ['New', 'Like new', 'Good', 'Fair'])
            CupertinoActionSheetAction(
              onPressed: () {
                setState(() => _condition = c);
                Navigator.pop(ctx);
              },
              child: Text(c),
            ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
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
              'NEW DROP',
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
                'Post',
                style: TextStyle(
                  color: Color(0xFF2E5AAC),
                  fontWeight: FontWeight.w700,
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
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: [
                  _sectionHeader('VISUALS', trailing: '$_visualCount / $_maxVisuals'),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 96,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (_visualCount < _maxVisuals) {
                              setState(() => _visualCount++);
                            }
                          },
                          child: CustomPaint(
                            foregroundPainter: _DashedRRectPainter(
                              color: AppColors.authFlowPrimary.withValues(alpha: 0.55),
                              strokeWidth: 1.5,
                              radius: 16,
                            ),
                            child: Container(
                              width: 96,
                              height: 96,
                              alignment: Alignment.center,
                              child: const Icon(
                                CupertinoIcons.add_circled_solid,
                                size: 32,
                                color: AppColors.authFlowPrimary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        for (var i = 0; i < 3; i++) ...[
                          Container(
                            width: 96,
                            height: 96,
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          if (i < 2) const SizedBox(width: 10),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  _sectionHeader('LISTING TITLE'),
                  const SizedBox(height: 10),
                  _whiteField(
                    child: CupertinoTextField(
                      controller: _titleCtrl,
                      placeholder: 'What are you dropping?',
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: const BoxDecoration(),
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                      placeholderStyle: const TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _sectionHeader('PRICE (\$)'),
                  const SizedBox(height: 10),
                  _whiteField(
                    child: CupertinoTextField(
                      controller: _priceCtrl,
                      placeholder: '0.00',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      padding: const EdgeInsets.fromLTRB(12, 16, 16, 16),
                      decoration: const BoxDecoration(),
                      style: const TextStyle(fontSize: 16, color: AppColors.textPrimary),
                      placeholderStyle: const TextStyle(color: AppColors.textMuted),
                      prefix: const Padding(
                        padding: EdgeInsets.only(left: 14, right: 6),
                        child: Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.authFlowPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _sectionHeader('DESCRIPTION'),
                  const SizedBox(height: 10),
                  _whiteField(
                    child: CupertinoTextField(
                      controller: _descCtrl,
                      placeholder: 'Tell the squad about this item...',
                      maxLines: 5,
                      minLines: 4,
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(),
                      style: const TextStyle(fontSize: 16, height: 1.35, color: AppColors.textPrimary),
                      placeholderStyle: const TextStyle(color: AppColors.textMuted),
                    ),
                  ),
                  const SizedBox(height: 22),
                  _sectionHeader('CATEGORY & CONDITION'),
                  const SizedBox(height: 10),
                  _selectTile(
                    label: 'CATEGORY',
                    value: _category ?? 'Select Category',
                    onTap: _pickCategory,
                  ),
                  const SizedBox(height: 12),
                  _selectTile(
                    label: 'CONDITION',
                    value: _condition ?? 'Select Condition',
                    onTap: _pickCondition,
                  ),
                  const SizedBox(height: 22),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.authFlowPrimary.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.authFlowPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(
                            CupertinoIcons.check_mark_circled_solid,
                            color: AppColors.authFlowPrimary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            'Your listing will be visible to the MyDipSquad community immediately after publishing.',
                            style: TextStyle(
                              fontSize: 14,
                              height: 1.4,
                              color: AppColors.textPrimary,
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

  Widget _sectionHeader(String title, {String? trailing}) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.9,
            color: AppColors.textMuted,
          ),
        ),
        if (trailing != null) ...[
          const Spacer(),
          Text(
            trailing,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ],
    );
  }

  Widget _whiteField({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: child,
    );
  }

  Widget _selectTile({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 12, 14),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(18),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.6,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: value.startsWith('Select') ? AppColors.textMuted : AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(
                  CupertinoIcons.chevron_down,
                  size: 18,
                  color: AppColors.authFlowPrimary,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  _DashedRRectPainter({
    required this.color,
    required this.strokeWidth,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final r = RRect.fromRectAndRadius(
      Rect.fromLTWH(strokeWidth / 2, strokeWidth / 2, size.width - strokeWidth, size.height - strokeWidth),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(r);
    final dashLen = 6.0;
    final gap = 4.0;
    for (final metric in path.computeMetrics()) {
      var d = 0.0;
      while (d < metric.length) {
        final next = (d + dashLen).clamp(0.0, metric.length);
        final extract = metric.extractPath(d, next);
        canvas.drawPath(
          extract,
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = strokeWidth,
        );
        d += dashLen + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.radius != radius;
  }
}
