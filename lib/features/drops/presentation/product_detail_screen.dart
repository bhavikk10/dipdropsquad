import 'dart:ui' show ImageFilter;

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_typography.dart';
import '../../../models/models.dart';
import '../../../providers/mock_data_provider.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_icons.dart';
import '../../../widgets/cupertino/app_header_bar.dart';

/// Drop / product detail — light theme, reference layout + finish/size selectors.
class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.dropId});

  final String dropId;

  @override
  ConsumerState<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  int _imageIndex = 0;
  int _finishIndex = 1;
  int _sizeIndex = 1;
  bool _saved = false;
  bool _heroLiked = false;

  static const _sizes = ['40mm', '42mm', '44mm', '46mm'];

  static const _finishColors = <Color>[
    Color(0xFFE8E8E8),
    Color(0xFF111111),
    AppColors.accent,
  ];

  static const _ctaBlue = AppColors.authFlowPrimary;

  @override
  Widget build(BuildContext context) {
    final drop = ref.watch(dropByIdProvider(widget.dropId));
    final mutualFollow = ref.watch(mutualFollowProvider);
    final dips = ref.watch(dipsProvider);
    final profile = ref.watch(userProfileProvider);

    if (drop == null) {
      return ColoredBox(
        color: AppColors.background,
        child: Column(
          children: [
            _buildNavBar(context, title: ''),
            Expanded(
              child: Center(
                child: Text('Drop not found', style: AppTypography.bodySecondary),
              ),
            ),
          ],
        ),
      );
    }

    final images = drop.galleryUrls.isNotEmpty ? drop.galleryUrls : <String>[drop.imageUrl];

    Dip? sellerDip;
    for (final d in dips) {
      if (d.linkedDrop?.id == widget.dropId) {
        sellerDip = d;
        break;
      }
    }
    final sellerProf = ref.watch(profileByHandleProvider(drop.sellerHandle));
    final sellerName = sellerDip?.headerTitle ?? sellerProf?.displayName ?? 'Seller';
    final sellerAvatar = sellerDip?.userAvatarUrl ?? sellerProf?.avatarUrl ?? profile.avatarUrl;

    final badgeUp = drop.badge.toUpperCase();
    final inStock = !badgeUp.contains('OUT OF STOCK') && !badgeUp.contains('SOLD OUT');
    final seriesLabel = badgeUp.replaceAll(' ', ' / ');
    final msrp = (drop.price * 1.28);

    return ColoredBox(
      color: AppColors.background,
      child: Column(
        children: [
          _buildNavBar(context, title: 'DIP • DROP'),
          Expanded(
            child: Stack(
              children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 100),
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: SizedBox(
                      height: 380,
                      width: double.infinity,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ColoredBox(color: AppColors.surface),
                          PageView.builder(
                            itemCount: images.length,
                            onPageChanged: (i) => setState(() => _imageIndex = i),
                            itemBuilder: (context, i) {
                              return Image.network(
                                images[i],
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => const Center(
                                  child: Icon(
                                    AppIcons.photo,
                                    size: 48,
                                    color: AppColors.textMuted,
                                  ),
                                ),
                              );
                            },
                          ),
                          Positioned(
                            top: 12,
                            left: 0,
                            right: 0,
                            child: Center(
                              child: Container(
                                width: 36,
                                height: 4,
                                decoration: BoxDecoration(
                                  color: AppColors.textPrimary.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 14,
                            right: 14,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                _RoundImageAction(
                                  icon: _heroLiked ? AppIcons.heartFill : AppIcons.heartOutline,
                                  onPressed: () => setState(() => _heroLiked = !_heroLiked),
                                  filled: _heroLiked,
                                ),
                                const SizedBox(height: 10),
                                _RoundImageAction(
                                  icon: AppIcons.share,
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 14,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(images.length, (i) {
                                final active = i == _imageIndex;
                                return AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),
                                  curve: Curves.easeOut,
                                  width: active ? 28 : 8,
                                  height: 3,
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: active ? AppColors.textPrimary : AppColors.border,
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        seriesLabel,
                        style: AppTypography.caption.copyWith(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.9,
                          color: _ctaBlue,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        drop.title,
                        style: AppTypography.h1.copyWith(
                          fontSize: 26,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            '\$${_formatMoney(drop.price)}',
                            style: AppTypography.h1.copyWith(
                              fontSize: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            '\$${_formatMoney(msrp)}',
                            style: AppTypography.buttonText.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textMuted,
                              decoration: TextDecoration.lineThrough,
                              decorationColor: AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              drop.subtitle,
                              style: AppTypography.bodySecondary,
                            ),
                          ),
                          Text(
                            inStock ? 'IN STOCK' : 'CHECK AVAILABILITY',
                            style: AppTypography.microLabel.copyWith(
                              letterSpacing: 0.6,
                              color: inStock ? AppColors.success : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        drop.description.isNotEmpty
                            ? drop.description
                            : 'Designed for the modern explorer. Featuring a minimalist brushed steel finish and squad-ready detailing.',
                        style: AppTypography.bodySecondary.copyWith(height: 1.55),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'SELECT FINISH',
                        style: AppTypography.h2.copyWith(
                          fontSize: 12,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: List.generate(_finishColors.length, (i) {
                          final selected = _finishIndex == i;
                          return Padding(
                            padding: EdgeInsets.only(right: i == _finishColors.length - 1 ? 0 : 14),
                            child: GestureDetector(
                              onTap: () => setState(() => _finishIndex = i),
                              child: SizedBox(
                                width: 48,
                                height: 48,
                                child: Center(
                                  child: Container(
                                    width: 44,
                                    height: 44,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: selected ? AppColors.textPrimary : const Color(0x00000000),
                                        width: 2,
                                      ),
                                    ),
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: _finishColors[i],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SELECT SIZE',
                            style: AppTypography.h2.copyWith(
                              fontSize: 12,
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {},
                            child: Text(
                              'Size Guide',
                              style: AppTypography.caption.copyWith(
                                color: AppColors.accent,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(_sizes.length, (i) {
                          final disabled = i == 3;
                          final selected = _sizeIndex == i && !disabled;
                          return GestureDetector(
                            onTap: disabled ? null : () => setState(() => _sizeIndex = i),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: selected
                                    ? AppColors.textPrimary
                                    : (disabled ? AppColors.surface.withValues(alpha: 0.5) : AppColors.surface),
                                borderRadius: BorderRadius.circular(24),
                                border: Border.all(
                                  color: selected ? AppColors.textPrimary : AppColors.border,
                                ),
                              ),
                              child: Text(
                                _sizes[i],
                                style: AppTypography.bodyPrimary.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: disabled
                                      ? AppColors.textMuted
                                      : (selected ? AppColors.background : AppColors.textPrimary),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: _InfoMiniCard(
                          icon: CupertinoIcons.checkmark_seal_fill,
                          label: 'AUTHENTICITY',
                          value: 'Certified Original',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _InfoMiniCard(
                          icon: CupertinoIcons.cube_box_fill,
                          label: 'SHIPPING',
                          value: 'Global Express',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      children: [
                        ClipOval(
                          child: Image.network(
                            sellerAvatar,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: AppColors.border,
                              child: const Icon(CupertinoIcons.person_fill, color: AppColors.textMuted),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'DROPPED BY',
                                style: AppTypography.microLabel.copyWith(
                                  letterSpacing: 0.6,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                sellerName,
                                style: AppTypography.h2,
                              ),
                            ],
                          ),
                        ),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(999),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Text(
                              'FOLLOW',
                              style: AppTypography.caption.copyWith(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 28),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.background.withValues(alpha: 0.95),
                    border: const Border(top: BorderSide(color: AppColors.border)),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 48,
                            height: 48,
                            child: CupertinoButton(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(12),
                              padding: EdgeInsets.zero,
                              onPressed: () => setState(() => _saved = !_saved),
                              child: Icon(
                                _saved ? AppIcons.bookmarkFill : AppIcons.bookmarkOutline,
                                color: AppColors.textPrimary,
                                size: 22,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 48,
                              child: CupertinoButton.filled(
                                borderRadius: BorderRadius.circular(12),
                                color: _ctaBlue,
                                padding: EdgeInsets.zero,
                                onPressed: () {
                                  if (mutualFollow) {
                                    context.push('/chat/room/${widget.dropId}');
                                  }
                                },
                                child: Text(
                                  "I'm Interested",
                                  style: AppTypography.buttonText.copyWith(
                                    fontSize: 16,
                                    color: AppColors.background,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar(BuildContext context, {required String title}) {
    Widget circleBtn({required VoidCallback onPressed, required Widget child}) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onPressed,
        child: Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Center(child: child),
        ),
      );
    }

    final back = circleBtn(
      onPressed: () => context.pop(),
      child: const Icon(AppIcons.backChevron, color: AppColors.textPrimary, size: 20),
    );
    final menu = circleBtn(
      onPressed: () {},
      child: const Icon(AppIcons.more, color: AppColors.textPrimary, size: 18),
    );

    return AppHeaderBar(
      leading: back,
      middle: title.isEmpty
          ? null
          : Text(
              title,
              style: AppTypography.caption.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.6,
                color: AppColors.textPrimary,
              ),
            ),
      trailing: title.isNotEmpty ? menu : null,
    );
  }

  static String _formatMoney(double v) => v.toStringAsFixed(2);
}

class _RoundImageAction extends StatelessWidget {
  const _RoundImageAction({
    required this.icon,
    required this.onPressed,
    this.filled = false,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onPressed,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.background.withValues(alpha: 0.92),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0x14000000),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: filled ? AppColors.authFlowPrimary : AppColors.textPrimary,
        ),
      ),
    );
  }
}

class _InfoMiniCard extends StatelessWidget {
  const _InfoMiniCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.textPrimary, size: 22),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTypography.microLabel.copyWith(
              letterSpacing: 0.6,
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: AppTypography.bodyPrimary.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
